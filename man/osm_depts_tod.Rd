% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/osm_depts_tod.R
\name{osm_depts_tod}
\alias{osm_depts_tod}
\title{Télécharger les contours des départements}
\usage{
osm_depts_tod(url, repertoire, crs_sortie = NA)
}
\arguments{
\item{url}{Texte. URL de téléchargement.}

\item{repertoire}{Texte. Chemin vers le répertoire où le fichier sera stocké.}

\item{crs_sortie}{Numérique. Identifiant EPSG du CRS de sortie. Par défaut le CRS de sortie
est le même que celui du shapefile d'origine.}
}
\value{
Un objet sf polygone des départements.
}
\description{
Cette fonction télécharge depuis la plateforme data.gouv.fr une couche simplifiée
    des contours des départements et la décompresse. La source est OpenStreetMap.
}
\examples{
\dontrun{
url <- "https://www.data.gouv.fr/fr/datasets/r/3096e551-c68d-40ce-8972-a228c94c0ad1"
depts <- osm_depts_tod(url = url, repertoire = "raw_data", crs_sortie = 2154)
}
}
