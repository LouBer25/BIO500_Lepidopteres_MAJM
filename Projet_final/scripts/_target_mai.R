# =====================================================================
# _target.R file
# =====================================================================
# Set Working Directory
setwd("C:/Users/alex/OneDrive - USherbrooke/École/Hiver_2025/Écologie Computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

# Librairies et dépendances
library(rmarkdown)
library(tarchetypes)
library(targets)
tar_option_set(packages = c("MASS", "igraph"))



# Scripts
source("./scripts/fonctions_assemblage_pour_target.R")
source("./scripts/14_requetes_SQL.R")
source("./scripts/15_creation_carte_graph.R")

# Pipeline
list(
  tar_target(
    # Lecture de la source de donnees pour l'assemblage
    source_donnees, #Cible
    lecture_donnees("./Projet_final") #lecture des données
  ),
  tar_target(
    # assemblage des données
    assemblage_nettoyage, #Cible
    assemblage_donnees(source_donnees)
  ),
  tar_target(
    # Creation de la BD SQL à partir des données traitées
    creation_bd_SQL, #Cible
    creation_SQL(assemblage_nettoyage)
  ),
  tar_target(
        # Création requête et graphique richesse
    richesse,
    richesse_specifique("./Projet_final")
  )
)

