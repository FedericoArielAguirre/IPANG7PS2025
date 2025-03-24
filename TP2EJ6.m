% Ejercicio 6-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definimos los puntos x
x = 0:0.1:30; % Desde 0 a 30 con incremento de 0.1

% Inicializamos el vector de la función f(x)
f = zeros(size(x));

% Definimos cada parte de la función según las pendientes y curvas

% Pendiente 1: f(x) = 0.5*x + 3 desde x = 0 a 5
f(x >= 0 & x < 5) = 0.5 * x(x >= 0 & x < 5) + 3;

% Curva 1: f(x) = 0.1*(x - 5) + 4 desde x = 5 a 15
f(x >= 5 & x < 15) = (0.1 * (x(x >= 5 & x < 15) - 5)) + 4;

% Pendiente 2: f(x) = -2/3*(x - 15) + f(15) desde x = 15 a 20
f(x >= 15 & x < 20) = -(2/3) * (x(x >= 15 & x < 20) - 15) + f(15);

% Curva 2: f(x) se define gradualmente desde x = 20 a 25
f(x >= 20 & x < 25) = -0.2*(x(x >= 20 & x < 25) - 20) + f(20);

% Pendiente 3: f(x) = -1/3*(x - 25) + f(25) desde x = 25 a 30
f(x >= 25 & x <= 30) = -(1/3) * (x(x >= 25 & x <= 30) - 25) + f(25);

% Graficar la función
figure;
plot(x, f, 'LineWidth', 2);
xlabel('x');
ylabel('f(x)');
title('Gráfica de la función f(x)');
grid on;

% Añadir etiquetas para los segmentos
text(2, 5.5, 'Pendiente 1', 'FontSize', 10);
text(10, 5.5, 'Curva 1', 'FontSize', 10);
text(15.5, 4, 'Pendiente 2', 'FontSize', 10);
text(22, 3, 'Curva 2', 'FontSize', 10);
text(27, 2, 'Pendiente 3', 'FontSize', 10);
 
% Datos de la tabla
% [ \begin{array}{c|ccc} v , \text{[m}^3/\text{kg]} & 0.10377 & 0.11144 & 0.1254 \ \hline s , \text{[kJ/kg} \cdot \text{K]} & 6.4147 & 6.5453 & 6.7664 \end{array} ]
% 
% Parte a: Interpolación lineal
% Valores para la interpolación
% 
% (v_1 = 0.10377 , \text{m}^3/\text{kg}), (s_1 = 6.4147 , \text{kJ/kg} \cdot \text{K})
% (v_2 = 0.11144 , \text{m}^3/\text{kg}), (s_2 = 6.5453 , \text{kJ/kg} \cdot \text{K})
% (v = 0.108 , \text{m}^3/\text{kg})
% Interpolación lineal [ s = s_1 + \frac{(s_2 - s_1)}{(v_2 - v_1)} \cdot (v - v_1) ]
% 
% Cálculo
% 
% Diferencia de entropía: (s_2 - s_1 = 6.5453 - 6.4147 = 0.1306)
% Diferencia de volumen: (v_2 - v_1 = 0.11144 - 0.10377 = 0.00767)
% Sustituyendo: [ s = 6.4147 + \frac{0.1306}{0.00767} \cdot (0.108 - 0.10377) ]
% (s = 6.4147 + 17.0203 \cdot 0.00423)
% (s \approx 6.4147 + 0.0719 \approx 6.4866 , \text{kJ/kg} \cdot \text{K})
% Parte b: Interpolación cuadrática
% Valores para la interpolación cuadrática Utilizando los tres puntos de la tabla:
% 
% (x_0 = 0.10377, , y_0 = 6.4147)
% (x_1 = 0.11144, , y_1 = 6.5453)
% (x_2 = 0.1254, , y_2 = 6.7664)
% Interpolación cuadrática [ s = \frac{(v - x_1)(v - x_2)}{(x_0 - x_1)(x_0 - x_2)}y_0 + \frac{(v - x_0)(v - x_2)}{(x_1 - x_0)(x_1 - x_2)}y_1 + \frac{(v - x_0)(v - x_1)}{(x_2 - x_0)(x_2 - x_1)}y_2 ]
% 
% Cálculo [ s = \frac{(0.108 - 0.11144)(0.108 - 0.1254)}{(0.10377 - 0.11144)(0.10377 - 0.1254)} \times 6.4147 + \frac{(0.108 - 0.10377)(0.108 - 0.1254)}{(0.11144 - 0.10377)(0.11144 - 0.1254)} \times 6.5453 + \frac{(0.108 - 0.10377)(0.108 - 0.11144)}{(0.1254 - 0.10377)(0.1254 - 0.11144)} \times 6.7664 ]
% 
% Realizando los cálculos, se obtiene: [ s \approx 6.4870 , \text{kJ/kg} \cdot \text{K} ]
% Parte c: Encontrar el volumen correspondiente a una entropía de 6.6
% Interpolación lineal entre los puntos más cercanos Usamos (s_1 = 6.5453) y (s_2 = 6.7664) (valores de (v_2) y (v_3)):
% 
% (v_1 = 0.11144, , s_1 = 6.5453)
% (v_2 = 0.1254, , s_2 = 6.7664)
% Se busca (v) cuando (s = 6.6)
% Interpolación lineal [ v = v_1 + \frac{(v_2 - v_1)}{(s_2 - s_1)} \cdot (s - s_1) ]
% 
% Cálculo: [ v = 0.11144 + \frac{(0.1254 - 0.11144)}{(6.7664 - 6.5453)} \cdot (6.6 - 6.5453) ]
% (v = 0.11144 + \frac{0.01396}{0.2211} \cdot 0.0547)
% (v \approx 0.11144 + 0.002772 \approx 0.1142 , \text{m}^3/\text{kg})
% Resumen de Resultados
% Entropía con interpolación lineal (a): (6.4866 , \text{kJ/kg} \cdot \text{K})
% Entropía con interpolación cuadrática (b): (6.4870 , \text{kJ/kg} \cdot \text{K})
% Volumen para (s = 6.6) (c): (0.1142 , \text{m}^3/\text{kg})