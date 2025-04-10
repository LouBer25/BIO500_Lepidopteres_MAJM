# regrouper les donneés par latitude, arrondies à 1 unité la plus basse (ex: 45,9 devient 45)
# latitude 45 à 53

## faire une fonction avec ça, l'étape c bogue lorque mis dans une fonction

creer_carte <- function(chemin_acces)
  setwd(chemin_acces)
    # b) installation des packages nécessaires
  library(dplyr)
  library(terra)
  
  # a) Créer un tableau avec les données extraites de la requête
  res_carte <- read.table(file = "data/res_carte.csv")
  
  # c) Arrondir les latitudes et longitudes à l'unité inférieure (floor)
  df <- res_carte%>%
    mutate(
      lat_arrondi = floor(latitude),
      lon_arrondi = floor(longitude)
    )
  
  # d) Regrouper les données par latitude et longitude arrondies, et calculer la somme des espèces
  resultat <- df %>%
    group_by(lat_arrondi, lon_arrondi) %>%
    summarise(
      total_especes = sum(nombre_especes),
      .groups = 'drop'
    )
  
  # e) Convertir data.frame en objet spatial SpatVector
  points_vect <- vect(resultat, geom = c("lon_arrondi", "lat_arrondi"))
  
  # f) Créer un raster vide (définir résolution et étendue)
  r <- rast(ext(-80,-58,44,53), resolution = 1)  # ici 1° de résolution
  
  # g) Ajouter les données pour créer les points sur le raster
  r_rasterized <- rasterize(points_vect, r, field = "total_especes")
  
  # h) Créer la carte
  # les latitudes sont comptée vers le bas, ex. un carré complètement en bas regroupe les données pour la latitude [45, 46[
  # les longitudes sont comptées vers la droite, ex. un carré complètement à gauche regroupe les données pour la longitude [-80, -79[
  carte_distribution <- plot(r_rasterized, main = "Distribution de la richesse spécifique de lépidoptères au Québec")
  savePlot(filename ="data/carte_distribution_richesse", type = "png")