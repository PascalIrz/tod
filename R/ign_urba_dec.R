#' Décompresser les fichiers zip de l'API portail de l'urbanisme.
#'
#' @param repertoire Texte. Chemin vers le répertoire où sont stockés les fichiers
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
#' dec_ign_urba(repertoire = "raw_data/prescription_surf")
#' }
ign_urba_dec <- function(repertoire) {

  path_files_to_unzip <- list.files(path = repertoire,
                                    pattern = ".zip$",
                                    full.names = TRUE)

  dest_repo_names <- paste0(repertoire,
                            "/",
                            list.files(path = repertoire, pattern = ".zip$")) %>%
    str_sub(end = -5)

  # décompression
  walk2(.x = path_files_to_unzip,
        files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE,
        .y = dest_repo_names,
        .f = unzip)

}
