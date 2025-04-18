# 7) Fonction qui transforme le nom textuel en code ITIS
Transformation_en_code_taxo <- function(taxonomie_BD) {
  
  # Extraire les noms uniques dans l'ensemble du tableau
  unique_names <- unique(taxonomie_BD$observed_scientific_name)
  print("Unique names to search:")
  print(unique_names)
  
  # Fonction qui récupère le code ITIS pour chaque nom
  get_tsn <- function(name, idx) {
    print(paste("Processing", idx, "of", length(unique_names), ":", name))  # Affichage du numéro de l'itération
    result <- tryCatch(ritis::search_scientific(name), error = function(e) NULL)
    
    if (!is.null(result) && nrow(result) > 0) {
      tsn <- as.character(result$tsn[1])
      print(paste("Found ITIS code:", tsn))  # Affichage du code ITIS trouvé
    } else {
      tsn <- NA_character_
      print("No ITIS code found.")
    }
    Sys.sleep(0.5)  # Petite pause pour éviter trop de requêtes
    return(tsn)
  }
  
  # Obtenir les codes ITIS pour les noms scientifiques séquentiellement
  tsn_results <- map2_chr(unique_names, seq_along(unique_names), get_tsn)
  
  # Affichage du résultat des recherches
  print("TSN results:")
  print(tsn_results)
  
  # Créer une table de correspondance entre les noms et les codes ITIS
  name_to_tsn <- setNames(tsn_results, unique_names)
  
  # Ajouter la colonne 'itis_code' pour toutes les lignes du tableau
  taxonomie_BD$itis_code <- name_to_tsn[taxonomie_BD$observed_scientific_name]
  print("Taxonomie_BD avec itis_code ajouté:")
  print(head(taxonomie_BD))  # Affiche les premières lignes du tableau
  
  # Retourner le dataframe mis à jour
  return(taxonomie_BD)
}