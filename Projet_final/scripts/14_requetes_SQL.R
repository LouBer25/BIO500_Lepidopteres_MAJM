### ajouter la création d'objet des valeurs retournées et la création du graphique dans ces fonctions
# 27) Requête SQL qui sort le nombre d'espèces par année
richesse_specifique <- function(){
  
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
  return(resultats_nombre_especes)
  write.csv(resultats_nombre_especes, file="data/resultat_richesse.csv")
  
  dbDisconnect(con)
}


# 2) Requête SQL qui sort les latitudes par année des trois espèce qu'on retrouve dans le plus d'année

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
  write.csv(res_lat, file= "data/resultat_latitude.csv")
  
  dbDisconnect(con)
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
  
  dbDisconnect(con)
}

