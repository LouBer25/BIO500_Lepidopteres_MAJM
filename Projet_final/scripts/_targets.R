setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")
library(targets)
library(rmarkdown)
library(tarchetypes)
tar_option_set(packages = c("dplyr", "ritis", "purrr", "furrr", "future", "readr", "RSQLite", "terra", "ggplot2", "virisdis", "ggspatial", "maptiles", "rnaturalearth", "sf", "devtools"))

# Script R
source("./scripts/01_Assemblage_et_nettoyage_des_donnees.R")


list(
  tar_target(
    assemblage_donnees(lepido_new),
    valeur(1000)
  ),
)


#tar_visnetwork() #visualiser les dépendances
#tar_make() # make it work!À écrire seulement dans la console