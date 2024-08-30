<!-- badges: start -->
[![R-CMD-check](https://github.com/PascalIrz/tod/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PascalIrz/tod/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# tod
Package R pour faciliter le téléchargement d'open data.

Le package est nommé {tod} pour les initiales de “télécharger open data”. A terme, il fournira un jeu assez fourni de fonctionalités pour importer des jeux de données ouvertes et leur appliquer des mises en formes minimales.

Une série de tutos sont présentés sur Rpubs : https://rpubs.com/kamoke/723467

Dans un premier temps, il permet que de manipuler les données :
- Du Géoportail de l’Urbanisme. Celui-ci offre des services de téléchargement, de consultation ainsi que des API.
- De la base HYDRO, à partir de l'API Hub'eau.
    
Très bientôt seront ajoutés des modules dédiés à :
- La banque nationale des prélèvements quantitatifs en eau (BNPE), à partir de l'API Hub'eau.
- L'Observatoire National des Etiages, à partir de la page de diffusion de l'OFB.
- Le découpage administratif de la France à partir de data.gouv.fr
- etc.

Les fonctions sont nommées de manière relativement explicite. Par exemple toutes celles préfixées par `ign_urba`, comme `ign_urba_lire_shapes()` concernent la chaîne de traitements dédiée au portail de l’urbanisme. La première partie du préfixe indique l’organisme fournisseur de la donnée, la seconde le nom de la base.

# Téléchargement du package

`devtools::install_github("pascalirz/tod")`

`library(tod)`
