#10) Fonction pour créer le fichier csv "lepido_final.csv"

ecrire_lepido_final <- function(chemin_acces){
	if (file.exists(chemin_acces)){
		print ("Le document lepido_final existe déjà dans le répertoire")
	}else{
	  lepido_final <- lepido_new
	  
	  setwd(chemin_acces)
	  setwd("./data")
		write.csv(lepido_new, file="lepido_final.csv")
	}
}
