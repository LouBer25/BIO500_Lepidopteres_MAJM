setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")


library(dplyr)              #Cela est plus optimisé que des boucle, sinon se sera trop long à générer
  library(ritis)              #Transformer les noms scientifiques en code ITIS.
  library(purrr)              #Optimiser le trajet en pouvant manipuler les listes.
  library(furrr)              #Pour exécuter en parallèle la fonction "purrr"
  library(future)             #Exécuter furrr
  library(readr)
  library(RSQLite)
  library(terra)
  #install.packages("ggplot2")
  library(ggplot2)
  #install.packages("viridis")
  library(viridis)
  #install.packages("ggspatial")
  library(ggspatial)
  #install.packages("maptiles")
  library(maptiles)
  #install.packages("rnaturalearth")
  library(rnaturalearth)
  #install.packages("rnaturalearthdata")
  library(rnaturalearthdata)
  #install.packages("sf")
  library(sf)
  #install.packages("devtools")
  library(devtools)
  devtools::install_github("ropensci/rnaturalearthhires")

source("./scripts/01_Assemblage_et_nettoyage_des_donnees.R")
source("./scripts/02_Creation_des_tables_SQL.R")
source("./scripts/03_Creation_graphique_richesse_specifique.R")

assemblage_donnees()
creation_SQL()


