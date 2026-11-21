#' @title Data Preparation Script for Combined Cycle Power Plant Dataset
#' @description
#' Reads the raw `power_plant.csv` file, removes duplicated header rows (`AT`),
#' converts ambient temperature (`AT`) and net electrical power output (`PE`)
#' into numeric columns (`temperature_AT` and `puissance_PE`), and saves the
#' cleaned dataset into `data/power_plant_data.rda` using `usethis::use_data()`.
#'
#' @details
#' - Input file: `power_plant.csv` (expected in the working directory or project path).
#' - Output object: `power_plant_data` stored in `data/power_plant_data.rda`.
#' - Usage: Run manually before building or loading the package when updating raw data.
#'   Do not place standalone execution scripts inside the `R/` directory.
#'
#' @author Harold David Noubong Tcheuo
#' @note This script is a data-preparation workflow script rather than a package function.

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
