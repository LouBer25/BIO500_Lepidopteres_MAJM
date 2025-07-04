# 1) Assemblage et nettoyage des données

assemblage_donnees <- function(lepido_BD){

  # a) Sources
  source("./scripts/3_fonction_formats_temporels.R")
  source("./scripts/4_fonction_coordo_geographiques.R")
  source("./scripts/5_fonction_types_donnees.R")
  source("./scripts/6_fonction_obs_variable.R")
  source("./scripts/7_fonction_taxonomie_itis.R")
  source("./scripts/8_fonction_creation_tableau_taxonomie.R")
  source("./scripts/9_fonction_itis_lepido.R")
  
  # c) Détecter et corriger les formats temporels
  lepido_new <- corriger_dates(lepido_BD)

  # d) Corriger les coordonnées géographiques
  lepido_new <- corriger_coordonnees(lepido_new)

  # e) Convertir les données dans les bons types de données
  lepido_new <- convertir_types(lepido_new)

  # f) Remplace la valeur textuelle de la colonne obs_variable en valeur numérique
  ##Besoin du package "dplyr" pour exécuter cette fonction
  lepido_new <- remplacer_obs_variable(lepido_new)

  # g) Ajouter le code itis au tableau taxonomie
  taxonomie_table <- tableau_taxonomie("./tableaux_csv/taxonomie.csv")

  #Ouverture du fichier taxonomie_BD
  taxonomie_BD <- read.csv("./tableaux_csv/taxonomie_BD.csv")

  # h) Ajouter le code itis au tableau lepido_new
  lepido_final <- colonne_itis(lepido_new)

  # i) Ouvrir la source pour écrire le fichier csv "lepido_final.csv"
  source("./scripts/10_fonction_csv_lepido_final.R")

  # j) Créer le fichier csv "lepido_final.csv"
  ecrire_lepido_final(lepido_final)

  return(list(lepido_final, taxonomie_BD))

}
