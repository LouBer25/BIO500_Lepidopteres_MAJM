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

# Convertir df en objet spatial SpatVector
points_vect <- vect(resultat, geom = c("lon_arrondi", "lat_arrondi"))

# Créer un raster vide (définir résolution et étendue)
r <- rast(ext(points_vect), resolution = 1)  # ici 1° de résolution

# "Griller" les points sur le raster
r_rasterized <- rasterize(points_vect, r, field = "total_especes", fun = "sum")

# Afficher
plot(r_rasterized, main = "Richesse spécifique de lépidoptères ")
