#' Requêter les flux WFS proposés sur www.sandre.eaufrance.fr
#'
#' @param url_wfs Caractère. URL du flux WFS.
#' @param couche Caractère. Nom de la couche à charger.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'     S'il n'est pas renseigné, la donnée brute n'est pas sauvegardée.
#'
#' @return Un objet de classe sf correspondant à la couche choisie.
#' @export
#'
#' @importFrom sf st_read
#' @importFrom httr parse_url build_url
#' @importFrom stringr str_sub
#'
#' @examples
#' \dontrun{
#' bassins <- tgeo_wfs_sandre(url_wfs = "https://services.sandre.eaufrance.fr/geo/sandre?",
#'                            couche = "BassinDCE")
#' }
tgeo_wfs_sandre <- function(url_wfs,
                            couche,
                            repertoire_donnees_brutes = NA)

{

  # au cas où l'utilisateur a oublié le ? final
  if(str_sub(url_wfs, start = -1) != "?")
    url_wfs <- paste0(url_wfs, "?")

  # construction de la requête
  url <- parse_url(url_wfs)

  url$query <- list(service = "wfs",
                   version = "2.0.0", # facultative
                   request = "GetCapabilities")

  requete <- build_url(url)

  # chargement des données
  sf_data <- st_read(requete,
                  layer = couche)

  # création si besoin du répertoire de stockage des données brutes
  if(!is.na(repertoire_donnees_brutes))
  {

      if (!dir.exists(repertoire_donnees_brutes))
  {
    dir.create(repertoire_donnees_brutes)
      }

    chemin_fichier <- paste0(repertoire_donnees_brutes,
                             "_",
                             couche,
                             ".shp")

    sf_data %>%
      sf::st_write(dsn = chemin_fichier,
                   append = FALSE)
  }



  return(sf_data)


}



