# Set Working Directory au dossier "./Projet_final", ce sera votre chemin d'accès
setwd(chemin_acces)


# 1) Lecture des données et installation des librairies
lecture_donnees <- function(chemin_acces){
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

  # a) set working directory
  setwd("chemin_acces")
  
  # b) Exécutez les fonctions suivantes pour charger les fonctions qui seront utiles pour nettoyer les données.
  source("1_fonction_BD.R")
  source("3_fonction_formats_temporels.R")
  source("4_fonction_coordo_geographiques.R")
  source("5_fonction_types_donnees.R")
  source("6_fonction_obs_variable.R")
  source("7_fonction_taxonomie_itis.R")
  source("8_fonction_creation_tableau_taxonomie.R")
  source("9_fonction_itis_lepido.R")
  source("15_creation_carte_graph.R")
}


# 2) Assemblage et nettoyage des données

assemblage_donnees <- function(chemin_acces){
  
  # a) Générer la base de données
  lepido_BD <- Lepidopteres_BD(chemin_acces)

  # b) Détecter et corriger les formats temporels
  lepido_new <- corriger_dates(lepido_BD)

  # c) Corriger les coordonnées géographiques
  lepido_new <- corriger_coordonnees(lepido_new)

  # d) Convertir les données dans les bons types de données
  lepido_new <- convertir_types(lepido_new)
  lepido_new <- return(lepido_new) #ajout sinon la fonction suivante ne le prennait pas

  # e) Remplace la valeur textuelle de la colonne obs_variable en valeur numérique
  ##Besoin du package "dplyr" pour exécuter cette fonction
  lepido_new <- remplacer_obs_variable(lepido_new)

  # f) Générer la base de données sur les espèces
  taxonomie_BD <- read.csv("../taxonomie_test.csv")

  # g) Ajouter le code itis au tableau taxonomie
  taxonomie_table <- tableau_taxonomie("..")

  # h) Ajouter le code itis au tableau lepido_new
  lepido_new <- colonne_itis(getwd())

  # i) Ouvrir la source pour écrire le fichier csv "lepido_final.csv"
  source("./Projet_final/scripts/10_fonction_csv_lepido_final.R")

  # j) Créer le fichier csv "lepido_final.csv"
  ecrire_lepido_final("./lepido_final.csv")
}


# 3) Création des tables SQL et injection des donnnées
creation_SQL <- function(chemin_acces){
  
  # a) Connection au language SQL
  con <- dbConnect(SQLite(), dbname="donnee.db")

  # b) Initialisation des tables pour effacer les tables si elles existent déjà
  dbSendQuery(con, "DROP TABLE IF EXISTS espece;")
  dbSendQuery(con, "DROP TABLE IF EXISTS date;")
  dbSendQuery(con, "DROP TABLE IF EXISTS source;")
  dbSendQuery(con, "DROP TABLE IF EXISTS abbondance;")
  dbSendQuery(con, "DROP TABLE IF EXISTS latitude;")
  dbSendQuery(con, "DROP TABLE IF EXISTS longitude;")
  dbSendQuery(con, "DROP TABLE IF EXISTS observation;")

  # c) Création de la table espèces
  creer_espece <-
    "CREATE TABLE espece (
		  observed_scientific_name	VARCHAR(100),
	  	valid_scientific_name		VARCHAR(100),
		  rank					VARCHAR(100),
		  vernacular_fr			VARCHAR(100),
		  kingdom				VARCHAR(100),
		  phylum				VARCHAR(100),
		  class					VARCHAR(100),
		  `order`				VARCHAR(100),
		  family				VARCHAR(100),
		  genus					VARCHAR(100),
		  species				VARCHAR(100),
		  itis_code				INTEGER,
		  PRIMARY KEY (observed_scientific_name)
  	);"
  dbSendQuery(con, creer_espece)

 # d) Création de la table date
  creer_date <-
    "CREATE TABLE date (
		  year_obs		INTEGER(4),
		  day_obs		INTEGER(2),
		  time_obs		VARCHAR(10),
		  dwc_event_date	TIMESTAMP(20),
		  PRIMARY KEY (dwc_event_date)
  	);"
  dbSendQuery(con, creer_date)

  # e) Création de la table source
  creer_source <-
    "CREATE TABLE source (
		  original_source		VARCHAR(20),
		  creator			VARCHAR(100),
		  title				VARCHAR(100),
		  publisher			VARCHAR(100),
		  intellectual_rights	VARCHAR(100),
		  license			VARCHAR(40),
		  owner				VARCHAR(100),
		  PRIMARY KEY (title)
	  );"
  dbSendQuery(con, creer_source)

  # f) Création de la table abbondance
  creer_abbondance <-
    "CREATE TABLE abbondance (
		  obs_variable	VARCHAR(100),
		  PRIMARY KEY (obs_variable)
	  );"
  dbSendQuery(con, creer_abbondance)

  # g) Création de la table latitude
  creer_latitude <- 
   "CREATE TABLE latitude (
    lat REAL PRIMARY KEY
   );"
  dbSendQuery(con, creer_latitude)

  # h) Création de la table longitude
  creer_longitude <- 
   "CREATE TABLE longitude (
    lon REAL PRIMARY KEY
   );"
  dbSendQuery(con, creer_longitude)

  # i) Création de la table observation
  creer_observation <- 
    "CREATE TABLE observation (
	  	id_observation   INTEGER,
		  observed_scientific_name	VARCHAR(100),
		  dwc_event_date 		TIMESTAMP(20) NOT NULL,
		  obs_variable  VARCHAR(100),
		  lat	INTEGER,
		  lon INTEGER,
		  title	VARCHAR(100),
		  PRIMARY KEY (id_observation)
		  FOREIGN KEY (observed_scientific_name) REFERENCES espece(observed_scientific_name),
		  FOREIGN KEY (dwc_event_date) REFERENCES date(dwc_event_date),
		  FOREIGN KEY (title) REFERENCES source(title),
		  FOREIGN KEY (obs_variable) REFERENCES abbondance(obs_variable),
		  FOREIGN KEY (lat) REFERENCES latitude(lat),
		  FOREIGN KEY (lon) REFERENCES longitude(lon)
	  );"
  dbSendQuery(con, creer_observation)

  # j) Ouverture de la fonction pour la création de données
  source("./scripts/11_fonction_creation_donnees.R")

  # k) Assignation des données
  donnee_espece <- espece(getwd())
  donnee_date <- date(getwd())
  donnee_source <- `source`(getwd())
  donnee_abbondance <- abbondance(getwd())
  donnee_latitude <- latitude(getwd())
  donnee_longitude <- longitude(getwd())
  donnee_observation <- observation(getwd())

  # l) Injection des données dans les tables
  dbWriteTable(con, append = TRUE, name = "espece", value = donnee_espece, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "date", value = donnee_date, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "source", value = donnee_source, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "abbondance", value = donnee_abbondance, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "latitude", value = donnee_latitude, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "longitude", value = donnee_longitude, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "observation", value = donnee_observation, row.names = FALSE)
}

# 4) Requêtes SQL
### avec target on laisse les 3 fonctions du script 14
#requetes_SQL <- function(chemin_acces){

#source(chemin_acces)

  # b) Connection au language SQL et requêtes
  #richesse_specifique("./data")
  #latitude_annees("./data")
  #carte("./data")}

### 5) Création graphiques et carte finaux ###

# a)Graphique de la richesse spécifique
graph_richesse_specifique(richesse_specifique)

# b)Graphique des latitudes des 4 espèces les plus abondantes
graph_latitude_annee(latitude_annee)

# c)Création carte richesse spécifique par degré de latitude et longitude
graph_carte(carte)

