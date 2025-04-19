# 21) Fonction pour la création du graphique latitude année

graph_latitude_annee <- function(requete) {
  latitude_annee <- requete[[2]]
  # Créer une nouvelle colonne "period" pour chaque espèce
  latitude_annee <- latitude_annee %>%
    mutate(
	annee = as.numeric(annee),
	period = floor(annee / 20) * 20)

  # Filtrer les données pour les 4 espèces spécifiques
  data_speces <- latitude_annee %>%
    filter(observed_scientific_name %in% c("Colias philodice", "Poanes hobomok", "Pieris rapae", "Cercyonis pegala"))  # Filtrer pour les espèces
  
  # Créer les boxplots pour chaque espèce
  graphique_latitude <- ggplot(data_speces, aes(x = factor(period), y = lat, fill = observed_scientific_name)) +
    geom_boxplot(outlier.shape = NA, color = "black", alpha = 0.3) +
    labs(x = "Période (années)", 
         y = "Latitude") +
    theme_minimal() +
    facet_wrap(~ observed_scientific_name, scales = "free_x") +  # Ajouter les axes X pour toutes les facettes
    coord_cartesian(ylim = c(40, 60)) +  # Limiter l'axe y
    theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotation des étiquettes de l'axe x
          strip.text.x = element_text(size = 12))  # Ajuster la taille du texte des titres des facettes
    ggsave("./data/graphique_latitude.pdf", plot = graphique_latitude, width = 8, height = 8)
}