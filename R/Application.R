# PROJET R : HeavyBall - Analyse de Sensibilité et Performance Algorithmique
# Application : Combined Cycle Power Plant Dataset (Génie Énergétique)


library(devtools)
load_all(".") # Charge le package local HeavyBall

pkgs <- c("ggplot2", "dplyr", "gganimate", "gifski")
for (p in pkgs) if (!require(p, character.only = TRUE)) install.packages(p)
library(ggplot2)
library(dplyr)
library(gganimate)


# 1. Chargement et Préparation Rigoureuse des Données Industrielles

data("power_plant_data")

# Filtrage des lignes d'en-têtes parasites répétées dans le CSV
donnees_filtrees <- power_plant_data[power_plant_data$temperature_AT != "AT", ]

# Conversion explicite en numérique et centrage-réduction (scale)
x <- scale(as.numeric(donnees_filtrees$temperature_AT)) # Entrée X : Température (°C)
y <- scale(as.numeric(donnees_filtrees$puissance_PE))   # Cible Y  : Puissance (MW)
N <- length(y)

cat("DATASET CHARGÉ AVEC SUCCÈS \n")
cat("Nombre d'observations industrielles nettoyées :", N, "\n\n")


# 2. Benchmark de Sensibilité : Variation de l'Inertie Beta (β)

n_iter <- 30
alpha_fixe <- 0.08
valeurs_beta <- c(0.00, 0.40, 0.70, 0.85, 0.92) # β = 0.00 équivaut au Gradient Classique

resultats_liste <- list()

for (b in valeurs_beta) {
  res <- HeavyBall::boule_pesante(x, y, alpha = alpha_fixe, beta = b, n_iter = n_iter)

  nom_config <- if (b == 0) "β = 0.00 (Gradient Classique)" else paste0("β = ", sprintf("%.2f", b), " (Boule Pesante)")

  df_temp <- data.frame(
    Iteration = 1:n_iter,
    Cout_MSE  = res$historique,
    Config    = nom_config,
    Beta      = b
  )
  resultats_liste[[as.character(b)]] <- df_temp
}

df_sensibilite <- bind_rows(resultats_liste)


# 3. Visualisation : style original, avec une animation simple
#    (les courbes se dessinent au fil des itérations, un point marque la position)

couleurs <- c(
  "β = 0.00 (Gradient Classique)" = "red",  # Rouge
  "β = 0.40 (Boule Pesante)"      = "orange",  # Orange
  "β = 0.70 (Boule Pesante)"      = "green",  # Vert
  "β = 0.85 (Boule Pesante)"      = "blue",  # Bleu Nuit (Optimal)
  "β = 0.92 (Boule Pesante)"      = "purple"   # Violet (Sur-oscillation)
)

p_anim <- ggplot(df_sensibilite,
                 aes(x = Iteration, y = Cout_MSE, color = Config, group = Config)) +
  geom_line(aes(linewidth = (Config == "β = 0.85 (Boule Pesante)")), alpha = 0.95) +
  geom_point(size = 3.5) +                       # un seul point par courbe : la position actuelle
  scale_linewidth_manual(values = c("TRUE" = 1.5, "FALSE" = 0.9), guide = "none") +
  scale_color_manual(values = couleurs) +
  scale_x_continuous(breaks = seq(0, n_iter, 5)) +
  guides(color = guide_legend(nrow = 2, byrow = TRUE)) +
  theme_minimal(base_size = 13) +
  labs(
    title    = "Analyse de Sensibilité : Effet du Momentum (β) sur la Boule Pesante",
    subtitle = paste0("Optimisation sur ", format(N, big.mark = " "),
                      " mesures (α = ", alpha_fixe, ")  |  Itération {as.integer(frame_along)} / ", n_iter),
    x        = "Nombre d'itérations (k)",
    y        = "Fonction de Coût (MSE)",
    color    = NULL
  ) +
  theme(
    plot.title       = element_text(face = "bold", size = 15, color = "darkblue"),
    plot.subtitle    = element_text(size = 11, color = "darkgreen"),
    legend.position  = "bottom",
    legend.text      = element_text(size = 10),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "lightgray"),
    axis.title       = element_text(face = "bold")
  ) +
  transition_reveal(Iteration)


# 3 images par itération => le tracé va exactement jusqu'à k = 30, puis pause finale
fichier_gif <- "heavyball_sensibilite_beta.gif"
cat("Rendu de l'animation en cours (quelques secondes)...\n")

anim <- animate(
  p_anim,
  nframes   = (n_iter - 1) * 3,        # 87 images : progression régulière
  fps       = 15,
  width     = 900, height = 600, res = 100,
  end_pause = 25,                      # pause finale pour lire le résultat
  renderer  = gifski_renderer(file = fichier_gif, loop = TRUE)
)

cat("Animation terminée :", normalizePath(fichier_gif), "\n")


utils::browseURL(normalizePath(fichier_gif))

# Image fixe du résultat final (pour le rapport)
p_statique <- ggplot(df_sensibilite,
                     aes(x = Iteration, y = Cout_MSE, color = Config, group = Config)) +
  geom_line(aes(linewidth = (Config == "β = 0.85 (Boule Pesante)")), alpha = 0.95) +
  geom_point(size = 2) +
  scale_linewidth_manual(values = c("TRUE" = 1.5, "FALSE" = 0.9), guide = "none") +
  scale_color_manual(values = couleurs) +
  scale_x_continuous(breaks = seq(0, n_iter, 5)) +
  guides(color = guide_legend(nrow = 2, byrow = TRUE)) +
  theme_minimal(base_size = 13) +
  labs(
    title    = "Analyse de Sensibilité : Effet du Momentum (β) sur la Boule Pesante",
    subtitle = paste0("Optimisation sur ", format(N, big.mark = " "),
                      " mesures (α = ", alpha_fixe, ")"),
    x = "Nombre d'itérations (k)", y = "Fonction de Coût (MSE)", color = NULL
  ) +
  theme(
    plot.title       = element_text(face = "bold", size = 15, color = "darkblue"),
    plot.subtitle    = element_text(size = 11, color = "darkgreen"),
    legend.position  = "bottom",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "lightgrey"),
    axis.title       = element_text(face = "bold")
  )

ggsave("heavyball_sensibilite_beta.png", p_statique,
       width = 10, height = 6.5, dpi = 200, bg = "white")


# 4. Métriques Numériques d'Évaluation (Pour l'Analyse Data Science)

cat(" RÉSUMÉ DE CONVERGENCE APRÈS 30 ITÉRATIONS \n")
df_summary <- df_sensibilite %>%
  filter(Iteration == n_iter) %>%
  select(Config, Cout_MSE) %>%
  arrange(Cout_MSE)

print(df_summary)
