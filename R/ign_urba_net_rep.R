#' Nettoyer les répertoires de données brutes (suppression des shapefiles vides).
#'
#' @param repertoire Texte. Chemin vers le répertoire où sont stockés les shapefiles.
#' @param seuil_ko Numérique. Valeur seuil de taille des fichiers shapefiles au-dessous
#'     de laquelle ils seront considérés comme vides et supprimés.
#'
#' @return Le répertoire de données expurgé des éventuels shapefiles vides.
#' @export
#'
#' @importFrom stringr str_sub str_locate_all
#'
#' @examples
#' \dontrun{
#' ign_urba_net_rep(repertoire = "raw_data/prescription_surf")
#' }
ign_urba_net_rep <- function(repertoire, seuil_ko = 2) {

  shapefiles <- list.files(repertoire,
                           pattern = ".shp$",
                           recursive = TRUE,
                           full.names = TRUE)

  for (file in shapefiles)

  {

    if(file.size(file) < 100 * seuil_ko) # shapefile vide

    {

      dir <- file %>%
        str_sub(start = 1, end = str_locate_all(., pattern = "/") %>%
                  unlist() %>%
                  max() %>%
                  `-`(1))
      unlink(dir, recursive = TRUE)

    }

  }



}
