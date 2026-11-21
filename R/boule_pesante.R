#' Polyak's Heavy Ball Optimization Method
#'
#' Optimizes a smooth objective function using classical momentum (Heavy Ball)
#' with fixed step size and momentum factor.
#'
#' @param x Numeric vector of scaled predictor values.
#' @param y Numeric vector of target values.
#' @param alpha Numeric learning rate (step size). Default is `0.08`.
#' @param beta Numeric momentum factor (inertia). Default is `0.85`.
#' @param n_iter Integer number of iterations. Default is `40`.
#'
#' @return A list containing the fitted parameter `theta` and the cost history
#'   `historique` across iterations.
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
