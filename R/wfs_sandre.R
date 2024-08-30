#' Requêter les flux WFS proposés sur www.sandre.eaufrance.fr
#'
#' @param url_wfs Caractère. URL du flux WFS.
#' @param couche Caractère. Nom de la couche à charger.
#'
#' @return Un objet de classe sf correspondant à la couche choisie.
#' @export
#'
#' @importFrom sf st_read
#' @importFrom httr parse_url build_url
#' @importFrom stringr str_sub
#'
#' @examples
#' \dontrun{
#' bassins <- wfs_sandre(url_wfs = "https://services.sandre.eaufrance.fr/geo/sandre?",
#'                      couche = "BassinDCE")
#' }
wfs_sandre <- function(url_wfs,
                       couche)

{

  # au cas où l'utilisateur a oublié le ? final
  if(str_sub(url_wfs, start = -1) != "?")
    url_wfs <- paste0(url_wfs, "?")

  # construction de la requête
  url <- parse_url(url_wfs)

  url$query <- list(service = "wfs",
                   version = "2.0.0", # facultative
                   request = "GetCapabilities")

  requete <- build_url(url)

  # chargement des données
  st_read(requete,
          layer = couche)


}



