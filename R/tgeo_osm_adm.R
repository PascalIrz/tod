#' Obtenir le découpage administratif de la France
#'
#' Cette fonction télécharge depuis la plateforme data.gouv.fr les contours du
#'     découpage administratif (source : OpenStreetMap) qui est ensuite décompressé
#'     et converti en objet de classe sf. Si le répertoire de stockage des données brutes
#'     n'est pas indiqué, elles ne sont pas sauvegardées.
#'
#' @param url Texte. URL de téléchargement.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire où le fichier sera stocké.
#' @param nom_fichier_zip Texte. Nom du fichier zip à sauvegarder.
#'     Par défaut c'est "download.zip".
#'
#' @importFrom utils download.file unzip
#' @importFrom sf st_as_sf
#' @importFrom rgdal readOGR
#'
#' @return Un objet sf polygone des contours
#' @export
#'
#' @examples
#' \dontrun{
#' url <- "https://www.data.gouv.fr/fr/datasets/r/3096e551-c68d-40ce-8972-a228c94c0ad1"
#' depts <- tgeo_osm_adm(url = url, repertoire_donnees_brutes = "raw_data/depts")
#' }
tgeo_osm_adm <- function(url,
                         repertoire_donnees_brutes = NA,
                         nom_fichier_zip = "download.zip")

{

  # création si besoin du répertoire de stockage
    if(is.na(repertoire_donnees_brutes))
    {
      repertoire_donnees_brutes <- tempdir()
    }

    if (!dir.exists(repertoire_donnees_brutes))
    {
      dir.create(repertoire_donnees_brutes)
    }

  # Téchargement du shapefile des contours des départements
  fichier_destination <- paste0(repertoire_donnees_brutes,
                                "/",
                                nom_fichier_zip)

  download.file(url = url,
                destfile = fichier_destination,
                mode = "wb")

  # Décompression
  unzip(zipfile = fichier_destination,
        exdir = repertoire_donnees_brutes)

  # shapefile à lire
  shp_depts <- list.files(path = repertoire_donnees_brutes,
                          pattern = ".shp$")

  shp_depts <- paste0(repertoire_donnees_brutes,
                      "/",
                      shp_depts)

  # Lecture avec rgdal::readOGR() qui gère mieux l'encodage que sf::read_sf()
  depts <- readOGR(shp_depts,
                   use_iconv = TRUE) %>%
    st_as_sf()

  depts

}
