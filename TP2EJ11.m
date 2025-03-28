% Ejercicio 11-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos
c = [0.5, 0.8, 1.5, 2.5, 4]; % Concentración de oxígeno (mg/L)
k = [1.1, 2.4, 5.3, 7.6, 8.9]; % Tasa de crecimiento

% Transformación
y = k ./ (c.^2); % y = k / c^2
x = 1 ./ (c.^2); % x = 1 / c^2

% Ajuste lineal
p = polyfit(x, y, 1); % p(1) = -c_s, p(2) = k_max

% Coeficientes
c_s   = -p(1);
k_max = p(2);

fprintf('Estimaciones:\n');
fprintf('c_s = %.4f mg/L\n', c_s);
fprintf('k_max = %.4f\n', k_max);

% Pronóstico para c = 2 mg/L
c_new  = 2; % Nueva concentración
k_pred = (k_max * c_new^2) / (c_s + c_new^2); % Usar la ecuación original

fprintf('Pronóstico de la tasa de crecimiento para c = %.2f mg/L: k = %.4f\n', c_new, k_pred);