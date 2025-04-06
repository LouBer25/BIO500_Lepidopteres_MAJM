#Création des dataframe de données à injecter dans les SQL
##Pour chaque dataframe créer :
	###Conservation des colonnes nécessaires seulement grâce à une fonction "subset"
	###Enregistrement du fichier en format csv pour utilisation ultérieur

####Création du dataframe espece
espece <- function(chemin_acces){
	taxo_BD <- read.csv("taxonomie_BD.csv")
	res.1.espece <- (subset(taxo_BD, select = c(observed_scientific_name, valid_scientific_name, rank, vernacular_fr, kingdom, phylum, class, order, family, genus, species, itis_code)))
	res.2.espece <- unique(res.1.espece)
	write.csv(res.2.espece, file="espece.csv")
	return(res.2.espece)
}

#####Création du dataframe date
date <- function(chemin_acces){
	lepidopteres_final <- read.csv("lepido_final.csv")	
	res.1.date <- subset(lepidopteres_final, select = c(year_obs, day_obs, time_obs, dwc_event_date))
	res.2.date <- unique(res.1.date)
	write.csv(res.2.date, file="date.csv")
	return(res.2.date)
}

####Création du dataframe source
source <- function(chemin_acces){
	lepidopteres_final <- read.csv("lepido_final.csv")
	res.1.source <- subset(lepidopteres_final, select = c(original_source, creator, title, publisher, intellectual_rights, license, owner))
	res.2.source <- unique(res.1.source)
	write.csv(res.2.source, file="source.csv")
	return(res.2.source)
}

####Création du dataframe latitude
latitude <- function(chemin_acces){
	lepidopteres_final <- read.csv("lepido_final.csv")
	res.1.latitude <- subset(lepidopteres_final, select = c(lat))
	res.2.latitude <- unique(res.1.latitude)
	write.csv(res.2.latitude, file="latitude.csv")
	return(res.2.latitude)
}

####Création du dataframe longitude
longitude <- function(chemin_acces){
	lepidopteres_final <- read.csv("lepido_final.csv")
	res.1.longitude <- subset(lepidopteres_final, select = c(lon))
	res.2.longitude <- unique(res.1.longitude)
	write.csv(res.2.longitude, file="longitude.csv")
	return(res.2.longitude)
}

####Création du dataframe abbondance
abbondance <- function(chemin_acces){
	lepidopteres_final <- read.csv("lepido_final.csv")
	res.1.abbondance <- subset(lepidopteres_final, select = c(obs_variable))
	res.2.abbondance <- unique(res.1.abbondance)
	write.csv(res.2.abbondance, file="abbondance.csv")
	return(res.2.abbondance)
}

####Création du dataframe observation
observation <- function(chemin_acces){
	lepidopteres_final <- read.csv("lepido_final.csv")
	res.1.observation <- subset(lepidopteres_final, select = c(observed_scientific_name, dwc_event_date, title, obs_value, lat, lon))
	write.csv(res.1.observation, file="observation.csv")
	return(res.1.observation)
}

