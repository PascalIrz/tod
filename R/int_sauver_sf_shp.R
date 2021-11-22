#' Sauvegarder un objet sf au format shapefile
#'
#' @param sf_data Objet sf à sauvegarder.
#' @param couche Caractère. Nom de la couche.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'
#' @return Le fichier shp dans le répertoire choisi.
#'
#' @keywords internal
#' @noRd
#'
#' @importFrom sf st_write
#'
#' @examples
#' \dontrun{
#' int_sauver_sf_shp(sf_data = depts_sf,
#' repertoire_donnees_brutes = "../raw_data",
#' couche = "2019_09_21_depts")
#' }
int_sauver_sf_shp <- function(sf_data,
                              repertoire_donnees_brutes,
                              couche)

{
  if (!is.na(repertoire_donnees_brutes))
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
      st_write(dsn = chemin_fichier,
               append = FALSE)
  }

}
