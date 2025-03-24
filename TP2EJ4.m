% Ejercicio 4-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos de entrada
dias = [0, 6, 10, 13, 17, 20, 28]; % Días
peso_muestra1 = [6.67, 17.33, 42.67, 37.33, 30.10, 29.31, 28.74]; % Peso promedio de la primera muestra
peso_muestra2 = [6.67, 16.11, 18.89, 15.00, 10.56, 9.44, 8.89]; % Peso promedio de la segunda muestra

% Interpolación cúbica para ambas muestras
x_eval = linspace(0, 28, 100); % Puntos de evaluación

% Interpolación PCHIP
pp1 = pchip(dias, peso_muestra1); % Polinomio por tramos para la primera muestra
pp2 = pchip(dias, peso_muestra2); % Polinomio por tramos para la segunda muestra

% Evaluar los polinomios en los puntos de evaluación
peso_interp1 = ppval(pp1, x_eval);
peso_interp2 = ppval(pp2, x_eval);

% Graficar los resultados
figure;
hold on;
plot(x_eval, peso_interp1, 'b-', 'DisplayName', 'Muestra 1 (Hojas jóvenes)');
plot(x_eval, peso_interp2, 'r-', 'DisplayName', 'Muestra 2 (Hojas maduras)');
scatter(dias, peso_muestra1, 'bo', 'filled', 'DisplayName', 'Datos Muestra 1');
scatter(dias, peso_muestra2, 'ro', 'filled', 'DisplayName', 'Datos Muestra 2');
title('Interpolación del Peso Promedio de Larvas');
xlabel('Días');
ylabel('Peso promedio [mg]');
legend;
grid on;
hold off;

% b) Encontrar el peso promedio máximo para cada muestra
peso_max_muestra1 = max(peso_muestra1);
peso_max_muestra2 = max(peso_muestra2);

% Mostrar los resultados
fprintf('Peso promedio máximo de la Muestra 1: %.2f mg\n', peso_max_muestra1);
fprintf('Peso promedio máximo de la Muestra 2: %.2f mg\n', peso_max_muestra2);