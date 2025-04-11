setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final")
library(targets)
library(rmarkdown)
library(tarchetypes)
source("./scripts/fonctions_assemblage_pour_target.R")


list(
	tar_target(
		librairie_et_source_pour_nettoyage_des_donnees,
		lecture_donnees("./scripts")
	),
	tar_target(
		assemblage_et_nettoyage_des_donnees,
		assemblage_donnees("../Projet_final/Lepidopteres_BD")
	),
	tar_target(
		creation_bd_SQL,
		creation_SQL("./scripts/11_fonction_cration_donnees.R")
	),
	tar_target(
		requetes_et_graphiques_SQL,
		requetes_SQL("./14_requetes_SQL.R")
	),
	tar_render(
		rapport,
		path = "./Rapport_lepidopteres/Rapport_lepidopteres.Rmd"
	)
)
