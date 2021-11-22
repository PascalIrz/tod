#' Lire les fichiers shapefiles contenus dans un répertoire
#'
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire où sont stockés les shapefiles.
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
#' sf_liste <- ign_urba_lire_shapes(repertoire_donnees_brutes = "raw_data/prescription_surf")
#' }
ign_urba_lire_shapes <- function(repertoire_donnees_brutes)

              {
  # liste des shapefiles
  shapefiles <- list.files(repertoire_donnees_brutes,
                           pattern = ".shp$",
                           recursive = TRUE,
                           full.names = TRUE)

  # lecture avec rgdal qui gère mieux l'encodage que sf
  sf_list <- map(.x = shapefiles,
                 .f = readOGR,
                 use_iconv = TRUE,
                 encoding = "UTF-8")

  # passage en sf
  map(.x = sf_list,
      .f = st_as_sf)

              }
