#' Aggréger les entités hydrographiques
#'
#' A partir du découpage le plus fin proposé par la fonction sie_carthage_bassins_tod()
#'     du package {tod}, qui est volumineux (+ de 6000 polygones), permet d'agréger les
#'     Zones HYdro en Sous-secteurs Hydro, Secteurs Hydro ou Régions hydro.
#'
#' @param echelle Caractère. Au choix entre "Zone_Hydro", "Sous_Secteur_Hydro", "Secteur_Hydro"
#'     et "Region_Hydro".
#' @param bassin_geo_poly Objet de classe sf contenant les polygones délimitant les
#'     Zones HYdro. Typiquement produit par la fonction tod::sie_carthage_bassins_tod().
#' @param prop_pts_a_garder Nombre entre zéro et 1 (défaut 0.05) indiquant la proportions de points
#'     à conserver pour simplifier les contours une fois les Zones Hydro agrégées.
#'
#' @return Objet de classe sf contenant les polygones au niveau de découpage des
#'     entités hydrographiques choisi, simplifié sauf si prop_pts_a_garder = 1.
#' @export
#'
#' @importFrom dplyr group_by syms summarise ungroup
#' @importFrom rmapshaper ms_simplify
#'
#' @examples
#' \dontrun{
#' regions_hydro <- sie_carthage_bassins_agr(
#' bassin_geo_poly = zones_hydro,
#' echelle = "Region_Hydro",
#' pc_pts_a_garder = 0.01)
#' }
sie_carthage_bassins_agr <- function(bassin_geo_poly,
                                     echelle = c("Zone_Hydro", "Sous_Secteur_Hydro",
                                               "Secteur_Hydro", "Region_Hydro"),
                                     prop_pts_a_garder = 0.05)

{

  if(echelle == "Zone_Hydro")
  {
    code <- "CdZoneHydr"
    libelle <- "LbZoneHydr"
  }

  if(echelle == "Sous_Secteur_Hydro")
  {
    code <- "CdSousSect"
    libelle <- "LbSousSect"
  }

  if(echelle == "Secteur_Hydro")
  {
    code <- "CdSecteurH"
    libelle <- "LbSecteurH"
  }

  if(echelle == "Region_Hydro")
  {
    code <- "CdRegionHy"
    libelle <- "LbRegionHy"
  }

  entites_hydro <- bassin_geo_poly %>%
    group_by(!!!syms(code), !!!syms(libelle)) %>%
      summarise()

  entites_hydro <- entites_hydro %>%
    rmapshaper::ms_simplify(keep = prop_pts_a_garder)

  entites_hydro

}