#####ATTENTION#####
#L'utilisation de ce script nécessite l'enregistrement des fichiers tels qu'ils sont organisés#

# 1) Le dossier "Lepidopteres_BD" contient tous les fichiers de chaque année et doit être dans le fichier "Projet_final" dans votre explorateur de fichier
# Extraire les fichiers

####Vérification####
# 2) Ouvrir avec Bloc notes le fichier "1883.csv": modifier l'entête "titre" par "title" (uniformiser), enregistrer, puis fermer.


# 3) Installez les packages "readr", ils seront utile pour importer toutes les données contenues dans les fichiers .csv.Exécutez ces lignes de codes
### Installer les packages suivants pour compléter les prochaines étapes.

#install.packages("dplyr")
library(dplyr)              #Cela est plus optimisé que des boucle, sinon se sera trop long à générer
#install.packages("ritis")
library(ritis)              #Transformer les noms scientifiques en code ITIS.
#install.packages("purrr")   
library("purrr")            #Optimiser le trajet en pouvant manipuler les listes.
#install.packages("furrr")
library(furrr)              #Pour exécuter en parallèle la fonction "purrr"
#install.packages("future")
library(future)             #Exécuter furrr
#install.packages("readr")
library(readr)

### Pour les prochaines étapes, copiez/collez votre chemin d'accès entre les guillemets lorsqu'indiqué.###



# 4) Set Working Directory au dossier "Projet_final", ou exécuter la fonction suivante :
setwd("C:/Users/Alex/Desktop/test")


# 5) Exécutez les fonctions suivantes pour charger les fonctions qui seront utiles pour nettoyer les données.
setwd("./Projet_final")
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
lepido_BD <- Lepidopteres_BD("./Lepidopteres_BD")



## À partir d'ici, travaillez avec le data frame lepido_new qui est exempt de duplicatas.



# 8) Exécutez cette fonction pour détecter et corriger les formats temporels sur le tableau lepido_new
lepido_new <- corriger_dates(lepido_BD) ### erreur dans cette fonction, à corriger dans 1_fonctions_lepidopteres.R.


# 9) Exécutez cette fonction pour corriger les coordonnées géographiques
lepido_new <- corriger_coordonnees(lepido_new)


# 10) Fonction pour convertir les données dans les bons types (ex. boolléen, numérique, etc.)
lepido_new <- convertir_types(lepido_new)   #fonctionne, mais à retravailler: dit que ça intègre des NA lors de la conversion automatique


# 11) Exécutez cette fonction qui remplace la valeur textuelle de la colonne obs_variable en valeur numérique
##Besoin du package "dplyr" pour exécuter cette fonction
lepido_new <- remplacer_obs_variable(lepido_new)

# 12) Exécutez la fonction suivante pour générer la base de données sur les espèces
##Le chemin d'accès à entrer correspond au chemin jusqu'au fichier taxonomie.csv directement qui devrait être dans le dossier Projet_final
taxonomie_BD <- read.csv("../taxonomie_test.csv")

# 13) Ajoute le code itis au tableau taxonomie
##Le chemin d'accès à entrer correspond au chemin jusqu'au fichier taxonomie_BD.csv créer précédemment qui devrait être dans le dossier Projet_final
taxonomie_table <- tableau_taxonomie("..")

# 14) Ajoute le code itis au tableau lepido_new
##Le chemin d'accès à entrer correspond au chemin jusqu'au dossier Projet_final créer précédemment
lepido_new <- colonne_itis(getwd())

# 15) Ouvrir la source pour écrire le fichier csv "lepido_final.csv"
source("10_fonction_csv_lepido_final.R")

# 16) Créer le fichier csv "lepido_final.csv"
##Le chemin d'accès à entrer correspond au chemin jusqu'au fichier lepido_final.csv qui devrait être dans le dossier Projet_final
ecrire_lepido_final("./lepido_final.csv")

#17) 
# 2) Ouverture de la librairie SQL
library(RSQLite)

# 3) Connection au language SQL
con <- dbConnect(SQLite(), dbname="donnee.db")

# 4) Initialisation des tables
dbSendQuery(con, "DROP TABLE IF EXISTS espece;")
dbSendQuery(con, "DROP TABLE IF EXISTS date;")
dbSendQuery(con, "DROP TABLE IF EXISTS source;")
dbSendQuery(con, "DROP TABLE IF EXISTS abbondance;")
dbSendQuery(con, "DROP TABLE IF EXISTS latitude;")
dbSendQuery(con, "DROP TABLE IF EXISTS longitude;")
dbSendQuery(con, "DROP TABLE IF EXISTS observation;")

# 5) Création de la table espèces
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

# 6) Création de la table date
creer_date <-
	"CREATE TABLE date (
		year_obs		INTEGER(4),
		day_obs		INTEGER(2),
		time_obs		VARCHAR(10),
		dwc_event_date	TIMESTAMP(20),
		PRIMARY KEY (dwc_event_date)
	);"
dbSendQuery(con, creer_date)

# 7) Création de la table source
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

# 8) Création de la table abbondance
creer_abbondance <-
	"CREATE TABLE abbondance (
		obs_variable	VARCHAR(100),
		PRIMARY KEY (obs_variable)
	);"
dbSendQuery(con, creer_abbondance)

# 9) Création de la table latitude et longitude
creer_latitude <- 
  "CREATE TABLE latitude (
  lat REAL PRIMARY KEY
  );"
dbSendQuery(con, creer_latitude)

creer_longitude <- 
  "CREATE TABLE longitude (
  lon REAL PRIMARY KEY
  );"
dbSendQuery(con, creer_longitude)

# 10) Création de la table observation
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

# 11) Ouverture de la fonction pour la création de données
source("11_fonction_creation_donnees.R")

# 11) Assignation des données
donnee_espece <- espece(getwd())
donnee_date <- date(getwd())
donnee_source <- source(getwd())
donnee_abbondance <- abbondance(getwd())
donnee_latitude <- latitude(getwd())
donnee_longitude <- longitude(getwd())
donnee_observation <- observation(getwd())

# 12) Injection des données dans les tables
dbWriteTable(con, append = TRUE, name = "espece", value = donnee_espece, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = donnee_date, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "source", value = donnee_source, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "abbondance", value = donnee_abbondance, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "latitude", value = donnee_latitude, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "longitude", value = donnee_longitude, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "observation", value = donnee_observation, row.names = FALSE)

# 13) Requête SQL
  test <- "
	SELECT id_observation, obs_variable, observed_scientific_name
	FROM observation
;"

  test_test <- dbGetQuery(con, test)
head(test_test)

dbDisconnect(con) 


