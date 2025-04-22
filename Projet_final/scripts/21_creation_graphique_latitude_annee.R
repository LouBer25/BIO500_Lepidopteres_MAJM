# 21) Fonction pour la création du graphique latitude année de quatres espèces

graph_latitude_annee <- function(requete) {
  latitude_annee <- requete[[2]]
  # Création d'une colonne appelé period, car on veut résultat par période de 20 ans
  latitude_annee <- latitude_annee %>%
    mutate(
	annee = as.numeric(annee),
	period = floor(annee / 20) * 20)

  # Choisir seulement les données des quatres espèces
  data_speces <- latitude_annee %>%
    filter(observed_scientific_name %in% c("Colias philodice", "Poanes hobomok", "Pieris rapae", "Cercyonis pegala"))  # Espèce choisit
  
  # Création du graphique
  graphique_latitude <- ggplot(data_speces, aes(x = factor(period), y = lat, fill = observed_scientific_name)) +
    geom_boxplot(outlier.shape = NA, color = "black", alpha = 0.3) +
    # Ajusté le nom des colonnes
    labs(x = "Période (années)", 
         y = "Latitude") +
    theme_minimal() +
    facet_wrap(~ observed_scientific_name, scales = "free_x") +  # Ajouter les axes X pour chacune des espèces
    coord_cartesian(ylim = c(40, 60)) +  # Limiter l'axe y à leur maximum et leur minimum
    theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Ajouter une angle dans les étiquettes pour un meilleur visuel
          strip.text.x = element_text(size = 12))  # Ajuster les tailles
  #Enregistrer le graphique en png  
  chemin_latitude_annee <- ("./scripts/Rapport_lepidopteres/graphique_latitude.png")
  ggsave(chemin_latitude_annee, plot = graphique_latitude, width = 8, height = 8)
 return(graphique_latitude)
}