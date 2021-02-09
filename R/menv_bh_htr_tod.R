#' Télécharger les données hydrologiques en temps réel sur une station. Plus d'informations sur
#'     https://hubeau.eaufrance.fr/page/api-hydrometrie#/hydrometrie/observations
#'
#' Le nom de la fonction correspond à "menv" pour la source, le ministère de l'environnement,
#'     "bh" pour la banque HYDRO, "htr" pour "hydrologie temps réel" et "tod" pour
#'     "téléchargement open data".
#'
#' @param station_id Caractères. Identifiant de la station comme "J7010610".
#' @param mesure Texte. Grandeur mesurée qui peut prendre les valeurs "Q" pour le débit ou
#'     "H" pour les hauteurs d'eau.
#' @param debut Caractère. Date de début de la série au format "jj/mm/aaaa". Par défaut le
#'     paramètre fait remonter sur une semaine à partir de l'argument 'fin'.
#' @param fin Caractère. Date de fin de la série au format "jj/mm/aaaa". Par défaut c'est la
#'     date du jour selon l'horloge interne de la machine.
#'
#' @return Dataframe.
#' @export
#'
#' @importFrom lubridate dmy ymd_hms
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr filter mutate select
#'
#' @examples
#' \dontrun{
#' data_sta <- menv_bh_htr_tod(station_id = "J7010610")
#' ggplot(data = data_sta, aes(x = date_obs, y = resultat_obs)) +
#' geom_point()
#' }
menv_bh_htr_tod <-
  function(station_id,
           mesure = "Q",
           debut = NA,
           fin = NA)

  {
    data <- data.frame()

    if (is.na(fin))
      fin <- Sys.Date() %>% format("%d/%m/%Y")
    if (is.na(debut))
      debut <- (Sys.Date() - 7) %>% format("%d/%m/%Y")

    dates <- seq.Date(from = lubridate::dmy(debut),
                      to = lubridate::dmy(fin),
                      by = "day")

    url_base <-
      "https://hubeau.eaufrance.fr/api/v1/hydrometrie/observations_tr?code_entite="
    url_sta <- paste0(url_base, station_id)
    urls <- paste0(url_sta, "&date_fin_obs=", dates)

    for (i in 1:length(dates))

    {
      data_journaliere <- urls[i] %>%
        jsonlite::fromJSON() %>%
        .$data %>%
        as.data.frame() %>%
        filter(grandeur_hydro == mesure) %>% # les débits iniquement
        select(code_site, code_station, date_obs, resultat_obs) %>%
        mutate(date_obs = ymd_hms(date_obs))

      data <- rbind(data, data_journaliere)

    }

    data

  }
