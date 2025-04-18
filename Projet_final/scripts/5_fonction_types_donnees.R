# 5) Fonction pour convertir les données dans les bons types
## à retravailler, dit que ça intègre des NA lors de la conversion automatique

convertir_types <- function(lepido_new) {
    
  # Conversion en character
  char_cols <- c("observed_scientific_name", "obs_variable", "original_source", 
                 "creator", "title", "publisher", "intellectual_rights", 
                 "license", "owner")
  lepido_new[char_cols] <- lapply(lepido_new[char_cols], as.character)
  
  # Conversion en integer
  int_cols <- c("year_obs", "day_obs", "obs_value")
  lepido_new[int_cols] <- lapply(lepido_new[int_cols], function(x) as.integer(as.numeric(x)))
  
  
  
  # Conversion en double (nombre réel)
  double_cols <- c("lat", "lon")
  lepido_new[double_cols] <- lapply(lepido_new[double_cols], as.numeric)
  
  
  return(lepido_new)
}