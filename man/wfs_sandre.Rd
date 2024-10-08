% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wfs_sandre.R
\name{wfs_sandre}
\alias{wfs_sandre}
\title{Requêter les flux WFS proposés sur www.sandre.eaufrance.fr}
\usage{
wfs_sandre(url_wfs, couche)
}
\arguments{
\item{url_wfs}{Caractère. URL du flux WFS.}

\item{couche}{Caractère. Nom de la couche à charger.}
}
\value{
Un objet de classe sf correspondant à la couche choisie.
}
\description{
Requêter les flux WFS proposés sur www.sandre.eaufrance.fr
}
\examples{
\dontrun{
bassins <- wfs_sandre(url_wfs = "https://services.sandre.eaufrance.fr/geo/sandre?",
                     couche = "BassinDCE")
}
}
