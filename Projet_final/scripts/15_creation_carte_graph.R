#Fabrication graphique richesse spéficique
#ATTENTION ATTENTION ATTENTION POSSIBLEMENT CHANGER nb_especes EN FONCTION DU RÉSULTATS DANS SQL car nouvelle colonne qui compte
source("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/BIO500_Lepidopteres_MAJM/Projet_final/scripts/scripts/14_requetes_SQL.R")

graph_richesse_specifique <- function(richesse_specifique) {
  ggplot(richesse_specifique, aes(x = year_obs, y = nb_especes)) +
    geom_line(color = "blue") +
    labs(title = "Nombre d'espèces par année",
         x = "Année", 
         y = "Nombre d'espèces") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

#-------------------------------------------------------------------------------------------------------------------------------
#Fabrication graphique latitude années

graph_latitude_annee <- function(latitude_annee) {
  
  # Créer une nouvelle colonne "period" pour chaque espèce
  lepido_new <- lepido_new %>%
    mutate(period = floor(year_obs / 20) * 20)
  
  # Filtrer les données pour les 4 espèces spécifiques
  data_speces <- lepido_new %>%
    filter(observed_scientific_name %in% c("Colias philodice", "Poanes hobomok", "Pieris rapae", "Cercyonis pegala"))  # Filtrer pour les espèces
  
  # Créer les boxplots pour chaque espèce
  ggplot(data_speces, aes(x = factor(period), y = lat, fill = observed_scientific_name)) +
    geom_boxplot(outlier.shape = NA, color = "black", alpha = 0.3) +
    labs(title = "Latitude des espèces par période de 20 ans",
         x = "Période (années)", 
         y = "Latitude") +
    theme_minimal() +
    facet_wrap(~ observed_scientific_name, scales = "free_x") +  # Ajouter les axes X pour toutes les facettes
    coord_cartesian(ylim = c(40, 60)) +  # Limiter l'axe y
    theme(axis.text.x = element_text(angle = 45, hjust = 1),  # Rotation des étiquettes de l'axe x
          strip.text.x = element_text(size = 12))  # Ajuster la taille du texte des titres des facettes
}

#----------------------------------------------------------------------------------------------------
#Création de la carte qui répartit les lieux au Québec avec la plus grande richesse spécifique
#ATTENTION POSSIBLEMENT CHANGER LATITUDE,LONGITUDE ETC.EN lat et lon. SELON REQUETE SQL

graph_carte <- function(carte) {
  
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
