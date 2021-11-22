#' Table de correspondance départements - régions
#'
#' Téléchargée depuis l'API Géo
#'
#' @param url Caractère. URL de l'API géo "départements"
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'     S'il n'est pas renseigné, la donnée brute n'est pas sauvegardée.
#'
#' @return Un dataframe indiquant l'appartenance des départements aux régions
#' @export
#'
#' @importFrom httr GET content content_type_json
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select
#' @importFrom readr write_csv2
#'
#' @examples
#' \dontrun{
#' correspondance <- ttab_geoapi_dept_reg()
#' }
ttab_geoapi_dept_reg <-
  function(url = "https://geo.api.gouv.fr/departements?fields=nom,code,codeRegion,region",
           repertoire_donnees_brutes = NA)

  {
    df <- url %>%
      GET() %>%
      content(as = "text",
              content_type_json(),
              encoding = 'UTF-8') %>%
      fromJSON(flatten = TRUE) %>%
      dplyr::select(
        nom_dept = nom,
        code_dept = code,
        nom_reg = region.nom,
        code_reg = codeRegion
      )

    # if (!is.na(repertoire_donnees_brutes))
    #
    # {
    #   if (!dir.exists(repertoire_donnees_brutes))
    #   {
    #     dir.create(repertoire_donnees_brutes)
    #   }
    #
    #   write_csv2(x = df,
    #              file = paste0(repertoire_donnees_brutes, "/table_dept_reg.csv"))
    #
    # }

    int_sauver_df_csv(df_data = df,
                      repertoire_donnees_brutes = repertoire_donnees_brutes,
                      nom_fichier = "table_dept_reg.csv")


    return(df)


  }
