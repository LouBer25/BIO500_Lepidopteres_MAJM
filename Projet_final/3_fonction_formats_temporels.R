# 3) Fonction pour détecter et corriger les formats temporels   ###erreur à corriger
corriger_dates <- function(df) {
  df_clean <- df
  
  # Obtenir l'année actuelle 
  current_year <- as.numeric(format(Sys.Date(), "%Y"))
  
  # Corriger `Year_obs` (si année aberrante, on met `NA`)
  df_clean$year_obs <- ifelse(df_clean$year_obs < 1800 | df_clean$year_obs > current_year, NA, df_clean$year_obs)
  
  # Corriger `Day_obs` (si jour invalide, on met `NA`)
  df_clean$day_obs <- ifelse(df_clean$day_obs < 1 | df_clean$day_obs > 31, NA, df_clean$day_obs)
  
  # Corriger `Time_obs` (format HH:MM, sinon remplacer par "00:00")
  valid_time <- !is.na(df_clean$time_obs) & grepl("^([01][0-9]|2[0-3]):[0-5][0-9]$", df_clean$time_obs)
  df_clean$time_obs[!valid_time] <- "00:00"
  
  # Corriger `Dwc_event_date` (conversion en POSIXct, valeurs invalides -> NA)
  df_clean$dwc_event_date <- suppressWarnings(as.POSIXct(df_clean$dwc_event_date, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
  
  return(df_clean)
}
