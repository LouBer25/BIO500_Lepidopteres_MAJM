#8)Fonction pour ajouter le code itis au tableau taxonomie

tableau_taxonomie <- function(chemin_acces){
	taxonomie_BD <- read.csv(chemin_acces)
	if (file.exists("./tables_pour_SQL/taxonomie_BD.csv")){
		print ("Le document taxonomie_BD existe déjà dans le répertoire")
	}else{
	  source("./scripts/7_fonction_taxonomie_itis.R")
		taxonomie_BD <- Transformation_en_code_taxo(taxonomie_BD)
		write.csv(taxonomie_BD, file="./tables_pour_SQL/taxonomie_BD.csv")
	}
	return (taxonomie_BD)
}