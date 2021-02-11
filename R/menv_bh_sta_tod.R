#' Collecter les informations de base sur les stations de mesure.
#'
#' Tous les paramètres sont décrits sur la page de l'API :
#'     https://hubeau.eaufrance.fr/page/api-hydrometrie#/hydrometrie/sites
#'
#' @param bbox Voir lien ci-dessus.
#' @param code_commune_site Idem.
#' @param code_cours_eau Idem.
#' @param code_departement Idem.
#' @param code_region Idem.
#' @param code_site Idem.
#' @param code_troncon_hydro_site Idem.
#' @param code_zone_hydro_site Idem.
#' @param distance Idem.
#' @param fields Idem.
#' @param latitude Idem.
#' @param libelle_cours_eau Idem.
#' @param libelle_site Idem.
#' @param longitude Idem.
#' @param page Idem.
#' @param size Idem.
#'
#' @return Un dataframe avec les caractéristiques des stations sélectionnées.
#' @export
#'
#' @importFrom httr GET warn_for_status stop_for_status content
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' donnees_stations <- menv_bh_sta_tod(code_region = 53)
#' }
menv_bh_sta_tod <-
  function(bbox = NULL,
           code_commune_site = NULL,
           code_cours_eau = NULL,
           code_departement = NULL,
           code_region = NULL,
           code_site = NULL,
           code_troncon_hydro_site = NULL,
           code_zone_hydro_site = NULL,
           distance = NULL,
           fields = NULL,
           latitude = NULL,
           libelle_cours_eau = NULL,
           libelle_site = NULL,
           longitude = NULL,
           page = NULL,
           size = 1000) {
    url_base <-
      "https://hubeau.eaufrance.fr/api/v1/hydrometrie/referentiel/sites?"

    data <- httr::GET(
      url_base,
      query = list(
        bbox = bbox,
        code_commune_site = code_commune_site,
        code_cours_eau = code_cours_eau,
        code_departement = code_departement,
        code_region = code_region,
        code_site = code_site,
        code_troncon_hydro_site = code_troncon_hydro_site,
        code_zone_hydro_site = code_zone_hydro_site,
        distance = distance,
        fields = fields,
        latitude = latitude,
        libelle_cours_eau = libelle_cours_eau,
        libelle_site = libelle_site,
        longitude = longitude,
        page = page,
        size = 10000
      )
    )

    httr::warn_for_status(data)
    httr::stop_for_status(data)

    data %>%
      httr::content(as = 'text') %>%
      jsonlite::fromJSON() %>%
      .$data

  }
