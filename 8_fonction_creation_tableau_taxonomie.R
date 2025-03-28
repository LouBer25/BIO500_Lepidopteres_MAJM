#8)Fonction pour ajouter le code itis au tableau taxonomie

tableau_taxonomie <- function(chemin_acces){
	if (file.exists(chemin_acces)){
		print ("Le document taxonomie_BD existe déjà dans le répertoire")
	}else{
		taxonomie_BD <- Transformation_en_code_taxo(taxonomie_BD)
		write.csv(taxonomie_BD, file=c(emplacement_fichier,"taxonomie_BD.csv"))
	}
	return (taxonomie_BD)
}