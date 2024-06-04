#' Assembler les objets de classe sf contenus dans une liste en un unique objet sf.
#'
#' @param liste_sf Une liste d'objets de classe sf.
#'
#' @return Un objet unique de classe sf qui est la fusion des objets de la liste
#' @export
#'
#' @importFrom purrr reduce
#'
#' @examples
#' \dontrun{
#' assemblage <- ign_urba_assembler_sf(liste_sf = sf_liste)
#' }
ign_urba_assembler_sf <- function(liste_sf)

            {

  liste_sf %>%
    reduce(rbind)

            }
