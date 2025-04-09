# regrouper les donneés par latitude, arrondies à 1 unité la plus basse (ex: 45,9 devient 45)
# latitude 45 à 53

install.packages("dplyr")
library(dplyr)

# 1) Arrondir les latitudes et longitudes à l'unité inférieure (floor)
df <- res_carte%>%
  mutate(
    lat_arrondi = floor(latitude),
    lon_arrondi = floor(longitude)
  )

# 2) Regrouper les données par latitude et longitude arrondies, et calculer la somme des espèces
resultat <- df %>%
  group_by(lat_arrondi, lon_arrondi) %>%
  summarise(
    total_especes = sum(nombre_especes),
    .groups = 'drop'
  )


install.packages("terra")
library(terra)

# Créer un raster avec les dimensions correspondant à la latitude et longitude
# Créer un raster vide
raster <- rast(nrows = length(unique(resultat$lat_arrondi)),
              ncols = length(unique(resultat$lon_arrondi)),
              ext = c(min(resultat$lon_arrondi), max(resultat$lon_arrondi),
                     min(resultat$lat_arrondi), max(resultat$lat_arrondi)))

# Donner des valeurs aux pixels du raster en fonction des données
# Assigner les valeurs de "total_especes" aux pixels du raster

values(raster) <- NA
for (i in 1:nrow(resultat)){
  row_idx <- which.min(abs(resultat$lat_arrondi[i] - ext(raster)[3:4])) # Trouver l'index de la ligne
  col_idx <- which.min(abs(resultat$lon_arrondi[i] - ext(raster)[1:2])) # Trouver l'index de la colonne
  raster[row_idx, col_idx] <- resultat$total_especes[i]
}

# Visualiser la carte avec un gradient de couleur
plot(raster, main = "Carte des espèces par latitude et longitude",
     col = viridis)  # Utilisez un gradient de couleurs (par exemple terrain.colors)
