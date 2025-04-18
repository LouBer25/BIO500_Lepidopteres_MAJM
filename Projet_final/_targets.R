setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

#Dépendance
library(targets)
library(tarchetypes)
library(rmarkdown)
tar_option_set(packages = c("dplyr", "ritis", "purrr", "furrr", "future", "readr", "RSQLite", "terra", "ggplot2", "viridis", "ggspatial", "maptiles", "rnaturalearth", "rnaturalearthdata", "sf", "devtools"))

#Script R
source("./scripts/18_Assemblage_et_nettoyage_des_donnees.R")
source("./scripts/19_Creation_des_tables_SQL.R")
source("./scripts/20_creation_graphique_richesse_specifique.R")
source("./scripts/21_creation_graphique_latitude_annee.R")
source("./scripts/22_creation_carte.R")


#Pipeline

list(
 tar_target(
    fichiers_bruts,
    list.files("Lepidopteres_BD/", pattern = "\\.csv$", full.names = TRUE),
    format = "file"
  )
)
