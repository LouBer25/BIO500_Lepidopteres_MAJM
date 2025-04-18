# 22) Fonction pour la création de la carte

graph_carte <- function() {
  carte <- requete[[3]]
  # Vérification des colonnes
  if (!all(c("latitude", "longitude", "nombre_especes") %in% colnames(carte))) {
    stop("Le tableau 'carte' doit contenir les colonnes : latitude, longitude, nombre_especes")
  }
  
  # Étape 1: Regrouper les observations par case arrondie
  df <- carte %>%
    mutate(
      lat_arrondi = floor(latitude),
      lon_arrondi = floor(longitude)
    ) %>%
    group_by(lat_arrondi, lon_arrondi) %>%
    summarise(total_especes = sum(nombre_especes), .groups = "drop")
  
  # Étape 2: Transformer en objet spatial pour ggplot
  df_sf <- st_as_sf(df, coords = c("lon_arrondi", "lat_arrondi"), crs = 4326)
  
  # Étape 3: Récupérer le contour du Canada
  canada <- ne_states(country = "Canada", returnclass = "sf")
  
  # Étape 4: Extraire seulement le Québec
  quebec <- canada %>% filter(name_en == "Quebec")
  
  # Étape 5: Afficher la carte avec ggplot
  ggplot() +
    # Contour du Québec avec bordure élégante
    geom_sf(data = quebec, fill = NA, color = "darkblue", size = 1.2) +
    
    # Points de données (richesse spécifique) avec taille et couleur
    geom_sf(data = df_sf, aes(size = total_especes, color = total_especes), alpha = 0.7) +
    
    # Ajouter la palette de couleurs viridis
    scale_color_viridis(option = "C", direction = 1, name = "Nombre d'espèces") +
    
    # Taille des points
    scale_size_continuous(range = c(2, 8), name = "Nombre d'espèces") +
    
    # Titres et légendes
    labs(
      title = "Distribution des lépidoptères au Québec en 2020",
      subtitle = "Richesse spécifique par case de 1°",
      caption = "Source : Observations des lépidoptères",
      color = "Richesse\nSpécifique",
      size = "Nombre\nD'espèces"
    ) +
    
    # Personnalisation du fond et de la grille
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
    
    # Coordonnées et zoom sur le Québec
    coord_sf(xlim = c(-80, -57), ylim = c(44, 54), expand = FALSE)
}