# HeavyBall: Polyak's Heavy Ball Optimization Method in R

**HeavyBall** is an academic and engineering R package implementing **Polyak's Heavy Ball (Momentum) optimization method** for minimizing smooth quadratic cost functions. The package is demonstrated on real-world industrial sensor data from a **Combined Cycle Power Plant** to evaluate convergence speed and stability across different momentum regimes.

---

## Repository Structure

```text
HeavyBall/
├── R/
│   ├── boule_pesante.R        # Core Heavy Ball gradient descent implementation
│   └── data.R                 # Roxygen2 documentation for power_plant_data
├── data/
│   └── power_plant_data.rda   # Cleaned industrial sensor dataset (47,840 observations)
├── man/
│   ├── boule_pesante.Rd       # Generated English help file for boule_pesante()
│   └── power_plant_data.Rd    # Generated English help file for power_plant_data
├── Application.R              # Standalone sensitivity benchmark & visualization script
├── Installation des données_2.R # Raw CSV cleaning and package data creation script
├── DESCRIPTION                # Package metadata and dependencies
├── NAMESPACE                  # Exported package functions
└── README.md                  # Project and application documentation
```

---

## Installation & Package Loading

You can install or load the package locally in RStudio using `devtools`:

```r
# Install from GitHub
devtools::install_github("davidharold709-code/Heavyball")

# Or load locally from the project root directory
devtools::load_all()
```

Once loaded, you can access the built-in English documentation directly in R:

```r
?boule_pesante
?power_plant_data
```

---

## Dataset: `power_plant_data`

The package includes `power_plant_data`, derived from the **Combined Cycle Power Plant (CCPP)** industrial dataset (47,840 cleaned observations):

* **`temperature_AT`** (Predictor $X$): Ambient temperature measured in degrees Celsius ($^\circ\text{C}$).
* **`puissance_PE`** (Target $Y$): Net hourly electrical energy output in Megawatts ($\text{MW}$).

Both variables are standardized (`scale()`) prior to optimization so that gradient updates remain well-conditioned.

---

## Core Optimization Function: `boule_pesante()`

The function `boule_pesante(x, y, alpha = 0.08, beta = 0.85, n_iter = 40)` updates the velocity $v_k$ and parameter $\theta_k$ at each iteration $k$:

$$v_{k+1} = \beta v_k - \alpha \nabla J(\theta_k)$$

$$\theta_{k+1} = \theta_k + v_{k+1}$$

### Parameters
* `x`: Numeric vector of standardized predictor values (`temperature_AT`).
* `y`: Numeric vector of standardized target values (`puissance_PE`).
* `alpha`: Fixed learning rate / step size (default: `0.08`).
* `beta`: Momentum / inertia coefficient $\beta \in [0, 1)$ (default: `0.85`).
* `n_iter`: Number of optimization iterations (default: `40`).

---

## Application Script Documentation (`Application.R`)

The standalone script `Application.R` (located at the project root) runs a sensitivity and convergence benchmark comparing standard gradient descent against Polyak's Heavy Ball method without modifying core package functions.

### 1. Prerequisites
Ensure the following R packages are installed before running the script:
* `HeavyBall` (loaded via `devtools::load_all()` or `library(HeavyBall)`)
* `ggplot2` (data visualization)
* `dplyr` (data manipulation and summary tables)
* `gganimate` and `gifski` (animated convergence rendering)

### 2. How to Run `Application.R`
1. Open the `HeavyBall.Rproj` project in RStudio.
2. Load the package cleanly in the R console:
   ```r
   devtools::load_all()
   ```
3. Open `Application.R` (kept outside the `R/` folder) and click **Source**, or run:
   ```r
   source("Application.R")
   ```

### 3. Experimental Setup & Tested $\beta$ Values
With a fixed learning rate $\alpha = 0.08$ over $30$ iterations (`n_iter = 30`), `Application.R` evaluates five inertia configurations:

| Configuration | Momentum ($\beta$) | Optimization Behavior |
| :--- | :---: | :--- |
| **Standard Gradient Descent** | `0.00` | Slow, monotonic convergence without inertia |
| **Low Momentum** | `0.40` | Moderate acceleration over standard gradient descent |
| **Moderate Momentum** | `0.70` | Faster convergence with smooth trajectory |
| **Optimal Heavy Ball** | `0.85` | **Best trade-off**: rapid convergence (~5 iterations) with high stability |
| **High Inertia Regime** | `0.92` | Initial overshooting and oscillations before damping |

### 4. Generated Outputs
Executing `Application.R` automatically produces two visual files in the working directory and prints a ranked MSE convergence summary in the console:

1. **`heavyball_sensibilite_beta.gif`**: An animated convergence trajectory (`900 x 600 px`, `15 fps`) illustrating iteration-by-iteration MSE reduction across all $\beta$ values.
2. **`heavyball_sensibilite_beta.png`**: A high-resolution static plot (`200 dpi`) suitable for engineering reports and presentation slides.

---

## Author

* **Harold David Noubong Tcheuo** — Package development, sensitivity analysis, and engineering modeling (`davidharold709@gmail.com`).