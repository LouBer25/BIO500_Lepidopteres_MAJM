# Projet de session sur les lépidoptères

*Créé par Marilou Bernard, Juliette Boucher, Maïté-Simone Gauthier-Bénard et Alexandre Tougas*

Dans le cadre du cours BIO500 - Méthodes en écologie computationnelle, nous devions réaliser une analyse des changements de biodiversité au Québec, nous avons choisi le sujet des lépidoptères qui nous intéressait particulièrement. Nous avons tenté de répondre à la question suivante :

**Comment les variations spatiales et temporelles influent-elles sur la structure des communauté?**

Pour ce faire, nous avons rassemblé et nettoyé les données brutes de Biodiversité Québec. Nous les avons ensuite entreposées dans une base de données SQL. Nous avons créé plusieurs requêtes à la base de données afon de répondre à notre question de recherche. Nous avons finalement créé un article comprenant plusieurs sources répondant à la question de recherche avec des figures que nous avons créées pour mieux démontrer nos résultats.

## 1. Exécution du programme

Pour une exécution rapide de notre projet, dans un souci de clé en main exécutez les étapes suivantes :

1.  Ouvir le fichier \*\_targets.R\* qui est dans le dossier *BIO500_Lepidopteres_MAJM/Projet_final*
2.  Fixer votre "Working Directory" au dossier *BIO500_Lepidopteres_MAJM/Projet_final*
3.  Sélectionner tout le code (Ctrl+A) et exécuter, enregistrer les modifications
4.  Écrire dans la console tar_make() et exécuter.

Notre rapport est également disponible à cet emplacement : *Projet_final/scripts/Rapport_lepidopteres/Rapport_lepidopteres.pdf*

## 2. Arborescence

### 2.1 BIO_Lepidopteres_MAJM

Dossier principal contenant tous sous-dossiers du projet :

-   `.gitignore`
-   `.Rhistory` : ce fichier reviendra dans d'autres sous-dossier, il compile l'historique du projet
-   `BIO500_Lepidopteres_MAMJ.Rproj` : projet principal qui permet de se connecter avec Github
-   `donnee.db` : fichier présent dans plusieurs sous-dossier nécessaire (et présent dans chaque sous-dossier), il permet la connexion avec la base de données SQL.
-   `Projet_final` : dossier regroupant tous les autres sous-dossiers dans lesquels nous travaillons

### 2.2 Projet_final

Dossier regroupant tous les autres sous-dossiers dans lesquels nous travaillons. Il est au centre de l'exécution du code, puisque le *directory* y est instauré.

-   `_targets`: dossier contenant les métadonnées et les objets temporaires pour l'exécution des targets. Il sera présent dans plusieurs autres sous-dossiers
-   `_targets.R` : Script principal qui permet d'automatiser tout le travail lors de modifications
-   `gitignore` : dossier contenant des scrips non-utilisés, mais qui ont une valeur sentimentale, car on y a mis beaucoup de temps
-   `Lepidopteres_BD`: contient tous les fichiers de données brutes en format .csv
-   `scripts`: dossier qui contient tous les scripts utilisés
-   `tableaux_csv`: dossier qui contient des fichiers de données traitées

### 2.3 Lepidopteres_BD

Dossier contenant les fichiers de données brutes.

Ce jeu de données présente des observations de lépidoptères dans le temps et l'espace. Ces données sont fidèles à ce qu'on peut s'attendre d'une extraction de sources différentes et peuvent contenir des erreurs. Notez qu'elles ont déjà été standardisées pour vous.

Les données ont été collectées dans le cadre d'un programme de surveillance de la biodiversité, d'études scientifiques et de science citoyenne. Les observations sont caractérisées par l'espèce observée, la date et l'heure de l'observation, le lieu, le nombre d'individus observés et d'autres informations pertinentes. Il est possible que la nature des données ne soit pas homogène, car elles proviennent de différentes sources. Parfois une observation ponctuelle, parfois un dénombrement. Il est important de valider les données avant de les utiliser.

Les données ont été collectées de plusieurs sources par Biodiversité Québec et comprennent l'identification taxonomique, temporelle et spatiale des densités de populations. Il y a aussi l'information sur l'origine des données, les auteurs, les propriétaires et les licences.

#### Fichiers de données

-   `*.csv` Ensemble d'observations de lépidotères pour une année donnée. Chaque ligne correspond à une observation distincte.

##### Description des variables

Certaines colonnes vous seront utiles. Voici une description de celles-ci :

-   `observed_scientific_name` Nom scientifique de l'espèce observée
-   `year_obs` Année de l'observation
-   `day_obs` Jour de l'observation
-   `time_obs` Heure de l'observation
-   `dwc_event_date` Date de l'observation
-   `obs_variable` Variable observée
-   `obs_unit` Unité de mesure
-   `obs_value` Valeur observée
-   `lat` Latitude de l'observation
-   `lon` Longitude de l'observation
-   `original_source` Source originale des données
-   `creator` Auteur des données
-   `title` Titre du jeu de données dont les données sont extraites
-   `publisher` Éditeur des données
-   `intellectual_rights` Droits intellectuels
-   `license` Licence des données
-   `owner` Propriétaire des données

#### Considérations importantes

##### Validation

Les données représentent ce qui peut être attendu d'une extraction de sources différentes. Il est possible qu'il y ait des erreurs dans les données ou que le format d'un champ aie changé en cours de collecte. Il est important de valider les données avant de les utiliser. Par exemple, certaines colonnes peuvent ne pas se combiner si elles ne sont pas du même type (ex. une colonne de texte ne peut pas se combiner avec une colonne de nombre).

### 2.4 scripts

Dossier contenant les scripts utilisée. Ils ont été séparés selon les fonctions qu'ils contiennent.

-   `1_fonction_BD.R` fonction pour la lecture et l'importation des données brutes sous forme d'un tableau de données
-   3 à 7 sont des scripts pour nettoyer et uniformiser les données brutes
-   7 à 9 osont des scripts utiles au traitement des noms scientifiques avec le système de classification des nom ITIS
-   `10_fonction_csv_lepido_finale.R`le tableau final est enregistré en format *.csv* dans le dossier *Projet_final/tableaux_csv/lepido_final.csv*
-   `11_fonction_creation_donnees.R` permet de séparer les données du talbeau pincipal pour les insérer dans les tables SQL
-   `18_Assemblage_et_nettoyage_des_donnees.R` script qui regroupe toutes les fonctions précédentes pour traiter les données en un seul clic
-   `19_Creation_des_tables_SQL.R` permet de créer la base de données SQL et d'y insérer les donnée. Permet également le traitement de nos requêtes pour répondre à la question de recherche
-   20 à 22 permettent de créer des figures qui complètent notre analyse à insérer dans notre rapport
-   `Rapport_lepidopteres` dossier qui contient les scripts et les objets permettant de créer notre article avec Rmarkdown. Notre y est d'ailleurs disponible en pdf *Rapport_lepidopteres.pdf*

### 2.5 tableaux_csv

Dossier contenant les fichiers csv que nous avons créé contenant des données traitées. De nouveaux tableaux s'y enregistreront lors de l'exécution du target.

-   `taxonomie.csv` correspondance entre les noms scientifiques observés et la taxonomie validée, les noms communs et la taxonomique complète des espèces. Le lient entre les données de population et la taxonomie se fait à l'aide de la colonne `observed_scientific_name`.
