#####ATTENTION#####
#L'utilisation de ce script nécessite l'enregistrement des fichiers tels qu'ils sont organisés, soit à partir du Git ou autre#


# 1) Installez les packages suivants si ce n'est pas fait, ils seront utile pour importer toutes les données contenues dans les fichiers .csv
### Ouvrir les librairies nécessaires

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


# 3) Exécutez les fonctions suivantes pour charger les fonctions qui seront utiles pour nettoyer les données.
setwd(chemin_acces)	#jusqu'à /Projet_final
source("scripts/1_fonction_BD.R")
source("scripts/3_fonction_formats_temporels.R")
source("scripts/4_fonction_coordo_geographiques.R")
source("scripts/5_fonction_types_donnees.R")
source("scripts/6_fonction_obs_variable.R")
source("scripts/7_fonction_taxonomie_itis.R")
source("scripts/8_fonction_creation_tableau_taxonomie.R")
source("scripts/9_fonction_itis_lepido.R")


# 4) Exécutez la fonction suivante pour générer la base de données
lepido_BD <- Lepidopteres_BD("./Lepidopteres_BD")


## À partir d'ici, travaillez avec le data frame lepido_new qui est exempt de duplicatas##


# 5) Exécutez cette fonction pour détecter et corriger les formats temporels sur le tableau lepido_new
lepido_new <- corriger_dates(lepido_BD) ### erreur dans cette fonction, à corriger dans 1_fonctions_lepidopteres.R.


# 6) Exécutez cette fonction pour corriger les coordonnées géographiques
lepido_new <- corriger_coordonnees(lepido_new)


# 7) Fonction pour convertir les données dans les bons types (ex. boolléen, numérique, etc.)
lepido_new <- convertir_types(lepido_new)   #fonctionne, mais à retravailler: dit que ça intègre des NA lors de la conversion automatique


# 8) Exécutez cette fonction qui remplace la valeur textuelle de la colonne obs_variable en valeur numérique
##Besoin du package "dplyr" pour exécuter cette fonction
lepido_new <- remplacer_obs_variable(lepido_new)

# 9) Exécutez la fonction suivante pour générer la base de données sur les espèces
taxonomie_BD <- read.csv("tables_pour_SQL/taxonomie_test.csv")

# 10) Ajoute le code itis au tableau taxonomie
taxonomie_table <- tableau_taxonomie("..")

# 11) Ajoute le code itis au tableau lepido_new
lepido_new <- colonne_itis(getwd())

# 12) Ouvrir la source pour écrire le fichier csv "lepido_final.csv"
source("scripts/10_fonction_csv_lepido_final.R")

# 13) Créer le fichier csv "lepido_final.csv"
ecrire_lepido_final("./lepido_final.csv")

# 14) Ouverture de la librairie SQL
library(RSQLite)

# 15) Connection au language SQL
con <- dbConnect(SQLite(), dbname="donnee.db")

# 16) Initialisation des tables pour effacer les tables si elles existent déjà
dbSendQuery(con, "DROP TABLE IF EXISTS espece;")
dbSendQuery(con, "DROP TABLE IF EXISTS date;")
dbSendQuery(con, "DROP TABLE IF EXISTS source;")
dbSendQuery(con, "DROP TABLE IF EXISTS abbondance;")
dbSendQuery(con, "DROP TABLE IF EXISTS latitude;")
dbSendQuery(con, "DROP TABLE IF EXISTS longitude;")
dbSendQuery(con, "DROP TABLE IF EXISTS observation;")

# 17) Création de la table espèces
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

# 18) Création de la table date
creer_date <-
	"CREATE TABLE date (
		year_obs		INTEGER(4),
		day_obs		INTEGER(2),
		time_obs		VARCHAR(10),
		dwc_event_date	TIMESTAMP(20),
		PRIMARY KEY (dwc_event_date)
	);"
dbSendQuery(con, creer_date)

# 19) Création de la table source
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

# 20) Création de la table abbondance
creer_abbondance <-
	"CREATE TABLE abbondance (
		obs_variable	VARCHAR(100),
		PRIMARY KEY (obs_variable)
	);"
dbSendQuery(con, creer_abbondance)

# 21) Création de la table latitude
creer_latitude <- 
  "CREATE TABLE latitude (
  lat REAL PRIMARY KEY
  );"
dbSendQuery(con, creer_latitude)

# 22) Création de la table longitude
creer_longitude <- 
  "CREATE TABLE longitude (
  lon REAL PRIMARY KEY
  );"
dbSendQuery(con, creer_longitude)

# 23) Création de la table observation
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

# 24) Ouverture de la fonction pour la création de données
source("scripts/11_fonction_creation_donnees.R")

# 25) Assignation des données
donnee_espece <- espece(getwd())
donnee_date <- date(getwd())
donnee_source <- `source`(getwd())
donnee_abbondance <- abbondance(getwd())
donnee_latitude <- latitude(getwd())
donnee_longitude <- longitude(getwd())
donnee_observation <- observation(getwd())

# 26) Injection des données dans les tables
dbWriteTable(con, append = TRUE, name = "espece", value = donnee_espece, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = donnee_date, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "source", value = donnee_source, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "abbondance", value = donnee_abbondance, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "latitude", value = donnee_latitude, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "longitude", value = donnee_longitude, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "observation", value = donnee_observation, row.names = FALSE)


### ajouter la création d'objet des valeurs retournées et la création du graphique dans ces fonctions
# 27) Requête SQL qui sort le nombre d'espèces par année
richesse_specifique <- function(chemin_acces){
  setwd(chemin_acces)

  # a) Connection au language SQL
  con <- dbConnect(SQLite(), dbname="donnee.db")
  
  # b) requete
  requete_nombre_especes_par_annee <- "
    SELECT d.year_obs AS annee, COUNT(DISTINCT o.observed_scientific_name) AS nombre_especes
    FROM observation o
    JOIN date d ON o.dwc_event_date = d.dwc_event_date
    GROUP BY d.year_obs
    ORDER BY d.year_obs;
  "
  resultats_nombre_especes <- dbGetQuery(con, requete_nombre_especes_par_annee)
  res_sp_annee <- return(resultats_nombre_especes)
}


# 28) Requête SQL qui sort les latitudes par année des trois espèce qu'on retrouve dans le plus d'année

latitude_annees <- function(){
  # a) Connection au language SQL
  con <- dbConnect(SQLite(), dbname="donnee.db")
  
  requete_latitude_espece <- "
  SELECT 
  strftime('%Y', o.dwc_event_date) AS annee,
  o.observed_scientific_name,
  o.lat
  FROM observation o
  WHERE o.observed_scientific_name IN (
    'Colias philodice',
    'Poanes hobomok',
    'Pieris rapae'
  )
  ORDER BY annee, observed_scientific_name;
  "
  resultat_latitude_espece <- dbGetQuery(con, requete_latitude_espece)
  res_lat <- return(resultat_latitude_espece)
}

# requête pour la carte richesse par coordonnées géographiques (arrondies à l'unité) pour l'année 2020

carte <- function(){
  # a) Connection au language SQL
  con <- dbConnect(SQLite(), dbname="donnee.db")
  
  requete_carte <- "
  SELECT d.year_obs AS annee, COUNT(DISTINCT o.observed_scientific_name) AS nombre_especes, lat AS latitude, lon AS longitude
  FROM observation o
  JOIN date d ON o.dwc_event_date = d.dwc_event_date
  WHERE 
  (annee = 2020)
  AND (lat >= 45 AND lat<=62)
  AND (lon >= -80 AND lon <= -57)
  GROUP BY lat;"
  
  resultat_carte <- dbGetQuery(con, requete_carte)
  write.csv(resultat_carte, file = "data/resultat_carte.csv")
}

# 29) Déconnection de SQL
dbDisconnect(con)