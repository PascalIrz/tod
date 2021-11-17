library(httr) # generic webservice package
library(tidyverse) # a suite of packages for data wrangling, transformation, plotting, ...
library(ows4R) # interface for OGC webservices
library(sf)

# Flux Sandre
#--------------------------------------
wfs_sandre <- "https://services.sandre.eaufrance.fr/geo/sandre?"

url_sandre <- parse_url(wfs_sandre)

url_sandre$query <- list(service = "wfs",
                         version = "2.0.0", # facultative
                         request = "GetCapabilities"
                        )

request_sandre <- build_url(url_sandre)

# couches
#bv_spe_me_surf <- sf::st_read(request_sandre, layer = "BVSpeMasseDEauSurface_VEDL2019_FXX")
bassins_dce <- sf::st_read(request_sandre, layer = "BassinDCE")



# Flux Zonage de plannification (ZPL)
#--------------------------------------

wfs_zpl <- "https://services.sandre.eaufrance.fr/geo/zpl?"

url_zpl <- parse_url(wfs_zpl)

url_zpl$query <- list(service = "wfs",
                      version = "2.0.0", # facultative
                      request = "GetCapabilities"
)

request_zpl <- build_url(url_zpl)

# couches
sages <- sf::st_read(request_zpl,
                     layer = "SAGE_FXX")

mapview::mapview(sages)



# flux TOPAGE
# ---------------------------------

wfs_topage <- "https://services.sandre.eaufrance.fr/geo/topage?"

url_topage <- parse_url(wfs_topage)

url_topage$query <- list(service = "wfs",
                         version = "2.0.0", # facultative
                         request = "GetCapabilities"
)

request_topage <- build_url(url_topage)


bassins_hydro <- sf::st_read(request_topage, layer = "BassinHydrographique_FXX")
bv_topo <- sf::st_read(request_topage, layer = "BassinVersantTopographique_FXX")




mapview::mapview(bassins_hydro)
ggplot(bassins_hydro) + geom_sf()




# flux GEOBRETAGNE
# ---------------------------------


wfs_sages_bzh <- "https://geobretagne.fr/geoserver/dreal_b/sage_dreal/wfs?"

url_sages_bzh <- parse_url(wfs_sages_bzh)

url_sages_bzh$query <- list(service = "wfs",
                            version = "2.0.0", # facultative
                            request = "GetCapabilities"
)

request_sages_bzh <- build_url(url_sages_bzh)


sages <- sf::st_read(request_sages_bzh)

# pb pas moyen de manipuler cet objet => solution sur
# https://gis.stackexchange.com/questions/389814/r-st-centroid-geos-error-unknown-wkb-type-12/389854#389854
ensure_multipolygons <- function(X) {
  tmp1 <- tempfile(fileext = ".gpkg")
  tmp2 <- tempfile(fileext = ".gpkg")
  sf::st_write(X, tmp1)
  gdalUtilities::ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
  Y <- st_read(tmp2)
  st_sf(st_drop_geometry(X), geom = st_geometry(Y))
}

sages <- ensure_multipolygons(sages)

mapview::mapview(sages)
