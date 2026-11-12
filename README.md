# Sistema experto de potabilidad de agua

Sistema experto desarrollado en Prolog para clasificar una muestra de agua como
**potable** o **no potable** a partir de cuatro parámetros fisicoquímicos:
`Hardness`, `Solids`, `Sulfate` y `Organic_carbon`.

El proyecto corresponde a un trabajo práctico de **Paradigmas y Lenguajes de
Programación** y documenta la aplicación de la metodología **CRISP-DM**:
comprensión del problema y de los datos, preparación, modelado, evaluación y
despliegue de las reglas en una base de conocimiento declarativa.


## Objetivo

Evaluar rápidamente una combinación de mediciones de calidad del agua y
mostrar una clasificación binaria:

- **POTABLE:** apta para consumo según las reglas implementadas.
- **NO ES POTABLE:** no cumple ninguna de las reglas de potabilidad.

## Datos y proceso CRISP-DM

El análisis se basó en el dataset público **Water Quality**, disponible en
Kaggle: [Water Quality and Potability](https://www.kaggle.com/datasets/adityakadiwal/water-potability?resource=download).
El conjunto contiene 3.276 muestras y 10 variables: nueve atributos de entrada
y la variable objetivo `Potability` (`1` = potable, `0` = no potable).

El flujo documentado en el informe fue:

1. **Comprensión del problema:** automatizar una clasificación inicial de
   potabilidad a partir de parámetros fisicoquímicos.
2. **Comprensión de los datos:** revisión de las variables del dataset y de sus
   unidades.
3. **Preparación:** asignación de `Potability` como etiqueta, conversión a una
   variable binaria y división estratificada en entrenamiento (70 %) y prueba
   (30 %, 982 muestras).
4. **Modelado:** entrenamiento de un árbol de decisión con `Gain Ratio`,
   profundidad máxima 10 y poda activada.
5. **Evaluación:** el modelo obtuvo una exactitud de referencia de **61,61 %**
   sobre el conjunto de prueba. Sus reglas se tradujeron manualmente a Prolog.
6. **Despliegue:** implementación de las reglas en `potabilidad.pl` mediante el
   predicado `es_potable/4` y una interfaz interactiva por consola.

## Variables utilizadas

| Variable | Descripción | Unidad |
| --- | --- | --- |
| `Hardness` | Dureza del agua, asociada principalmente a sales de calcio y magnesio | mg/L |
| `Solids` | Sólidos disueltos totales (TDS) | ppm |
| `Sulfate` | Concentración de sulfatos | mg/L |
| `Organic_carbon` | Carbono contenido en compuestos orgánicos | ppm |

Aunque el dataset original contiene otras variables (`ph`, `Chloramines`,
`Conductivity`, `Trihalomethanes` y `Turbidity`), el árbol seleccionado
priorizó estos cuatro atributos y son los únicos utilizados por el programa.

## Requisitos

- [SWI-Prolog](https://www.swi-prolog.org/) con el comando `swipl`.
- Una terminal para interactuar con el programa.

No se requieren frameworks ni dependencias adicionales.

## Ejecución

Desde la carpeta del proyecto, iniciar SWI-Prolog:

```text
swipl potabilidad.pl
```

En el intérprete, ejecutar:

```prolog
?- iniciar.
```

El programa solicitará los cuatro valores. Cada entrada debe terminar con un
punto (`.`), porque `read/1` utiliza la sintaxis de términos de Prolog.

Ejemplo:

```text
1. Ingrese la Dureza del agua (Hardness en mg/L): 80.0.
2. Ingrese Solidos disueltos totales (Solids en ppm): 2000.0.
3. Ingrese nivel de Sulfatos (Sulfate en mg/L): 250.0.
4. Ingrese Carbono Organico (Organic_carbon en ppm): 10.0.

RESULTADO: El agua es POTABLE (Apta para consumo).
```

Para salir:

```prolog
?- halt.
```

## Consulta directa

También se puede consultar la base de conocimiento sin utilizar la interfaz:

```prolog
?- evaluar(80.0, 2000.0, 250.0, 10.0).
RESULTADO: El agua es POTABLE (Apta para consumo).

?- evaluar(200.0, 5000.0, 300.0, 12.0).
RESULTADO: El agua NO ES POTABLE (Riesgo sanitario).
```

El predicado principal de inferencia es:

```prolog
es_potable(+Hardness, +Solids, +Sulfate, +Organic_carbon).
```

Devuelve éxito cuando los valores satisfacen alguna de las reglas de
potabilidad. El predicado `evaluar/4` agrega el mensaje de salida y utiliza un
corte (`!`) para evitar que Prolog retroceda hacia la cláusula por defecto
después de encontrar una clasificación positiva.

## Reglas implementadas

Una muestra se clasifica como potable si cumple al menos una de estas
condiciones:

1. `Hardness > 306.245`.
2. `97.867 < Hardness =< 306.245` y `Solids =< 1952.435`.
3. `97.867 < Hardness =< 306.245`, `Solids > 1952.435` y
   `Sulfate =< 196.553`.
4. `97.867 < Hardness =< 306.245`, `Solids > 1952.435`,
   `Sulfate > 196.553` y `5.189 < Organic_carbon =< 5.339`.
5. `97.867 < Hardness =< 306.245`, `Solids > 1952.435`,
   `Sulfate > 196.553`, `5.339 < Organic_carbon =< 23.636` y
   `Organic_carbon > 23.542`.
6. `Hardness =< 97.867`.

Los valores que no cumplen ninguna de las seis reglas se clasifican como no
potables. Los umbrales son los obtenidos del árbol de decisión del informe y no
deben interpretarse como límites regulatorios universales.

## Estructura del proyecto

```text
.
├── potabilidad.pl   # Interfaz, predicados de evaluación y reglas expertas
└── README.md        # Documentación del proyecto
```

## Validación informada en el proyecto

Se verificaron, entre otros, los siguientes casos:

| Entrada `(Hardness, Solids, Sulfate, Organic_carbon)` | Resultado |
| --- | --- |
| `(80.0, 2000.0, 250.0, 10.0)` | Potable, por la regla de dureza baja |
| `(200.0, 5000.0, 300.0, 12.0)` | No potable, al no satisfacer ninguna regla |

## Integrantes
- Caruk, María
- Donda, Melisa
- Pedernera Theisen Nahuel Thomas
- Pergher, Lucas Maurice


