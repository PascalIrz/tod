#' Créer une couches shapefile depuis le géoportail de l'urbanisme.
#'
#' Si l'emprise géographique est vaste, le nombre d'éléments géographiques excède la
#'     limite de l'API (10 000), auquel cas le téléchargement est effectué par "paquets"
#'     dont la taille est paramétrable.
#'
#' ATTENTION : d'éventuels anciens fichiers portant les mêmes noms que ceux téléchargés
#'     dans le même répertoire seraient écrasés.
#'
#' @param couche Texte. Nom de la couche à télécharger.
#' @param ymin Numérique. Latitude minimale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param xmin Numérique. Longitude minimale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param ymax Numérique. Latitude maximale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param xmax Numérique. Longitude maximale de l'emprise géographique en WGS84 (degrés, point décimal).
#' @param scr Numérique. Numéro EPSG du système de coordonnées. La valeur par défaut
#'     est 4326, ce qui correspond au WGS84.
#' @param index_debut Numérique. Index du premier des éléments géographiques à télécharger.
#' @param nb_elements_par_telech Numérique. Nombre d'éléments à télécharger par paquet.
#' @param n_tot_elements_a_telech Numérique. Si l'on le connaît, le nombre total d'éléments
#'     géographiques à télécharger.
#' @param repertoire_donnees_brutes Texte. Chemin vers le répertoire de stockage des fichiers téléchargés.
#'     Par défaut, c'est un sous-répertoire de "raw_data" nommé d'après la couche. S'il n'existe
#'     pas, la fonction le crée.
#' @param fichier_sortie Texte. Chemin vers le fichier shapefile de sortie.
#'     Par défaut, il est dans un sous-répertoire de "processed_data" nommé d'après la couche. S'il n'existe
#'     pas, la fonction crée ce sous-répertoire.
#' @param seuil_ko Numérique. Valeur seuil de taille des fichiers shapefiles au-dessous
#'     de laquelle ils seront considérés comme vides et supprimés.
#'
#' @return Les fichiers téléchargés.
#' @export
#'
#' @importFrom curl curl_download
#' @importFrom stringr str_trim str_sub
#' @importFrom magrittr '%>%'
#'
#' @examples
#' \dontrun{
#' ma_couche <- "prescription_lin"
#' repertoire_donnees_brutes <- "raw_data/prescription_lin"
#' fichier_donnees_traitees <- "processed_data/prescription_lin.shp"

#' ign_urba_api_shp(couche = ma_couche,
#'                  xmin = -7,
#'                  ymin = 47,
#'                  xmax = -4,
#'                  ymax = 48,
#'                  repertoire_donnees_brutes = repertoire_donnees_brutes,
#'                  fichier_sortie = fichier_donnees_traitees)
#' }
ign_urba_api_shp <- function(couche,
                             ymin, xmin, ymax, xmax,
                             scr = 4326,
                             index_debut = 0,
                             nb_elements_par_telech = 10000,
                             n_tot_elements_a_telech = 1e6,
                             repertoire_donnees_brutes = NA,
                             fichier_sortie = NA,
                             seuil_ko = 2)

{


  tod::ign_urba_tod(couche = couche,
                    xmin = xmin,
                    ymin = ymin,
                    xmax = xmax,
                    ymax = ymax,
                    repertoire = repertoire_donnees_brutes)

  tod::ign_urba_dec(repertoire = repertoire_donnees_brutes)

  tod::ign_urba_net_rep(repertoire = repertoire_donnees_brutes,
                   seuil_ko = seuil_ko)

  sf_liste <- tod::ign_urba_lire_shapes(repertoire = repertoire_donnees_brutes)

  assemblage <- ign_urba_assembler_sf(liste_sf = sf_liste)

  ign_urba_sauver_shape(objet_sf = assemblage,
                        chemin = fichier_sortie,
                        scr = scr)


}
