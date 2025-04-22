# 22) Fonction pour la création de la carte pour l'année 2020

graph_carte <- function(requete) {
  carte <- requete[[3]]
  # Vérification des colonnes afin d'éviter des bugs
  if (!all(c("latitude", "longitude", "nombre_especes") %in% colnames(carte))) {
    stop("Le tableau 'carte' doit contenir les colonnes : latitude, longitude, nombre_especes")
  }
  
  # Regrouper le nombre d'espèce par secteur
  df <- carte %>%
    mutate(
      lat_arrondi = floor(latitude),
      lon_arrondi = floor(longitude)
    ) %>%
    group_by(lat_arrondi, lon_arrondi) %>%
    summarise(total_especes = sum(nombre_especes), .groups = "drop")
  
  # Transformer en donnée géospatial
  df_sf <- st_as_sf(df, coords = c("lon_arrondi", "lat_arrondi"), crs = 4326)
  
  # Acquisition des données de contour du Canada
  canada <- ne_states(country = "Canada", returnclass = "sf")
  
  # Extraire seulement le Québec des données Canada
  quebec <- canada %>% filter(name_en == "Quebec")
  
  # Création de la carte avec ggplot
  graphique_carte <- ggplot() +
    # Ajouter les contours du Québec au graphique afin d'obetenir un visuel graphique des données
    geom_sf(data = quebec, fill = NA, color = "darkblue", size = 1.2) +
    
    # Points de données (richesse spécifique) avec taille et couleur
    geom_sf(data = df_sf, aes(size = total_especes, color = total_especes), alpha = 0.7) +
    
    # Ajouter les couleurs en fonction du nombre d'espèce
    scale_color_viridis(option = "C", direction = 1, name = "Nombre d'espèces") +
    
    # Range des tailles des données
    scale_size_continuous(range = c(2, 8), name = "Nombre d'espèces") +
    
    # Titres et légendes
    labs(
      subtitle = "Richesse spécifique par case de 1°",
      color = "Richesse\nSpécifique",
      size = "Nombre\nD'espèces"
    ) +
    
    #Personaliser le fond et la grille pour un visuel plus original
    theme_minimal() +
    theme(
      plot.title = element_text(size = 16, face = "bold", color = "darkblue", hjust = 0.5),
      plot.subtitle = element_text(size = 12, face = "italic", color = "gray40", hjust = 0.5),
      plot.caption = element_text(size = 10, color = "gray40", hjust = 1),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(size = 10),
      axis.text = element_text(size = 10, color = "gray40")
    ) +
    
    # Afficher seulement la partie du Québec selon les données
    coord_sf(xlim = c(-81, -56), ylim = c(44, 54), expand = FALSE)
    
    #Enregistrer le graphique en png  
    chemin_carte <- ("./scripts/Rapport_lepidopteres/graphique_carte.png")
    ggsave(chemin_carte, plot = graphique_carte, width = 10, height = 8)
  return(chemin_carte)
}