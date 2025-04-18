### 5) Création graphiques richesse spécifique
setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")

graphique_richesse_specifique <- function (){

	source("./scripts/141_richesse_specifique.R")
	source("../scripts/15_creation_carte_graph.R")

	# a)Graphique de la richesse spécifique
	graph_richesse_specifique(richesse_specifique("../data"))
	return(graph_richesse_specifique)
}