#####ATTENTION#####
#L'utilisation de ce script nécessite l'enregistrement des fichiers tels qu'ils sont organisés#

# 1) Le dossier "Lepidopteres_BD" contient tous les fichiers de chaque année et doit être dans le fichier "Projet_final" dans votre explorateur de fichier
# Extraire les fichiers


# 2) Installez les packages "readr", ils seront utile pour importer toutes les données contenues dans les fichiers .csv.Exécutez ces lignes de codes
### Installer les packages suivants pour compléter les prochaines étapes.

#install.packages("dplyr")
library(dplyr)              #Cela est plus optimisé que des boucle, sinon se sera trop long à générer
#install.packages("ritis")
library(ritis)              #Transformer les noms scientifiques en code ITIS.
#install.packages("readr")
library(readr)

### Pour les prochaines étapes, copiez/collez votre chemin d'accès entre les guillemets lorsqu'indiqué.###



# 4) Set Working Directory au dossier "Projet_final", ou exécuter la fonction suivante :
setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")


# 5) Exécutez les fonctions suivantes pour charger les fonctions qui seront utiles pour nettoyer les données.
source("1_fonction_BD.R")
source("3_fonction_formats_temporels.R")
source("4_fonction_coordo_geographiques.R")
source("5_fonction_types_donnees.R")
source("6_fonction_obs_variable.R")
source("7_fonction_taxonomie_itis.R")
source("8_fonction_creation_tableau_taxonomie.R")
source("9_fonction_itis_lepido.R")


# 6) Exécutez la fonction suivante pour générer la base de données.
##Le chemin d'accès à entrer correspond au chemin jusqu'au dossier Lepidopteres_BD créer précédemment
lepido_new <- Lepidopteres_BD("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final/Lepidopteres_BD")


## À partir d'ici, travaillez avec le data frame lepido_new qui est exempt de duplicatas.



# 8) Exécutez cette fonction pour détecter et corriger les formats temporels sur le tableau lepido_new
lepido_new <- corriger_dates(lepido_new) ### erreur dans cette fonction, à corriger dans 1_fonctions_lepidopteres.R.


# 9) Exécutez cette fonction pour corriger les coordonnées géographiques
lepido_new <- corriger_coordonnees(lepido_new)


# 10) Fonction pour convertir les données dans les bons types (ex. boolléen, numérique, etc.)
lepido_new <- convertir_types(lepido_new)   #fonctionne, mais à retravailler: dit que ça intègre des NA lors de la conversion automatique


# 11) Exécutez cette fonction qui remplace la valeur textuelle de la colonne obs_variable en valeur numérique
##Besoin du package "dplyr" pour exécuter cette fonction
lepido_new <- obs_variable(lepido_new)

# 12) Exécutez la fonction suivante pour générer la base de données sur les espèces
##Le chemin d'accès à entrer correspond au chemin jusqu'au fichier taxonomie.csv directement qui devrait être dans le dossier Projet_final
taxonomie_BD <- read.csv("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final/taxonomie.csv")

# 13) Ajoute le code itis au tableau taxonomie
##Le chemin d'accès à entrer correspond au chemin jusqu'au fichier taxonomie_BD.csv créer précédemment qui devrait être dans le dossier Projet_final
taxonomie_table <- tableau_taxonomie("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final/taxonomie_BD.csv")

# 14) Ajoute le code itis au tableau lepido_new
##Le chemin d'accès à entrer correspond au chemin jusqu'au dossier Projet_final créer précédemment
lepido_new <- colonne_itis("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")

# 15) Ouvrir la source pour écrire le fichier csv "lepido_final.csv"
source("10_fonction_csv_lepido_final.R")

# 16) Créer le fichier csv "lepido_final.csv"
##Le chemin d'accès à entrer correspond au chemin jusqu'au fichier lepido_final.csv qui devrait être dans le dossier Projet_final
ecrire_lepido_final("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final/lepido_final.csv")





#Test test git coucou!!
