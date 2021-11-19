#' Télécharger les contours des communes
#'
#' Cette fonction télécharge depuis la plateforme data.gouv.fr une couche simplifiée
#'     des contours des communes au 01/01/19 et la décompresse. La source est OpenStreetMap.
#'
#' @param url Texte. URL de téléchargement du fichier GeoJSON.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire où le fichier sera stocké.
#' @param crs_sortie Numérique. Identifiant EPSG du CRS de sortie. Par défaut le CRS de sortie
#'     est le même que celui du shapefile d'origine.
#'
#' @importFrom utils download.file unzip
#' @importFrom sf read_sf st_transform
#'
#' @return Un objet sf polygone des contours des communes
#' @export
#'
#' @examples
#' \dontrun{
#' url <- "https://www.data.gouv.fr/fr/datasets/r/07b7c9a2-d1e2-4da6-9f20-01a7b72d4b12"
#' contours <- osm_communes_tod(url = url, repertoire_donnees_brutes = "raw_data", crs_sortie = 2154)
#' }
osm_communes_tod <- function(url, repertoire_donnees_brutes, crs_sortie = NA)

{
  # Téchargement du shapefile des contours des départements
  fichier_destination <- paste0(repertoire_donnees_brutes, "/communes-20190101.zip")

  download.file(url = url,
                destfile = fichier_destination,
                mode = "wb")

  # Décompression
  unzip(zipfile = fichier_destination,
        exdir = repertoire_donnees_brutes)

  geojson_communes <- paste0(repertoire_donnees_brutes, "/communes-20190101.json")

  communes <- sf::read_sf(geojson_communes)

  if (!is.na(crs_sortie))

  {

    communes <- communes %>%
      sf::st_transform(crs = crs_sortie)

  }

  communes

}
