# 5) Fonction qui remplace la valeur textuelle de la colonne obs_variable en valeur numérique dans lepido_new

remplacer_obs_variable <- function(tableau) {
  
  # Relier les valeurs
  trans_obs_variable <- c("occurrence" = 0,
                          "presence" = 1, 
                         "pr@#sence" = 1,
                          "abundance" = 2)
  
  lepido_new$obs_variable <- trans_obs_variable[lepido_new$obs_variable] #Remplacage
  
  return(lepido_new) #retourner lepido_new
}