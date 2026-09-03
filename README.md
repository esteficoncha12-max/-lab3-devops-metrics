# Análisis de Métricas de Software y DevOps

Proyecto integrador de Probabilidad y Estadística Computacional. Analiza un
dataset simulado de ~5.000 eventos de integración/despliegue (`devops_metrics.csv`)
mediante estadística descriptiva en R.

## Estructura del repositorio

```
.
├── reporte.Rmd            # Análisis completo (Fases 1-6) + reporte reproducible (Fase 7)
├── reporte.html            # Reporte exportado (generado con Knit)
├── devops_metrics.csv       # Dataset (se genera al correr la Fase 1 del .Rmd)
├── bitacora_prompts.md      # Registro de prompts usados con IA generativa
└── README.md
```

## Requisitos

- R (≥ 4.2) y RStudio
- Paquetes:
  ```r
  install.packages(c("tidyverse", "moments", "rmarkdown", "knitr"))
  ```

## Cómo ejecutar

1. Clonar este repositorio.
2. Abrir `reporte.Rmd` en RStudio.
3. Hacer clic en **Knit** (o ejecutar `rmarkdown::render("reporte.Rmd")` en la consola).
4. El archivo `reporte.html` se genera automáticamente con todas las tablas,
   estadísticas y gráficos.

No se requiere ningún paso manual adicional: el dataset se genera y se guarda
como parte del primer chunk del `.Rmd`.

## Contenido del análisis

- **Fase 1:** carga, inspección y limpieza de datos.
- **Fase 2:** estadística descriptiva univariada (tendencia central, dispersión, forma).
- **Fase 3:** tabla de frecuencias con la regla de Sturges y clase modal.
- **Fase 4:** comparación de métricas por equipo de desarrollo.
- **Fase 5:** correlaciones y tablas de contingencia.
- **Fase 6:** visualización (histograma, boxplot, gráfico de barras, dispersión).
- **Fase 7:** reporte reproducible integrado en R Markdown.

## Autor

Estefania
