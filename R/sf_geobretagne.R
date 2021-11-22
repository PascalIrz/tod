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
#' @importFrom gdalUtilities ogr2ogr
#'
#' @examples
#' \dontrun{
#' bassins <- tgeo_wfs_sandre(url_wfs = "https://services.sandre.eaufrance.fr/geo/sandre?",
#'                            couche = "BassinDCE")
#' }
sf_geobretagne <-
  function(url_wfs = "https://geobretagne.fr/geoserver/dreal_b/sage_dreal/wfs?",
           couche,
           repertoire_donnees_brutes = NA)
  {
    url <- parse_url(url_wfs)

    url$query <- list(service = "wfs",
                      version = "2.0.0",
                      # facultative
                      request = "GetCapabilities")

    requete <- build_url(url)


    sages <- sf::st_read(requete)

    # pb pas moyen de manipuler cet objet => solution sur
    # https://gis.stackexchange.com/questions/389814/r-st-centroid-geos-error-unknown-wkb-type-12/389854#389854
    ensure_multipolygons <- function(X)
    {
      tmp1 <- tempfile(fileext = ".gpkg")
      tmp2 <- tempfile(fileext = ".gpkg")
      sf::st_write(X, tmp1)
      ogr2ogr(tmp1,
              tmp2,
              f = "GPKG",
              nlt = "MULTIPOLYGON")
      Y <- st_read(tmp2)
      st_sf(st_drop_geometry(X),
            geom = st_geometry(Y))
    }

    # création si besoin du répertoire de stockage des données brutes
    # if(!is.na(repertoire_donnees_brutes))
    # {
    #
    #   if (!dir.exists(repertoire_donnees_brutes))
    #   {
    #     dir.create(repertoire_donnees_brutes)
    #   }
    #
    #   chemin_fichier <- paste0(repertoire_donnees_brutes,
    #                            "_",
    #                            couche,
    #                            ".shp")
    #
    #   sf_data %>%
    #     st_write(dsn = chemin_fichier,
    #              append = FALSE)
    # }

    int_sauver_sf_shp(sf_data = sf_data,
                      repertoire_donnees_brutes = repertoire_donnees_brutes,
                      couche = couche)

    sages <- ensure_multipolygons(sages)

  }


