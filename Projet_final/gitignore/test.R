setwd("C:/Users/marbe/Desktop/UdeS Hiver 2025/Méthodes en écologie computationnelle/Projet_final")

taxonomie_test <- read.csv("taxonomie.csv")

taxonomie_test <- taxonomie_test[1:10,]

write.csv(taxonomie_test, file="taxonomie_test.csv")