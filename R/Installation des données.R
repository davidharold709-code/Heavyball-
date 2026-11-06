# 1. Charger le fichier brut
donnees_brutes <- read.csv("power_plant.csv")

# 2. Filtrer pour supprimer les lignes où l'en-tête se répète par erreur
donnees_filtrees <- donnees_brutes[donnees_brutes$AT != "AT", ]

# 3. Convertir en numérique en toute sérénité
power_plant_data <- data.frame(
  temperature_AT = as.numeric(donnees_filtrees$AT),
  puissance_PE   = as.numeric(donnees_filtrees$PE)
)

# 4. Sauvegarder dans le package
usethis::use_data(power_plant_data, overwrite = TRUE)
