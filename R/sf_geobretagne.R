#' Requêter les flux WFS proposés sur https://geobretagne.fr
#'
#' @param url_wfs Caractère. URL du flux WFS.
#' @param couche Caractère. Nom de la couche à charger.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'     S'il n'est pas renseigné, la donnée brute n'est pas sauvegardée.
#'
#' @return Un objet de classe sf correspondant à la couche choisie.
#' @export
#'
#' @importFrom sf st_read st_sf st_drop_geometry st_geometry
#' @importFrom httr parse_url build_url
#' @importFrom stringr str_sub
#'
#' @examples
#' \dontrun{
#' bassins <- tgeo_wfs_sandre(url_wfs = "https://services.sandre.eaufrance.fr/geo/sandre?",
#'                            couche = "BassinDCE")
#' }
sf_geobretagne <- function(url_wfs = "https://geobretagne.fr/geoserver/dreal_b/sage_dreal/wfs?",
                           couche)
{

url <- parse_url(url_wfs)

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
  gdalUtilities::ogr2ogr(tmp1,
                         tmp2,
                         f = "GPKG",
                         nlt = "MULTIPOLYGON")
  Y <- st_read(tmp2)
  st_sf(st_drop_geometry(X),
        geom = st_geometry(Y))
  }

sages <- ensure_multipolygons(sages)

}


