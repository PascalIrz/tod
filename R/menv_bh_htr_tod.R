#' Télécharger les données hydrologiques en temps réel sur une station.
#'
#' Plus d'informations sur
#'     https://hubeau.eaufrance.fr/page/api-hydrometrie#/hydrometrie/observations
#'
#' Le nom de la fonction correspond à "menv" pour la source, le ministère de l'environnement,
#'     "bh" pour la banque HYDRO, "htr" pour "hydrologie temps réel" et "tod" pour
#'     "téléchargement open data".
#'
#' @param bbox Voir lien ci-dessus.
#' @param code_entite Idem.
#' @param cursor Idem.
#' @param date_debut_obs Idem.
#' @param date_fin_obs Idem.
#' @param distance Idem.
#' @param fields Idem.
#' @param grandeur_hydro Idem.
#' @param latitude Idem.
#' @param longitude Idem.
#' @param size Idem.
#' @param sort Idem.
#' @param timestep Idem.
#'
#' @return Un dataframe avec les données téléchargées.
#' @export
#'
#' @importFrom httr GET warn_for_status stop_for_status content
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' \dontrun{
#' debits <- menv_bh_htr_tod(code_entite = "J7010610",
#'                           grandeur_hydro = "Q",
#'                           timestep = 60) %>%
#'   mutate(date_obs = lubridate::ymd_hms(date_obs) %>% as.Date())
#'
#' debits %>% filter(grandeur_hydro == "Q") %>%
#'   ggplot(aes(x = date_obs, y = resultat_obs)) +
#'   geom_point() +
#'   scale_x_date(date_labels = "%d/%m")
#' }
menv_bh_htr_tod <-
  function(bbox = NULL,
           code_entite = NULL,
           cursor = NULL,
           date_debut_obs = NULL,
           date_fin_obs = NULL,
           distance = NULL,
           fields = NULL,
           grandeur_hydro = NULL,
           latitude = NULL,
           longitude = NULL,
           size = 20000,
           sort = NULL,
           timestep = NULL) {
    url_base <-
      "https://hubeau.eaufrance.fr/api/v1/hydrometrie/observations_tr?"

    data <- httr::GET(
      url_base,
      query = list(
        bbox = bbox,
        code_entite = code_entite,
        cursor = cursor,
        date_debut_obs = date_debut_obs,
        date_fin_obs = date_fin_obs,
        distance = distance,
        fields = fields,
        grandeur_hydro = grandeur_hydro,
        latitude = latitude,
        longitude = longitude,
        size = size,
        sort = sort,
        timestep = timestep
      )
    )

    httr::warn_for_status(data)
    httr::stop_for_status(data)

    data %>%
      httr::content(as = 'text') %>%
      jsonlite::fromJSON() %>%
      .$data

  }
