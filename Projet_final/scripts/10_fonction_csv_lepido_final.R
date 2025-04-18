#10) Fonction pour créer le fichier csv "lepido_final.csv"

ecrire_lepido_final <- function(lepido_final){
	if (file.exists("./lepido_final.csv")){
		print ("Le document lepido_final existe déjà dans le répertoire")
	}else{
	  write.csv(lepido_final, file="lepido_final.csv")
	}
}
