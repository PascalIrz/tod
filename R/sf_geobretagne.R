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
  gdalUtilities::ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
  Y <- st_read(tmp2)
  st_sf(st_drop_geometry(X), geom = st_geometry(Y))
  }

sages <- ensure_multipolygons(sages)

}


