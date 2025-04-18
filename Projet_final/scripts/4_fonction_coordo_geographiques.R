# 4) Fonction pour Corriger les coordonnées géographiques
corriger_coordonnees <- function(df) {
  df_clean <- df
  
  # Remplacer les valeurs aberrantes par NA
  df_clean$lat[df_clean$lat < -90 | df_clean$lat > 90] <- NA
  df_clean$lon[df_clean$lon < -180 | df_clean$lon > 180] <- NA
  
  return(df_clean)
}
