#' Collecter les informations sur les points de prélèvement de la BNPE.
#'
#' Tous les paramètres sont décrits sur la page de l'API :
#'     https://hubeau.eaufrance.fr/page/api-prelevements-eau#console
#'
#' @param bbox Voir lien ci-dessus.
#' @param code_bss_point_eau Idem.
#' @param code_commune_insee Idem.
#' @param code_departement Idem.
#' @param code_nature Idem.
#' @param code_ouvrage Idem.
#' @param code_point_prelevement Idem.
#' @param code_type_milieu Idem.
#' @param code_zone_hydro Idem.
#' @param date_exploitation Idem.
#' @param fields Idem.
#' @param format Idem.
#' @param libelle_departement Idem.
#' @param nappe_accompagnement Idem.
#' @param nom_commune Idem.
#' @param nom_point_prelevement Idem.
#' @param page Idem.
#' @param size Idem.
#'
#' @return Un dataframe avec les caractéristiques des points de prélèvement sélectionnés.
#' @export
#'
#' @importFrom httr GET warn_for_status stop_for_status content
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' donnees_stations <- ofb_bnpe_pp_tod(code_departement = 29)
#' }
ofb_bnpe_pp_tod <-
  function(bbox = NULL,
           code_bss_point_eau = NULL,
           code_commune_insee = NULL,
           code_departement = NULL,
           code_nature = NULL,
           code_ouvrage = NULL,
           code_point_prelevement = NULL,
           code_type_milieu = NULL,
           code_zone_hydro = NULL,
           date_exploitation = NULL,
           fields = NULL,
           format = "json",
           libelle_departement = NULL,
           nappe_accompagnement = NULL,
           nom_commune = NULL,
           nom_point_prelevement = NULL,
           page = 1,
           size = 1000) {
    url_base <-
      "https://hubeau.eaufrance.fr/api/vbeta/prelevements/referentiel/points_prelevement?"

    data <- httr::GET(
      url_base,
      query = list(
        bbox = bbox,
        code_bss_point_eau = code_bss_point_eau,
        code_commune_insee = code_commune_insee,
        code_departement = code_departement,
        code_nature = code_nature,
        code_ouvrage = code_ouvrage,
        code_point_prelevement = code_point_prelevement,
        code_type_milieu = code_type_milieu,
        code_zone_hydro = code_zone_hydro,
        date_exploitation = date_exploitation,
        fields = fields,
        format = format,
        libelle_departement = libelle_departement,
        nappe_accompagnement = nappe_accompagnement,
        nom_commune = nom_commune,
        nom_point_prelevement = nom_point_prelevement,
        page = page,
        size = size
      )
    )

    httr::warn_for_status(data)
    httr::stop_for_status(data)

    data %>%
      httr::content(as = 'text') %>%
      jsonlite::fromJSON() %>%
      .$data

  }
