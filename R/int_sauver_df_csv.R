#' Sauvegarder un dataframe en csv
#'
#' @param df_data Objet à sauvegarder, de classe df (dataframe).
#' @param nom_fichier Caractère. Nom du fichier à sauvegarder.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'
#' @return Le fichier csv dans le répertoire choisi.
#'
#' @keywords internal
#' @noRd
#'
#' @importFrom readr write_csv2
#'
#' @examples
#' \dontrun{
#' int_sauver_df_csv(df_data = donnees,
#' repertoire_donnees_brutes = "../raw_data",
#' nom_fichier = "correspondance_depts_regions.csv")
#' }
int_sauver_df_csv <- function(df_data,
                              repertoire_donnees_brutes,
                              nom_fichier)

{
  if (!is.na(repertoire_donnees_brutes))

  {
    if (!dir.exists(repertoire_donnees_brutes))
    {
      dir.create(repertoire_donnees_brutes)
    }

    chemin_fichier <- paste0(repertoire_donnees_brutes,
                             "/",
                             nom_fichier)


    chemin_fichier <- ifelse(test = str_sub(nom_fichier, start = -4L) == ".csv",
                             paste0(chemin_fichier, ".csv"),
                             chemin_fichier)


    write_csv2(x = df_data,
               file = chemin_fichier)

  }


}
