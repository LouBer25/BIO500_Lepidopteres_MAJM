# 1) Set Working Directory au dossier "Projet_final", ou exécuter la fonction suivante :
setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")
#connexion Maïté
setwd("C:/Users/alex/OneDrive - USherbrooke/École/Hiver_2025/Écologie Computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

# 2) Ouverture de la librairie SQL
library(RSQLite)

# 3) Connection au language SQL
con <- dbConnect(SQLite(), dbname="donnee.db")

# 4) Initialisation des tables
dbSendQuery(con, "DROP TABLE IF EXISTS espece;")
dbSendQuery(con, "DROP TABLE IF EXISTS date;")
dbSendQuery(con, "DROP TABLE IF EXISTS source;")
dbSendQuery(con, "DROP TABLE IF EXISTS abbondance;")
dbSendQuery(con, "DROP TABLE IF EXISTS coordonnee;")
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

# 9) Création de la table coordonnee
creer_coordonnee <-
	"CREATE TABLE coordonnee (
		lat	DOUBLE,
		lon	DOUBLE,
		PRIMARY KEY(lat, lon)
	);"
dbSendQuery(con, creer_coordonnee)

# 10) Création de la table observation
creer_observation <- 
	"CREATE TABLE observation (
		taxonomie	VARCHAR(100),
		date 		TIMESTAMP(20) NOT NULL,
		source	VARCHAR(100),
		abbondance  VARCHAR(100),
		coordonnee	DOUBLE,
		PRIMARY KEY (taxonomie, date, source, abbondance, coordonnee)
		FOREIGN KEY (taxonomie) REFERENCES taxonomie(observed_scientific_name),
		FOREIGN KEY (date) REFERENCES date(dwc_event_date),
		FOREIGN KEY (source) REFERENCES source(title),
		FOREIGN KEY (abbondance) REFERENCES abbondance(obs_value),
		FOREIGN KEY (coordonnee) REFERENCES coordonnee(lat, lon)
	);"
dbSendQuery(con, creer_observation)

# 11) Ouverture de la fonction pour la création de donnée
source("11_fonction_creation_donnees.R")

# 11) Assignation des données
donnee_espece <- espece("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")
donnee_date <- date("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")
donnee_source <- source("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")
donnee_abbondance <- abbondance("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")
donnee_coordonnee <- coordonnee("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")
donnee_observation <- observation("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")

# 12) Injection des données dans les tables
dbWriteTable(con, append = TRUE, name = "espece", value = donnee_espece, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = donnee_date, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "source", value = donnee_source, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "abbondance", value = donnee_abbondance, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "coordonnee", value = donnee_coordonnee, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "observation", value = donnee_observation, row.names = FALSE)


test <- "
	SELECT *
	FROM observation
	LIMIT 4;
"

test_test <- dbGetQuery(con, test)
test_test

# 13) Fermeture de la session
dbDisconnect(con)


################################################################
#connexion Maïté
setwd("C:/Users/alex/OneDrive - USherbrooke/École/Hiver_2025/Écologie Computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

# 2) Ouverture de la librairie SQL
library(RSQLite)

# 3) Connection au language SQLà la base de données
con <- dbConnect(SQLite(), dbname="donnee.db")

# Requêtes

# 1) Analyse de la distribution nord-sud des espèces en diagramme à moustache
distribution <- "
WITH coordo AS(
	SELECT lat
	FROM coordonnee
),
dat AS(
	SELECT year_obs
	FROM date
)
SELECT *
FROM observation
JOIN observation ON date = dat
JOIN observation ON coordonnee = coordo;"

requete1 <- dbSendQuery(con, distribution)
requete1
# problèmes dans la dernière partie quels champs et quelles tables on doit joindre ensemble?


# 2) Le nombre d'espèce par année

richesse <- "
SELECT dwc_event_date.date, observed_scientific_name.taxonomie
FROM observation
LIMIT 10;
"
richesse <- dbSendQuery(con, richesse)

richesse




