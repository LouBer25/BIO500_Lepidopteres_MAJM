# 5) Fonction qui remplace la valeur textuelle de la colonne obs_variable en valeur numérique
# nécessite package dplyr

obs_variable <- function(tableau){
  lepido_new <- lepido_new %>%  
    mutate(obs_variable = recode(obs_variable,       #Fonction pour recoder la valeur textuel en valeur numérique
                                 "occurrence" = 0,   #la valeur occurence sera remplacée par 0
                                 "presence" = 1,    #la valeur presence sera remplacée par 1
                                 "pr@#sence" = 1,   #la valeur prsesence écrite avec un "é" sera remplacée par 1
                                 "abundance" = 2,     #la valeur abundance sera remplacée par 2
                                 .default = NA_real_ #Si mal écrit ou pas de valeur remplacé par NA  
    ))
}