#Création des dataframe de données à injecter dans les SQL
##Pour chaque dataframe créer :
	###Conservation des colonnes nécessaires seulement grâce à une fonction "subset"
	###Enregistrement du fichier en format csv pour utilisation ultérieur

####Création du dataframe espece
espece <- function(x){
  taxo_BD <- x
	res.1.espece <- subset(taxo_BD, select = c(observed_scientific_name, valid_scientific_name, rank, vernacular_fr, kingdom, phylum, class, order, family, genus, species, itis_code))
	res.2.espece <- res.1.espece %>%
           distinct(observed_scientific_name, .keep_all = TRUE)
	write.csv(res.2.espece, file="./tableaux_csv/espece.csv")
	return(res.2.espece)
}

#####Création du dataframe date
date <- function(x){
  lepidopteres_final <- x
	res.1.date <- subset(lepidopteres_final, select = c(year_obs, day_obs, time_obs, dwc_event_date))
	res.2.date <- res.1.date %>%
           distinct(dwc_event_date, .keep_all = TRUE)
	write.csv(res.2.date, file="./tableaux_csv/date.csv")
	return(res.2.date)
}

####Création du dataframe source
source <- function(x){
  lepidopteres_final <- x
	res.1.source <- subset(lepidopteres_final, select = c(original_source, creator, title, publisher, intellectual_rights, license, owner))
	res.2.source <- res.1.source %>%
           distinct(title, .keep_all = TRUE)
	write.csv(res.2.source, file="./tableaux_csv/source.csv")
	return(res.2.source)
}

####Création du dataframe latitude
latitude <- function(x){
  lepidopteres_final <- x
	res.1.latitude <- subset(lepidopteres_final, select = c(lat))
	res.2.latitude <- res.1.latitude %>%
           distinct(lat, .keep_all = TRUE)
	write.csv(res.2.latitude, file="./tableaux_csv/latitude.csv")
	return(res.2.latitude)
}

####Création du dataframe longitude
longitude <- function(x){
  lepidopteres_final <- x
	res.1.longitude <- subset(lepidopteres_final, select = c(lon))
	res.2.longitude <- res.1.longitude %>%
           distinct(lon, .keep_all = TRUE)
	write.csv(res.2.longitude, file="./tableaux_csv/longitude.csv")
	return(res.2.longitude)
}

####Création du dataframe abbondance
abbondance <- function(x){
  lepidopteres_final <- x
	res.1.abbondance <- subset(lepidopteres_final, select = c(obs_variable))
	res.2.abbondance <- res.1.abbondance %>%
           distinct(obs_variable, .keep_all = TRUE)
	write.csv(res.2.abbondance, file="./tableaux_csv/abbondance.csv")
	return(res.2.abbondance)
}

####Création du dataframe observation
observation <- function(x){
  lepidopteres_final <- x
	lepidopteres_final$id_observation <- 1:nrow(lepidopteres_final)
	res.1.observation <- subset(lepidopteres_final, select = c(observed_scientific_name, dwc_event_date, title, obs_variable, lat, lon, id_observation))
	write.csv(res.1.observation, file="./tableaux_csv/observation.csv")
	return(res.1.observation)
}

