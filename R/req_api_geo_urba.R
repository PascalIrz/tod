#' Télécharger des couches shapefile depuis le géoportail de l'urbanisme.
#'
#' Si l'emprise géographique est vaste, le nombre d'éléments géographiques excède la
#'     limite de l'API (10 000), auquel cas le téléchargement est effectué par "paquets"
#'     dont la taille est paramétrable.
#'
#' ATTENTION : d'éventuels anciens fichiers portant les mêmes noms que ceux téléchargés
#'     dans le même répertoire seraient écrasés.
#'
#' @param couche Texte. Nom de la couche à télécharger.
#' @param index_debut Numérique. Index du premier des éléments géographiques à télécharger.
#' @param nb_elements_par_telech Numérique. Nombre d'éléments à télécharger par paquet.
#' @param n_tot_elements_a_telech Numérique. Si l'on le connaît, le nombre total d'éléments
#'     géographiques à télécharger.
#' @param repertoire Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'     Par défaut, c'est un sous répertoire de "raw_data" nommé d'après la couche. S'il n'existe
#'     pas, la fonction le crée.
#'
#' @return Les fichiers téléchargés.
#' @export
#'
#' @importFrom curl curl_download
#' @importFrom stringr str_trim str_sub
#' @importFrom magrittr '%>%'
#'
#' @examples
#' \dontrun{
#' req_api_geo_urba(couche = "wfs_du:prescription_lin",
#' repertoire = "raw_data/req_api_geo_urba")
#' }
req_api_geo_urba <- function(couche, index_debut = 0, nb_elements_par_telech = 10000,
                             n_tot_elements_a_telech = 1e6, repertoire = NA)

{

  url_base_1 <- "https://wxs-gpu.mongeoportail.ign.fr/externe/39wtxmgtn23okfbbs1al2lz3/wfs?service=WFS&request=GetFeature&version=2.0.0&typeNames="
  url_base_2 <- "&srsName=EPSG:4326&BBOX=44,2,47,8,urn:ogc:def:crs:EPSG::4326&startindex="
  url_base_3 <- "&count="
  url_base_4 <- "&outputformat=SHAPE-ZIP"

  # Répertoire de stockage des données. S'il n'est pas spécifié, il est nommé d'après la couche et éventuellement créé
  if(is.na(repertoire))
  {
    repertoire <- paste0("raw_data/", str_sub(couche, start = 8))
  }

  if(dir.exists(repertoire) == FALSE) dir.create(repertoire)

  # Création de vecteurs contenant autant d'éléments qu'il y aura de paquets à télécharger
  startindexes <- seq(from = index_debut,
                      to = n_tot_elements_a_telech,
                      by = nb_elements_par_telech) %>%
    format(scientific = FALSE) %>% # sinon les écritures comme 1e5 font planter la requête
    str_trim(side = "both") # nettoyage des espaces qui traînent

  requetes <- paste0(url_base_1, couche, url_base_2, startindexes, url_base_3, nb_elements_par_telech, url_base_4)

  indices <- 1:length(requetes)
  chemins <- paste0(repertoire, "/fichier_", indices, ".zip")

  # Coucle sur les batch
  for(i in indices[1:length(indices)]) {

    curl_download(url = requetes[i], destfile = chemins[i]) # NB download.file() ne fonctionnait pas (timeout)
    if(file.size(chemins[i]) < 1e5) break # interruption si l'on commence à télécharger des fichiers vides

  }


}



