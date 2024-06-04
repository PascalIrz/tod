#' Lire les fichiers shapefiles contenus dans un répertoire
#'
#' @param repertoire Texte. Chemin vers le répertoire où sont stockés les shapefiles.
#'
#' @return Une liste contenant un objet de classe sf par shapefile.
#' @export
#'
#' @importFrom rgdal readOGR
#' @importFrom sf st_as_sf
#' @importFrom purrr map
#'
#' @examples
#' \dontrun{
#' sf_liste <- ign_urba_lire_shapes(repertoire = "raw_data/prescription_surf")
#' }
ign_urba_lire_shapes <- function(repertoire)

              {
  # liste des shapefiles
  shapefiles <- list.files(repertoire,
                           pattern = ".shp$",
                           recursive = TRUE,
                           full.names = TRUE)

  # lecture avec rgdal qui gère mieux l'encodage que sf
  sf_list <- map(.x = shapefiles,
                 .f = rgdal::readOGR,
                 use_iconv = TRUE,
                 encoding = "UTF-8")

  # passage en sf
  map(.x = sf_list,
      .f = sf::st_as_sf)

              }
