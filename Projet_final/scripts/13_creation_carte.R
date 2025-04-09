# regrouper les donneés par latitude, arrondies à 1 unité la plus basse (ex: 45,9 devient 45)
# latitude 45 à 53

install.packages("dplyr")
library(dplyr)

df <- res_carte%>%
  mutate(
    lat_arrondi = floor(latitude),
    lon_arrondi = floor(longitude)
  )

resultat <- df %>%
  group_by(lat_arrondi, lon_arrondi) %>%
  summarise(
    total_especes = sum(nombre_especes),
    .groups = 'drop'
  )

