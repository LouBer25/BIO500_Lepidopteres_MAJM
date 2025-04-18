# 20) Fonction pour la création du graphique richesse spécifique

graph_richesse_specifique <- function() {
  richesse_specifique <- requete[[1]]
  ggplot(richesse_specifique, aes(x = annee, y = nombre_especes)) +
    geom_line(color = "blue") +
    labs(title = "Nombre d'espèces par année",
         x = "Année", 
         y = "Nombre d'espèces") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}