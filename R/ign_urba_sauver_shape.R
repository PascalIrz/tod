#' Exporter un objet de classe sf en shapefile.
#'
#' @param objet_sf L'objet sf à exporter.
#' @param chemin Texte. Chemin vers le fichier suivi du nom du fichier avec son expension .shp.
#'
#' @return L'objet géographique au format shapefile.
#' @export
#'
#' @importFrom sf st_write
#'
#' @examples
#' \dontrun{
#' ign_urba_sauver_shape(objet_sf = assemblage,
#' chemin = "processed_data/prescription_lin.shp")
#' }
ign_urba_sauver_shape <- function(objet_sf, chemin)

          {

  sf::st_write(objet_sf, dsn = chemin)

          }

