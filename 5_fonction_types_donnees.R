# 5) Fonction pour convertir les données dans les bons types
## à retravailler, dit que ça intègre des NA lors de la conversion automatique

convertir_types <- function(df) {
  df_clean <- df  # Copier le dataframe
  
  # Conversion en character
  char_cols <- c("observed_scientific_name", "obs_variable", "original_source", 
                 "creator", "title", "publisher", "intellectual_rights", 
                 "license", "owner")
  df_clean[char_cols] <- lapply(df_clean[char_cols], as.character)
  
  # Conversion en integer
  int_cols <- c("year_obs", "day_obs", "obs_value")
  df_clean[int_cols] <- lapply(df_clean[int_cols], function(x) as.integer(as.numeric(x)))
  
  
  
  # Conversion en double (nombre réel)
  double_cols <- c("lat", "lon")
  df_clean[double_cols] <- lapply(df_clean[double_cols], as.numeric)
  
  
  return(df_clean)
}