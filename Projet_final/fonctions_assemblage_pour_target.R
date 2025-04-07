#fonctions pour assembler les données

# 1) Lecture des données et installation des librairies
lecture_donnees <- function(chemin_acces){
  library(dplyr)              #Cela est plus optimisé que des boucle, sinon se sera trop long à générer
  library(ritis)              #Transformer les noms scientifiques en code ITIS.
  library(purrr)              #Optimiser le trajet en pouvant manipuler les listes.
  library(furrr)              #Pour exécuter en parallèle la fonction "purrr"
  library(future)             #Exécuter furrr
  library(readr)
  
  # 2) Set Working Directory au dossier "BIO500_Lepidopteres_MAJM", ou exécuter la fonction suivante :
  setwd(chemin_acces)

  # 3) Exécutez les fonctions suivantes pour charger les fonctions qui seront utiles pour nettoyer les données.
  setwd("./Projet_final")	#Ouvrir le Working Directory qui contient les fichiers sources des fonctions
  source("1_fonction_BD.R")
  source("3_fonction_formats_temporels.R")
  source("4_fonction_coordo_geographiques.R")
  source("5_fonction_types_donnees.R")
  source("6_fonction_obs_variable.R")
  source("7_fonction_taxonomie_itis.R")
  source("8_fonction_creation_tableau_taxonomie.R")
  source("9_fonction_itis_lepido.R")
}






# 2) Assemblage des données


# 3) Création des tables SQL


# 4) Requêtes SQL