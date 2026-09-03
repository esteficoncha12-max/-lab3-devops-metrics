# Bitácora de Prompts — Proyecto DevOps Metrics

> La diapositiva 3 del enunciado indica: *"Sin bitácora de prompts el proyecto se considera incompleto"*.
> Registro de prompts usados con IA generativa durante el desarrollo del proyecto: qué pedí, qué me devolvió, qué falló y cómo lo verifiqué.

---

## Fase 0 — Configuración inicial (Git y bitácora)

**Prompt v1:**
`Explícame cómo hacer la Fase 0, no entiendo cómo se hace ni dónde se hace`

**Resultado obtenido:** la IA me guió paso a paso hasta integrar Git en el proyecto desde RStudio, y confirmó la Fase 0 como completada una vez que Git quedó activo.

**Prompt v2:**
`Okey, necesito un intensivo que contenga absolutamente todo lo que está en la presentación que te mandé. Sepáralo por fases y dime cuánto tiempo debería demorarme en cada cosa.`

**Resultado obtenido:** un plan fase por fase con tiempos estimados, y como primer paso me indicó crear el archivo `bitacora_prompts.md` con una plantilla base (Prompt Versión 1, 2, 3).

**Verificación:** confirmé en el panel Git de RStudio que el proyecto ya tenía Git integrado, y creé `bitacora_prompts.md` en la carpeta del proyecto siguiendo esas instrucciones.

---

## Fase 1 — Carga y limpieza

**Prompt v1:**
`Dame absolutamente todo lo que tengo que hacer, compila todo lo que está en el chat, dame todas las fases que debo hacer y todos los códigos que tengo que pegar`

**Resultado obtenido:** un script completo (`analisis_devops.R`) con la carga y limpieza de datos, para pegar y ejecutar en RStudio.

**Problema / qué corregiste:** al ejecutarlo salió el error `Error en library(tidyverse): no hay paquete llamado 'tidyverse'`, dos veces seguidas, porque las librerías (`tidyverse`, `moments`, `rmarkdown`, `knitr`) no estaban instaladas en esa sesión de R.

**Prompt v2:**
`Pero debes decirme dónde pongo cada cosa, cómo lo hago; dame los paquetes que debo instalar y dónde y cómo hacerlo`

**Verificación:** ejecuté `install.packages(c("tidyverse", "moments", "rmarkdown", "knitr"))` directamente en la Consola, volví a correr el script y confirmé, con captura de pantalla, que `df` se cargó con 5.000 observaciones y 10 variables, sin errores.

---

## Fase 2 y 3 — Estadística univariada y frecuencias (Sturges)

**Prompt v1:** código entregado por la IA como continuación directa del mismo script, sin un prompt nuevo — solo pegué y ejecuté.

**Verificación:** capturas de pantalla confirmando `resumen_univariado` (media 14.9, mediana 15.0, desviación estándar 4.02, CV 0.269, IQR 5.38, asimetría -0.0177, curtosis 3.01) y `tabla_frecuencias` con 14 clases (`k_clases = 14`), generadas sin errores en consola.

---

## Fase 4 — Análisis por grupos

**Prompt v1:** código entregado como continuación del mismo script.

**Verificación:** captura de pantalla confirmando `analisis_equipos` (Build_Mediano, Bugs_Promedio y Tasa_Fallos por cada uno de los 4 equipos) y `tabla_cruzada` (team × deploy_status) generadas correctamente.

---

## Fase 5 — Relaciones bivariadas

**Prompt v1:** código entregado como continuación del mismo script.

**Verificación:** captura de pantalla confirmando `matriz_corr`, el resultado de `cor.test(df$commit_size_loc, df$num_bugs)` (p-value = 0.4523, sin correlación significativa) y `proporciones_contingencia` por prioridad, todo generado sin errores.

---

## Fase 6 — Visualización

**Prompt v1:** código entregado como continuación del mismo script.

**Verificación:** captura de pantalla confirmando que `g_hist` y `g_box` se generaron correctamente, con el boxplot "Resolución de Tickets por Equipo de Trabajo" visible en el panel Plots de RStudio.

---

## Fase 7 — Reporte reproducible (.Rmd)

**Prompt v1:**
`Dime en qué está fallando`

**Problema:** el `reporte.html` salía prácticamente en blanco — solo se veían el título, el autor y la fecha del YAML, sin ninguna tabla ni gráfico, aunque la consola no mostraba ningún error de R.

**Prompt v2:**
`Esto es todo lo que tengo, ¿puedes decirme por qué falla cuando quiero hacer el HTML? ¿Por qué me sale todo en blanco?`

**Verificación:** el código estaba pegado como texto plano fuera de los bloques ```` ```{r} ... ``` ````, así que R Markdown no lo ejecutaba, y además tenía contenido duplicado. Al reorganizarlo en un chunk por fase y darle Knit, el `reporte.html` se generó al 100% con todas las tablas y los 4 gráficos visibles.

---

## Configuración de Git y GitHub

**Prompt v1:** `No sé nada de Git`

**Prompt v2:** `Pero, o sea, lo instalé, pero no sé qué hay que hacer con eso ni cómo se hace`

**Problemas encontrados:**
- No aparecía el diálogo esperado para activar Git en el proyecto — la ruta correcta era `Tools → Project Options → Git/SVN`, no el menú "Version Control" que probé primero.
- El botón Push del panel Git no se dejaba usar → se resolvió con `git push -u origin main` desde la Terminal.
- Ese primer push falló con `error: src refspec main does not match any` → el commit nunca se había completado.
- Al intentar el commit salió `Author identity unknown` → Git no tenía configurado mi nombre y correo.
- Al escribir `git config` con comillas, la terminal quedó "colgada" (el prompt cambió de `$` a `>`) → se resolvió con Ctrl+C y reescribiendo los comandos sin comillas.

**Verificación:** la terminal mostró `[new branch] main -> main` y `branch 'main' set up to track 'origin/main'`; confirmé entrando a `github.com/esteficoncha12-max/lab3-devops-metrics` que todos mis archivos ya estaban subidos.

---

## Reflexión final

**¿Qué aprendiste sobre usar IA como asistente y no como reemplazo?**

Debido a la carga académica de esta semana, utilicé la IA como asistente en distintos ramos, logrando encontrar en ella más un apoyo que un segundo cerebro. Al lograr que la IA hiciera lo que le pedía sin la necesidad de tomar decisiones por mí, y manteniendo yo el control, descubrí la facilidad que esto proporciona sin necesidad de utilizarla para que hiciera todo por mí. Me ayudó mucho a la hora de resolver problemas que no lograba comprender por mí misma, así como también me enseñó a hacer cosas que antes no entendía.

**¿Qué tuviste que verificar siempre por tu cuenta?**

Al no saber del lenguaje R, no comprendía muy bien el código, así que le pedí a la IA que me explicara bloque por bloque lo que significaba. Debido a eso, la IA también analizaba los códigos que me enviaba, por lo que los errores no eran tan frecuentes. Pero algo que verificaba constantemente era que la IA me diera los mejores resultados, enviándole capturas y pidiéndole que me dijera el porqué de las fallas.
