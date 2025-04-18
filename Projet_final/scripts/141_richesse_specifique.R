# 27) Requête SQL qui sort le nombre d'espèces par année
richesse_specifique <- function(chemin_acces){
  
  # b) requete
  requete_nombre_especes_par_annee <- "
    SELECT d.year_obs AS annee, COUNT(DISTINCT o.observed_scientific_name) AS nombre_especes
    FROM observation o
    JOIN date d ON o.dwc_event_date = d.dwc_event_date
    GROUP BY d.year_obs
    ORDER BY d.year_obs;
  "
  resultats_nombre_especes <- dbGetQuery(con, requete_nombre_especes_par_annee)
  setwd(chemin_acces)
  write.csv(resultats_nombre_especes, file="resultat_richesse.csv")
  return(resultats_nombre_especes)
  
  dbDisconnect(con)
}