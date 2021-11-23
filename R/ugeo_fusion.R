#' Fusionner des polygones sf
#'
#' @param polygones_sf Objet sf contenant les objets à fusionner.
#' @param distance_buffer Distance du tampon à constituer autour de l'objet fusionné
#'     (en km, approximatif).
#'
#' @return Le polygone issu de la fusion.
#' @export
#'
#' @importFrom sf st_combine st_buffer st_as_sf
#'
#' @examples
#' \dontrun{
#' bretagne <- depts %>%
#'   filter(code %in% c("22", "29", "35", "56")) %>%
#'   ugeo_fusion(distance_buffer = 0.01)
#' }
ugeo_fusion <- function(polygones_sf,
                        distance_buffer)

{

  polygones_sf %>%
    st_combine() %>% # fusion
    st_buffer(dist = distance_buffer / 200) %>%  # buffer mis à l'échelle du km
    st_as_sf() # la classe sf est perdue lors des opérations précédentes

}
