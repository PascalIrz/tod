#' Correspondance départements - régions
#'
#' @param url Caractère. URL de l'API géo "départements"
#'
#' @return Un dataframe indiquant l'appartenance des départements aux régions
#' @export
#'
#' @importFrom httr GET content content_type_json
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select
#'
#' @examples
#' \dontrun{
#' correspondance <- df_dept_reg()
#' depts <- depts %>%
#'   left_join(correspondance, by = c("code_insee" = "code"))
#' }
df_dept_reg <- function(url = "https://geo.api.gouv.fr/departements?fields=nom,code,codeRegion,region")

  {

  df <- url %>%
      GET() %>%
      content(as = "text",
              content_type_json(),
              encoding = 'UTF-8') %>%
      fromJSON(flatten = TRUE) %>%
      dplyr::select(nom_dept = nom,
                    code_dept = code,
                    nom_reg = region.nom,
                    code_reg = codeRegion)

  }
