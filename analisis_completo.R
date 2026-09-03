library(tidyverse)
library(moments)

set.seed(42)
n <- 5000
df <- tibble(
  build_time_min = rnorm(n, mean = 15, sd = 4),
  deploy_time_min = rnorm(n, mean = 8, sd = 2),
  commit_size_loc = rpois(n, lambda = 350),
  num_bugs = rpois(n, lambda = 2),
  test_coverage_pct = runif(n, min = 50, max = 95),
  ticket_resolution_h = rexp(n, rate = 1/24),
  team = sample(c("Alpha", "Bravo", "Charlie", "Delta"), n, replace = TRUE),
  module = sample(c("auth", "api", "ui", "database"), n, replace = TRUE),
  priority = sample(c("baja", "media", "alta", "crítica"), n, replace = TRUE, prob = c(0.4, 0.3, 0.2, 0.1)),
  deploy_status = sample(c("success", "failed", "rolled_back"), n, replace = TRUE, prob = c(0.8, 0.15, 0.05))
)

write_csv(df, "devops_metrics.csv")
df <- read_csv("devops_metrics.csv")

glimpse(df)
summary(df)
print(colSums(is.na(df)))

df <- df %>% mutate(
  priority = factor(priority, levels = c("baja", "media", "alta", "crítica"), ordered = TRUE),
  team = as.factor(team),
  module = as.factor(module),
  deploy_status = as.factor(deploy_status)
)

# Estadística descriptiva y análisis
df %>% summarise(
  Media = mean(build_time_min),
  Mediana = median(build_time_min),
  Desv_Est = sd(build_time_min),
  CV = sd(build_time_min) / mean(build_time_min),
  IQR = IQR(build_time_min),
  Asimetria = skewness(build_time_min),
  Curtosis = kurtosis(build_time_min)
)

k_clases <- ceiling(1 + 3.322 * log10(nrow(df)))
df %>% mutate(clase = cut(build_time_min, breaks = k_clases)) %>% count(clase, name = "fa") %>% mutate(fr = fa / sum(fa), fac = cumsum(fa))

df %>% group_by(team) %>% summarise(Build_Mediano = median(build_time_min), Bugs_Promedio = mean(num_bugs), Tasa_Fallos = mean(deploy_status == "failed"))
table(df$team, df$deploy_status)

num_vars <- df %>% select(where(is.numeric))
cor(num_vars, use = "complete.obs") %>% round(2)
# =====================================================================
# FASE 2: Estadística Descriptiva Univariada
# =====================================================================

library(moments) # Asegura que la librería de asimetría esté activa

# Calculamos las métricas descriptivas para los tiempos de build
resumen_univariado <- df %>% summarise(
  Variable   = "build_time_min",
  Media      = mean(build_time_min),      # Promedio aritmético
  Mediana    = median(build_time_min),    # El valor que está justo al medio
  Desv_Est   = sd(build_time_min),        # Variabilidad estándar
  CV         = sd(build_time_min) / mean(build_time_min), # Coeficiente de variación (dispersión relativa)
  IQR        = IQR(build_time_min),       # Rango intercuartílico (evita valores atípicos)
  Asimetria  = skewness(build_time_min),  # Si la cola se inclina a la izquierda o derecha
  Curtosis   = kurtosis(build_time_min)   # Qué tan pronunciados son los picos
)

print(resumen_univariado)

# =====================================================================
# FASE 3: Frecuencias y Agrupación (Regla de Sturges)
# =====================================================================

# 1. Calculamos el número de clases óptimas con Sturges para n = 5000
n_filas <- nrow(df)
k_clases <- ceiling(1 + 3.322 * log10(n_filas))

# 2. Construimos la tabla de frecuencias para la variable 'build_time_min'
tabla_frecuencias <- df %>%
  mutate(clase = cut(build_time_min, breaks = k_clases)) %>%
  count(clase, name = "fa") %>% # fa = Frecuencia Absoluta (cuántos caen en el rango)
  mutate(
    fr  = fa / sum(fa),         # fr = Frecuencia Relativa (proporción)
    fac = cumsum(fa)            # fac = Frecuencia Acumulada
  )

print(tabla_frecuencias)

# =====================================================================
# FASE 4: Análisis Comparativo por Grupos
# =====================================================================

# 1. Resumen métrico agrupado por equipos (team)
analisis_equipos <- df %>% 
  group_by(team) %>% 
  summarise(
    Build_Mediano = median(build_time_min),
    Bugs_Promedio = mean(num_bugs),
    Tasa_Fallos   = mean(deploy_status == "failed")
  )

print(analisis_equipos)

# 2. Tabla cruzada de contingencia: Equipos vs Estado del Despliegue
tabla_cruzada <- table(df$team, df$deploy_status)
print(tabla_cruzada)

# =====================================================================
# FASE 5: Relaciones Bivariadas
# =====================================================================

# 1. Matriz de correlación para todas las variables numéricas
num_vars <- df %>% select(where(is.numeric))
matriz_corr <- cor(num_vars, use = "complete.obs") %>% round(2)
print("Matriz de Correlación:")
print(matriz_corr)

# 2. Prueba estadística de correlación específica (Tamaño de commit vs Cantidad de bugs)
print("Prueba de Correlación (Commit vs Bugs):")
print(cor.test(df$commit_size_loc, df$num_bugs))

# 3. Tabla de contingencia en proporciones por filas (Prioridad vs Estado de Despliegue)
proporciones_contingencia <- prop.table(table(df$priority, df$deploy_status), margin = 1) %>% round(2)
print("Proporciones de Despliegue según Prioridad:")
print(proporciones_contingencia)
# =====================================================================
# FASE 6: Visualización de Datos (ggplot2)
# =====================================================================

library(ggplot2)

# 1. Histograma para visualizar la distribución del tiempo de build
g_hist <- ggplot(df, aes(x = build_time_min)) +
  geom_histogram(bins = 20, fill = "#3b82f6", color = "white") +
  labs(
    title = "Distribución del Tiempo de Build",
    subtitle = "Análisis de frecuencias con 20 intervalos",
    x = "Tiempo de Build (minutos)",
    y = "Frecuencia"
  ) +
  theme_minimal()

print(g_hist)

# 2. Boxplot (Diagrama de caja) para comparar el tiempo de resolución de tickets por equipo
g_box <- ggplot(df, aes(x = team, y = ticket_resolution_h, fill = team)) +
  geom_boxplot() +
  labs(
    title = "Resolución de Tickets por Equipo de Trabajo",
    subtitle = "Comparación de mediana y dispersión",
    x = "Equipo de Desarrollo",
    y = "Tiempo de Resolución (horas)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(g_box)