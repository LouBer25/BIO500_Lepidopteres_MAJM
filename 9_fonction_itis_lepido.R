#9) Fonction pour ajouter le code itis au tableau lepido_new

colonne_itis <- function(chemin_acces){
	setwd(chemin_acces)
	taxonomie_itis <- read.csv("taxonomie_BD.csv")
	lepido_new <- lepido_new %>%
  	left_join(
		taxonomie_itis %>% select(observed_scientific_name, itis_code),
		by = "observed_scientific_name",
		relationship = "many-to-many"
 	)
}
