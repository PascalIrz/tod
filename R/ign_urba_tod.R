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
#' @param ymin Numérique. Latitude minimale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param xmin Numérique. Longitude minimale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param ymax Numérique. Latitude maximale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param xmax Numérique. Longitude maximale de l'emprise géographique en WGS84 (degrés, point décimal).
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
#' tod_ign_urba(couche = "prescription_lin",
#' xmin = -7,
#' ymin = 47,
#' xmax = -2,
#' ymax = 48,
#' repertoire = "raw_data/tod_ign_urba")
#' }
tod_ign_urba <- function(couche,
                             ymin, xmin, ymax, xmax,
                             index_debut = 0, nb_elements_par_telech = 10000,
                             n_tot_elements_a_telech = 1e6, repertoire = NA)

{

  url_base_1 <- "https://wxs-gpu.mongeoportail.ign.fr/externe/39wtxmgtn23okfbbs1al2lz3/wfs?service=WFS&request=GetFeature&version=2.0.0&typeNames=wfs_du:"
  url_base_2 <- "&srsName=EPSG:4326&BBOX="
  url_base_3 <- ",urn:ogc:def:crs:EPSG::4326&startindex="
  url_base_4 <- "&count="
  url_base_5 <- "&outputformat=SHAPE-ZIP"

  # Répertoire de stockage des données. S'il n'est pas spécifié, il est nommé d'après la couche et éventuellement créé
  if(is.na(repertoire))
  {
    repertoire <- paste0("raw_data/", couche)
  }

  if(dir.exists(repertoire) == FALSE) dir.create(repertoire)

  # Création de vecteurs contenant autant d'éléments qu'il y aura de paquets à télécharger
  startindexes <- seq(from = index_debut,
                      to = n_tot_elements_a_telech,
                      by = nb_elements_par_telech) %>%
    format(scientific = FALSE) %>% # sinon les écritures comme 1e5 font planter la requête
    str_trim(side = "both") # nettoyage des espaces qui traînent

  requetes <- paste0(url_base_1, couche,
                     url_base_2, ymin, ",", xmin, ",", ymax, ",", xmax,
                     url_base_3, startindexes,
                     url_base_4, nb_elements_par_telech,
                     url_base_5)

  indices <- 1:length(requetes)
  chemins <- paste0(repertoire, "/fichier_", indices, ".zip")

  # Coucle sur les batch
  for(i in indices[1:length(indices)]) {

    curl_download(url = requetes[i], destfile = chemins[i]) # NB download.file() ne fonctionnait pas (timeout)
    if(file.size(chemins[i]) < 1e5) break # interruption si l'on commence à télécharger des fichiers vides

  }


}
