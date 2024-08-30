<!-- badges: start -->
[![R-CMD-check](https://github.com/PascalIrz/tod/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PascalIrz/tod/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# tod

Package R pour faciliter le téléchargement d'open data.

Le package est nommé {tod} pour les initiales de “télécharger open data”. A terme, il fournira un jeu assez fourni de fonctionalités pour importer des jeux de données ouvertes et leur appliquer des mises en formes minimales.

Une série de tutos sont présentés sur Rpubs : https://rpubs.com/kamoke/723467

Il permet que de manipuler les données :

- Du SANDRE, y compris son réfgérentiel taxonomique.
- De GéoBretagne.

Il a été simplifié car d'autres packages permettent désormais de facilement requêter différentes sources :

- [hubeau](https://inrae.github.io/hubeau/) pour collecter les données du Système d'Information sur l'Eau.
- [COGiter](https://maeltheuliere.github.io/COGiter/) pour le découpage administratif français et la gestion des millésimes du référentiel.
    

# Téléchargement du package

`devtools::install_github("pascalirz/tod")`

`library(tod)`
