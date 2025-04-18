# 1) Fonction qui génère la base de données dans R.
# nécessite package readr

Lepidopteres_BD <- function(chemin_acces){
  lepido_files <- list.files(chemin_acces, pattern="\\.csv$", full.names=F)
  setwd(chemin_acces)
 	lepido_BD <- read_csv(file=lepido_files, id="file")
}