#' Agréger des polygones sf selon un facteur
#'
#' @param polygones_sf Objet sf contenant les objets à agréger
#' @param variable_aggregation Caractère. Nom de la variable qui sert à constituer les
#'     agrégats (par exemple le code région).
#'
#' @return Objet sf agrégé.
#' @export
#'
#' @importFrom sf st_union
#' @importFrom dplyr group_by across all_of summarise
#'
#' @examples
#' \dontrun{
#' bretagne <- depts %>%
#'   filter(code %in% c("22", "29", "35", "56")) %>%
#'   ugeo_fusion(distance_buffer = 0.01)
#' }
ugeo_aggr <- function(polygones_sf,
                      variable_aggregation)

{
  polygones_sf %>%
    group_by(across(all_of(variable_aggregation))) %>%
    summarise(geometry = st_union(geometry))
}
