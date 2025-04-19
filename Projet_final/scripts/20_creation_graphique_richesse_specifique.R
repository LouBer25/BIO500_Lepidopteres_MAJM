# 20) Fonction pour la création du graphique richesse spécifique

graph_richesse_specifique <- function(requete) {
  richesse_specifique <- requete[[1]]
  graphique_richesse <- ggplot(richesse_specifique, aes(x = annee, y = nombre_especes)) +
    geom_line(color = "blue") +
    labs(x = "Année", 
         y = "Nombre d'espèces") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
    ggsave("./data/graphique_richesse.pdf", plot = graphique_richesse, width = 8, height = 8)
}