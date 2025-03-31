% Ejercicio 7-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos tabulados
y = [0, 0.002, 0.006, 0.012, 0.018, 0.024]; % Distancias en metros
v = [0, 0.287, 0.899, 1.915, 3.048, 4.299]; % Velocidades en m/s

% Viscosidad dinámica
mu = 1.8e-5; % N·s/m²

% Interpolación para estimar la velocidad en y = 0
v0 = interp1(y, v, 0, 'linear');

% Calcular la derivada dv/dy utilizando diferencias finitas
% Usamos los puntos más cercanos a y = 0 para calcular la pendiente
dy = y(2) - y(1); % Diferencia en y
dv = v(2) - v(1); % Diferencia en v

% Calcular la derivada dv/dy
dv_dy = dv / dy; % m/s/m

% Calcular el esfuerzo cortante
tau = mu * dv_dy; % N/m²

% Mostrar resultados
fprintf('El esfuerzo cortante en la superficie (y = 0) es: %.4f N/m²\n', tau);