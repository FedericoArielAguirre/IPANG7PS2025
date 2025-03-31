% Ejercicio 11-TP2 Versión 2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos
c = [0.5, 0.8, 1.5, 2.5, 4]; % Concentración de oxígeno (mg/L)
k = [1.1, 2.4, 5.3, 7.6, 8.9]; % Tasa de crecimiento (por día)

% 1. Transformación para linealizar la ecuación
y = 1 ./ k; % y = 1/k
x = 1 ./ (c.^2); % x = 1/c^2

% 2. Ajuste lineal
% Realizamos el ajuste lineal usando polyfit
p = polyfit(x, y, 1); % p(1) = m, p(2) = b

% Extraemos los parámetros
m = p(1); % m = 1/k_max
b = p(2); % b = c_s/k_max

% Calculamos k_max y c_s
k_max = 1 / m; % k_max
c_s = b * k_max; % c_s

% Mostrar los resultados
fprintf('Estimación de k_max: %.4f\n', k_max);
fprintf('Estimación de c_s en mg/L: %.4f\n', c_s);

% 3. Pronosticar la tasa de crecimiento para c = 2 mg/L
c_predict = 2; % Concentración de oxígeno para pronóstico
k_predict = (k_max * c_predict^2) / (c_s + c_predict^2); % Tasa de crecimiento pronosticada

% Mostrar el pronóstico
fprintf('Pronóstico de la tasa de crecimiento para c = %.2f mg/L: %.4f\n', c_predict, k_predict);