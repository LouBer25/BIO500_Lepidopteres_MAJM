# 1) Set Working Directory au dossier "BIO500_Lepidopteres_MAJM/Projet_final"
setwd(chemin_acces)

# 2) Sélectionner tout le code (Ctrl+A) et exécuter. Enregistrer les modifications, puis écrire dans la console tar_make() et exécuter.
#installation des librairies nécessaires
library(targets)
library(tarchetypes)
library(rmarkdown)
tar_option_set(packages = c("dplyr", "ritis", "purrr", "furrr", "future", "readr", "RSQLite", "terra", "ggplot2", "viridis", "ggspatial", "maptiles", "rnaturalearth", "rnaturalearthdata", "sf", "devtools", "tinytex"))

#Script R
source("./scripts/1_fonction_BD.R")
source("./scripts/18_Assemblage_et_nettoyage_des_donnees.R")
source("./scripts/19_Creation_des_tables_SQL.R")


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
 tar_render(
   name = rapport_lepidopteres,
   path = "./scripts/Rapport_lepidopteres/Rapport_lepidopteres.Rmd"
 )
)
