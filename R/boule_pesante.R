#' Algorithme de la Boule Pesante (Heavy Ball Method)
#'
#' @param x Vecteur de la variable explicative (normalisé)
#' @param y Vecteur de la variable cible
#' @param alpha Taux d'apprentissage (taille du pas)
#' @param beta Coefficient de frottement / inertie (momentum)
#' @param n_iter Nombre d'itérations
#' @return Une liste contenant le paramètre optimal theta et l'historique des coûts
#' @export
boule_pesante <- function(x, y, alpha = 0.08, beta = 0.85, n_iter = 40) {
  N <- length(y)
  theta <- 0      # Initialisation du paramètre
  v <- 0          # Vélocité initiale (momentum)
  historique_cout <- numeric(n_iter)

  for (i in 1:n_iter) {
    # 1. Calcul du gradient de l'erreur quadratique
    g <- sum((x * theta - y) * x) / N

    # 2. Mise à jour de la vélocité avec inertie
    v <- beta * v - alpha * g

    # 3. Mise à jour du paramètre theta
    theta <- theta + v

    # 4. Enregistrement du coût (MSE)
    historique_cout[i] <- sum((x * theta - y)^2) / (2 * N)
  }

  return(list(theta = theta, historique = historique_cout))
}
