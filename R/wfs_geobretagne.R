#' Accéder au flux WFS GéoBretagne
#'
#' @param url_wfs Texte. URL du flux.
#' @param couche Texte. Nom de la couche. Par défaut "sage_dreal".
#'
#' @return L'objet de classe sf retourné par le flux. Par défaut les SAGEs de Bretagne.
#'
#' @importFrom sf st_read st_write st_sf st_drop_geometry st_geometry
#' @importFrom httr parse_url
#' @importFrom gdalUtilities ogr2ogr
#' @export
#'
#' @examples
#' \dontrun{
#' sages <- tod::sf_geobretagne()
#' mapview::mapview(sages)
#' }
wfs_geobretagne <- function(url_wfs = "https://geobretagne.fr/geoserver/dreal_b/",
                            couche = "sage_dreal")
{

url <- paste0(url_wfs, couche, "/wfs?")
url <- parse_url(url)

url$query <- list(service = "wfs",
                  version = "2.0.0", # facultative
                  request = "GetCapabilities"
)

requete <- build_url(url)


sages <- sf::st_read(requete)

# pb pas moyen de manipuler cet objet => solution sur
# https://gis.stackexchange.com/questions/389814/r-st-centroid-geos-error-unknown-wkb-type-12/389854#389854
ensure_multipolygons <- function(X)
  {
  tmp1 <- tempfile(fileext = ".gpkg")
  tmp2 <- tempfile(fileext = ".gpkg")
  sf::st_write(X, tmp1)
  gdalUtilities::ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
  Y <- st_read(tmp2)
  st_sf(st_drop_geometry(X), geom = st_geometry(Y))
  }

sages <- ensure_multipolygons(sages)

}

