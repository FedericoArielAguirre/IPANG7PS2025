% Ejercicio 3-TP1 
% Borramos las variables previas y la ventana de comandos
clc
clear
% a) Errores que Afectan la Posición Final de la Barra
% Errores de Medición:
% 
% Instrumentación: Los sensores que miden la posición 
% de las barras pueden tener un error de calibración o un rango de precisión limitado.
% Lectura Humana: Si la posición se determina manualmente
% la interpretación de la lectura puede introducir errores.
% 
% Errores de Control:
% 
% Desviaciones en el Sistema de Control: Los sistemas 
% automáticos que mueven las barras pueden tener errores
% en la respuesta debido a la dinámica del sistema, como 
% el retardo en la respuesta del actuador.
% Desgaste de Componentes: Con el tiempo, los mecanismos
% que controlan el movimiento de las barras pueden 
% desgastarse, lo que puede afectar su precisión.
% 
% Errores Ambientales:
% 
% Temperatura y Presión: Cambios en la temperatura
% y presión del entorno pueden afectar la expansión 
% o contracción de los materiales, alterando la posición de las barras.
% Vibraciones: Vibraciones en el entorno del reactor 
% pueden causar desplazamientos no deseados en las barras.
% 
% Errores de Modelado:
% 
% Suposiciones en el Modelo: Si el modelo que se 
% utiliza para calcular la posición final de las barras
% no considera todos los factores relevantes, puede haber
% discrepancias entre la posición calculada y la posición real.
%
% b) Cota del Error de las Variables Involucradas
% Para determinar la cota del error de las variables involucradas 
% para que la posición final quede determinada con un error 
% máximo de 1 mm, consideremos la fórmula que se utiliza
% para calcular la posición final de la barra:
% 
% [ \text{pos_barra} = \text{pos_inicial} + i \cdot \text{delta} ]
% 
% Donde:
% 
% (\text{pos_inicial}) es la posición inicial.
% (i) es el número de iteraciones (incrementos).
% (\text{delta}) es el paso de avance.
% Si queremos que el error en la posición final 
% sea como máximo 1 mm, debemos considerar cómo los
% errores en cada una de las variables afectan a la posición final.
% 
% Propagación del Error
% Supongamos que:
% 
% ( \Delta \text{pos_inicial} ) es el error en la posición inicial.
% ( \Delta i ) es el error en el número de iteraciones.
% ( \Delta \text{delta} ) es el error en el paso de avance.
% La propagación del error se puede aproximar como:
% 
% [ \Delta \text{pos_barra} = \sqrt{(\Delta \text{pos_inicial})^2 
% ...+ (i \cdot \Delta \text{delta})^2 + (\text{delta} \cdot \Delta i)^2} ]
% 
% Para que el error total sea menor o igual a 1 mm, 
% podemos establecer la siguiente relación:
% 
% [ \sqrt{(\Delta \text{pos_inicial})^2 + 
% (i \cdot \Delta \text{delta})^2 + 
% (\text{delta} \cdot \Delta i)^2} \leq 1 \text{ mm} ]
% 
% Cálculo de la Cota del Error
% Para simplificar, podemos asumir que los 
% errores son iguales y representarlos como ( \Delta ):
% 
% [ \sqrt{3 \cdot (\Delta)^2} \leq 1 \text{ mm} ]
% 
% De aquí, podemos despejar ( \Delta ):
% 
% [ \Delta \leq \frac{1 \text{ mm}}{\sqrt{3}} \approx 0.577 \text{ mm} ]
% 
% Esto significa que cada uno de los errores en 
% las variables involucradas (posición inicial,
% número de iteraciones y paso de avance) debe 
% ser menor o igual a aproximadamente 0.577 mm 
% para que la posición final de la barra esté 
% determinada con un error máximo de 1 mm.