#8)Fonction pour ajouter le code itis au tableau taxonomie

tableau_taxonomie <- function(chemin_acces){
	setwd(chemin_acces)
	if (file.exists("taxonomie_BD.csv")){
		print ("Le document taxonomie_BD existe déjà dans le répertoire")
	}else{
		taxonomie_BD <- Transformation_en_code_taxo(taxonomie_BD)
		write.csv(taxonomie_BD, file="taxonomie_BD.csv")
	}
	return (taxonomie_BD)
}