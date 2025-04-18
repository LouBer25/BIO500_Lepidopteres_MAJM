# 2) Création des tables SQL et injection des donnnées
creation_SQL <- function(){
  
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
		  observed_scientific_name,
	  	valid_scientific_name,
		  rank,
		  vernacular_fr,
		  kingdom,
		  phylum,
		  class,
		  `order`,
		  family,
		  genus,
		  species,
		  itis_code,
		  PRIMARY KEY (observed_scientific_name)
  	);"
  dbSendQuery(con, creer_espece)

 # d) Création de la table date
  creer_date <-
    "CREATE TABLE date (
		  year_obs,
		  day_obs,
		  time_obs,
		  dwc_event_date,
		  PRIMARY KEY (dwc_event_date)
  	);"
  dbSendQuery(con, creer_date)

  # e) Création de la table source
  creer_source <-
    "CREATE TABLE source (
		  original_source,
		  creator,
		  title,
		  publisher,
		  intellectual_rights,
		  license,
		  owner,
		  PRIMARY KEY (title)
	  );"
  dbSendQuery(con, creer_source)

  # f) Création de la table abbondance
  creer_abbondance <-
    "CREATE TABLE abbondance (
		  obs_variable,
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
		  observed_scientific_name,
		  dwc_event_date,
		  obs_variable,
		  lat,
		  lon,
		  title,
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
  source("../scripts/11_fonction_creation_donnees.R")

  # k) Assignation des données
  donnee_espece <- espece("../tables_pour_SQL/taxonomie_BD.csv")
  donnee_date <- date("../tables_pour_SQL/lepido_final.csv")
  donnee_source <- `source`("../tables_pour_SQL/lepido_final.csv")
  donnee_abbondance <- abbondance("../tables_pour_SQL/lepido_final.csv")
  donnee_latitude <- latitude("../tables_pour_SQL/lepido_final.csv")
  donnee_longitude <- longitude("../tables_pour_SQL/lepido_final.csv")
  donnee_observation <- observation("../tables_pour_SQL/lepido_final.csv")

  # l) Injection des données dans les tables
  dbWriteTable(con, append = TRUE, name = "espece", value = donnee_espece, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "date", value = donnee_date, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "source", value = donnee_source, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "abbondance", value = donnee_abbondance, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "latitude", value = donnee_latitude, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "longitude", value = donnee_longitude, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "observation", value = donnee_observation, row.names = FALSE)

# b) Requête pour le nombre d'espèce par année
  requete_nombre_especes_par_annee <- "
    SELECT d.year_obs AS annee, COUNT(DISTINCT o.observed_scientific_name) AS nombre_especes
    FROM observation o
    JOIN date d ON o.dwc_event_date = d.dwc_event_date
    GROUP BY d.year_obs
    ORDER BY d.year_obs;
  "
  resultats_nombre_especes <- dbGetQuery(con, requete_nombre_especes_par_annee)

# c) Requête pour la latitude par espèce
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

# d) Requete pour la carte
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


  return(list(resultats_nombre_especes, resultat_latitude_espece, resultat_carte))
}
