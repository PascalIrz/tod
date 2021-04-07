#' Télécharger les contours des départements
#'
#' Cette fonction télécharge depuis la plateforme data.gouv.fr une couche simplifiée
#'     des contours des départements et la décompresse. La source est OpenStreetMap.
#'
#' @param url URL de téléchargement.
#' @param repertoire Chemin vers le répertoire où le fichier sera stocké.
#'
#' @importFrom utils download.file unzip
#' @importFrom sf st_as_sf
#' @importFrom rgdal readOGR
#'
#' @return Un objet sf polygone des départements.
#' @export
#'
#' @examples
#' \dontrun{
#' url <- "https://www.data.gouv.fr/fr/datasets/r/3096e551-c68d-40ce-8972-a228c94c0ad1"
#' depts <- osm_depts_tod(url = url, repertoire = "raw_data")
#' }
osm_depts_tod <- function(url, repertoire) {

  # Téchargement du shapefile des contours des départements
  fichier_destination <- paste0(repertoire, "/departements.zip")

  download.file(url = url,
                destfile = fichier_destination,
                mode = "wb")

  # Décompression
  unzip(zipfile = fichier_destination,
        exdir = repertoire)

  # Lecture avec rgdal::readOGR() qui gère mieux l'encodage que sf::read_sf()
  unzip(zipfile = fichier_destination,
        exdir = repertoire)

  shp_depts <- paste0(repertoire, "/departements-20140306-100m.shp")

  depts <- rgdal::readOGR(shp_depts, use_iconv = TRUE) %>%
    sf::st_as_sf()

  depts

}
