#' Table de correspondance départements - régions
#'
#' Téléchargée depuis l'API Géo
#'
#' @param url Caractère. URL de l'API géo "départements"
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
#' correspondance <- ttab_dept_reg()
#' depts <- depts %>%
#'   left_join(correspondance, by = c("code_insee" = "code"))
#' }
ttab_dept_reg <-
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

    if (!is.na(repertoire_donnees_brutes))

    {
      if (!dir.exists(repertoire_donnees_brutes))
      {
        dir.create(repertoire_donnees_brutes)
      }

      write_csv2(x = df,
                 file = paste0(repertoire_donnees_brutes, "/table_dept_reg.csv"))

    }


    return(df)


  }
