#10) Fonction pour créer le fichier csv "lepido_final.csv"

ecrire_lepido_final <- function(lepido_final){
	if (file.exists("./data/lepido_final.csv")){
		print ("Le document lepido_final existe déjà dans le répertoire")
	}else{
	  write.csv(lepido_final, file="./data/lepido_final.csv")
	}
}
