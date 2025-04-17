#setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")
setwd("C:/Users/alex/OneDrive - USherbrooke/École/Hiver_2025/Écologie Computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")
library(targets)
library(rmarkdown)
library(tarchetypes)
source("./scripts/fonctions_assemblage_pour_target.R")
source("./scripts/15_creation_carte_graph.R")


list(
	tar_target(
	  librairie_et_source_pour_nettoyage_des_donnees,
		lecture_donnees("./scripts")
	),
	tar_target(
		assemblage_et_nettoyage_des_donnees,
		assemblage_donnees(librairie_et_source_pour_nettoyage_des_donnees)
	),
	tar_target(
		creation_bd_SQL,
		creation_SQL(assemblage_et_nettoyage_des_donnees)
	),
	tar_target(
		requetes_et_graphiques_SQL,
		graph_richesse_specifique(creation_bd_SQL)
	),
	tar_render(
		rapport,
		path = "./scripts/Rapport_lepidopteres/Rapport_lepidopteres.Rmd"
	)
)

#tar_visnetwork() #visualiser les dépendances
#tar_make() # make it work!À écrire seulement dans la console