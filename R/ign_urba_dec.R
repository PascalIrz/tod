#' Décompresser les fichiers zip de l'API portail de l'urbanisme.
#'
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire où sont stockés les fichiers
#'     compressés.
#'
#' @return Autant de sous-répertoire qu'il y a de fichiers .zip.
#' @export
#'
#' @importFrom stringr str_sub
#' @importFrom purrr walk2
#' @importFrom utils unzip
#'
#' @examples
#' \dontrun{
#' dec_ign_urba(repertoire_donnees_brutes = "raw_data/prescription_surf")
#' }
ign_urba_dec <- function(repertoire_donnees_brutes) {

  path_files_to_unzip <- list.files(path = repertoire_donnees_brutes,
                                    pattern = ".zip$",
                                    full.names = TRUE)

  dest_repo_names <- paste0(repertoire_donnees_brutes,
                            "/",
                            list.files(path = repertoire_donnees_brutes, pattern = ".zip$")) %>%
    str_sub(end = -5)

  # décompression
  walk2(.x = path_files_to_unzip,
        files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE,
        .y = dest_repo_names,
        .f = unzip)

}
