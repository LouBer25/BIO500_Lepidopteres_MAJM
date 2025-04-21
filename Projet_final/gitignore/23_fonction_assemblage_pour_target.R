setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

  #install.packages("dplyr")
  library(dplyr)              #Cela est plus optimisé que des boucle, sinon se sera trop long à générer
  #install.packages("ritis")
  library(ritis)              #Transformer les noms scientifiques en code ITIS.
  #install.packages("purrr")
  library(purrr)              #Optimiser le trajet en pouvant manipuler les listes.
  #install.packages("furrr")
  library(furrr)              #Pour exécuter en parallèle la fonction "purrr"
  #install.packages("future")
  library(future)             #Exécuter furrr
  #install.packages("readr")
  library(readr)
  #install.packages("RSQLite")
  library(RSQLite)
  #install.packages("terra")
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

source("./scripts/18_Assemblage_et_nettoyage_des_donnees.R")
source("./scripts/19_Creation_des_tables_SQL.R")
source("./scripts/20_creation_graphique_richesse_specifique.R")
source("./scripts/21_creation_graphique_latitude_annee.R")
source("./scripts/22_creation_carte.R")

donnee <- assemblage_donnees()
requete <- creation_SQL()
graph_richesse_specifique()
graph_latitude_annee()
graph_carte()


