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
#' @param repertoire_sortie Texte. Chemin vers le fichier répertoire où le fichier
#'     sera écrit.
#' @param nom_fichier_sortie Texte. Nom du fichier de sortie avec son extension .shp.
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

#' tgeo_ign_urba(couche = ma_couche,
#'                  xmin = -7,
#'                  ymin = 47,
#'                  xmax = -4,
#'                  ymax = 48,
#'                  repertoire_donnees_brutes = repertoire_donnees_brutes,
#'                  fichier_sortie = fichier_donnees_traitees)
#' }
tgeo_ign_urba <- function(couche,
                          ymin, xmin, ymax, xmax,
                          scr = 4326,
                          index_debut = 0,
                          nb_elements_par_telech = 10000,
                          n_tot_elements_a_telech = 1e6,
                          repertoire_donnees_brutes = "raw_data",
                          repertoire_sortie = NA,
                          nom_fichier_sortie = "ign_urba.shp",
                          seuil_ko = 2)

{

  # création si besoin du répertoire de stockage des données brutes
    if (!dir.exists(repertoire_donnees_brutes))
    {
      dir.create(repertoire_donnees_brutes)
    }

  # téléchargement des données brutes par batch
  tod::ign_urba_tod(couche = couche,
                    xmin = xmin,
                    ymin = ymin,
                    xmax = xmax,
                    ymax = ymax,
                    repertoire_donnees_brutes = repertoire_donnees_brutes)

  # décompression des données brutes
  tod::ign_urba_dec(repertoire_donnees_brutes = repertoire_donnees_brutes)

  # nettoyage du répertoire de stockage des données brutes
  tod::ign_urba_net_rep(repertoire_donnees_brutes = repertoire_donnees_brutes,
                        seuil_ko = seuil_ko)

  # lecture des fichiers
  sf_liste <- ign_urba_lire_shapes(repertoire_donnees_brutes = repertoire_donnees_brutes)

  # assemblage des fichiers
  assemblage <- ign_urba_assembler_sf(liste_sf = sf_liste)


  # sauvegarde du shapefile assemblé (slt si repertoire_sortie est précisé)
  if (is.na(repertoire_sortie))

    {
    repertoire_sortie <- repertoire_donnees_brutes
    }

  if (!dir.exists(repertoire_sortie))
    {
    dir.create(repertoire_sortie)
    }

    ign_urba_sauver_shape(objet_sf = assemblage,
                          repertoire_sortie = repertoire_sortie,
                          nom_fichier_sortie = nom_fichier_sortie,
                          scr = scr)

  return(assemblage)


}
