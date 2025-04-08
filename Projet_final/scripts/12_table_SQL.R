SQL_table <- function(chemin_acces){

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
		obs_value	VARCHAR(100),
		PRIMARY KEY (obs_value)
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
		obs_value  VARCHAR(100),
		lat	INTEGER,
		lon INTEGER,
		title	VARCHAR(100),
		PRIMARY KEY (id_observation)
		FOREIGN KEY (observed_scientific_name) REFERENCES espece(observed_scientific_name),
		FOREIGN KEY (dwc_event_date) REFERENCES date(dwc_event_date),
		FOREIGN KEY (title) REFERENCES source(title),
		FOREIGN KEY (obs_value) REFERENCES abbondance(obs_value),
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

}
