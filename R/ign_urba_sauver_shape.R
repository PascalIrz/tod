#' Exporter un objet de classe sf en shapefile.
#'
#' @param objet_sf L'objet sf à exporter.
#' @param repertoire_sortie Texte. Chemin vers le fichier répertoire où le fichier
#'     sera écrit.
#' @param nom_fichier_sortie Texte. Nom du fichier de sortie avec son extension .shp.
#' @param scr Numérique. Numéro EPSG du système de coordonnées. La valeur par défaut
#'     est 4326, ce qui correspond au WGS84.
#'
#' @return L'objet géographique au format shapefile.
#' @export
#'
#' @importFrom sf st_write st_transform
#'
#' @examples
#' \dontrun{
#' # Sauvegarde en Lambert 93 (code EPSG 2154)
#' ign_urba_sauver_shape(objet_sf = assemblage,
#'                       scr = 2154,
#'                       repertoire_sortie = "processed_data"
#'                       nom_fichier_sortie = "prescription_lin.shp")
#' }
ign_urba_sauver_shape <- function(objet_sf, scr = NA, repertoire_sortie, nom_fichier_sortie)

          {

  if(!is.na(scr))

            {
    objet_sf <- objet_sf %>%
      st_transform(crs = scr)

  }

  chemin_fichier <- paste(repertoire_sortie, nom_fichier_sortie, sep = "/")

  objet_sf %>%
    st_write(dsn = chemin_fichier,
                 append = FALSE)

          }

