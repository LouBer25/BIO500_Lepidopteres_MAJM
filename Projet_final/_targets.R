setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

#Dépendance
library(targets)
library(tarchetypes)
library(rmarkdown)
tar_option_set(packages = c("dplyr", "ritis", "purrr", "furrr", "future", "readr", "RSQLite", "terra", "ggplot2", "viridis", "ggspatial", "maptiles", "rnaturalearth", "rnaturalearthdata", "sf", "devtools"))

#Script R
source("./scripts/1_fonction_BD.R")
source("./scripts/18_Assemblage_et_nettoyage_des_donnees.R")
source("./scripts/19_Creation_des_tables_SQL.R")
source("./scripts/20_creation_graphique_richesse_specifique.R")
source("./scripts/21_creation_graphique_latitude_annee.R")
source("./scripts/22_creation_carte.R")


#Pipeline

list(
 tar_target(
    name = lepido_BD,
    command = Lepidopteres_BD("./Lepidopteres_BD")
  ),
 tar_target(
    name = donnee,
    command = assemblage_donnees(lepido_BD)
 ),
 tar_target(
   name = requete,
   command = creation_SQL(donnee)
 ),
 tar_target(
   name = richesse_specifique,
   command = graph_richesse_specifique(requete)
 ),
 tar_target(
   name = latitude_annee,
   command = graph_latitude_annee(requete)
 ),
 tar_target(
   name = carte,
   command = graph_carte(requete)
 )
)
