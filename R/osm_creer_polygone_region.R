#' Créer un polygone pour une région
#'
#' Créer un polygone de classe sf à partir des numéros des départements et
#'     de l'objet sf des départements
#'
#' @param departements_sf Objet sf des contours des départements. Typiquement obtenu depuis la
#'     fonction osm_depts_tod().
#' @param departements_selectionnes Caractère. Vecteur des numéros des départements.
#' @param distance_buffer Numérique. Paramètre qui détermine la largeur du buffer en km.
#'     (approximativement).
#' @param intitule_region Caractère. Intitulé de la région.
#'
#' @importFrom sf read_sf st_combine st_buffer st_as_sf
#' @importFrom dplyr filter mutate
#' @importFrom stringr str_pad
#'
#' @return Objet de classe sf décrivant le contour de la région y compris le buffer.
#' @export
#'
#' @examples
#' \dontrun{
#' region <- osm_creer_polygone_region(departements_sf = depts,
#'     departements_selectionnes = c("22", "29", "35", "56"),
#'     distance_buffer = 0.01,
#'     intitule_region = "Bretagne")
#' }
osm_creer_polygone_region <- function(departements_sf,
                                      departements_selectionnes,
                                      distance_buffer = 0,
                                      intitule_region)

{
  # au cas où l'utilisateur saisit des départements en numérique
  departements_selectionnes <- departements_selectionnes %>%
    as.character() %>%
    stringr::str_pad(width = 2,
                     side = "left",
                     pad = "0")

  # fusion des départements sélectionnés et ajout du buffer
  departements_sf %>%
    filter(code_insee %in% departements_selectionnes) %>%
    sf::st_combine() %>% # fusion des départements
    sf::st_buffer(dist = distance_buffer / 200) %>%  # buffer mis à l'échelle du km
    sf::st_as_sf() %>% # la classe sf est perdue lors des opérations précédentes
    mutate(region = intitule_region) # rajout de ce champ nécessaire pour le filtrage ultérieur des stations
}

