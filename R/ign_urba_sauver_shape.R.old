#' Exporter un objet de classe sf en shapefile.
#'
#' @param objet_sf L'objet sf à exporter.
#' @param chemin Texte. Chemin vers le fichier suivi du nom du fichier avec son expension .shp.
#' @param scr Numérique. Numéro EPSG du système de coordonnées. La valeur par défaut
#'     est 4326, ce qui correspond au WGS84.
#'
#' @return L'objet géographique au format shapefile.
#' @export
#'
#' @importFrom sf st_write
#'
#' @examples
#' \dontrun{
#' # Sauvegarde en Lambert 93 (code EPSG 2154)
#' ign_urba_sauver_shape(objet_sf = assemblage,
#' scr = 2154,
#' chemin = "processed_data/prescription_lin.shp")
#' }
ign_urba_sauver_shape <- function(objet_sf, scr = NA, chemin)

          {

  if(!is.na(scr))

            {
    objet_sf <- objet_sf %>%
      sf::st_transform(crs = scr)

            }

  objet_sf %>%
    sf::st_write(dsn = chemin,
                 append = FALSE)

          }

