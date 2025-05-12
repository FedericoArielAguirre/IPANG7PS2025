% Ejercicio 6-TP3
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Datos tabulados
tiempo  = [0, 1, 5, 8];     % Tiempo en segundos
volumen = [0, 1, 8, 16.4];  % Volumen en cm^3
% Tiempo en el que queremos estimar la tasa de flujo
t_estimar = 7;
% Interpolación lineal para estimar el volumen en t = 7 seg
volumen_estimado = interp1(tiempo, volumen, t_estimar, 'linear');
% Encontrar los puntos más cercanos para calcular la tasa de flujo
% Usamos los puntos en t = 5 y t = 8
t1 = 5; t2 = 8;
v1 = volumen(tiempo == t1);
v2 = volumen(tiempo == t2);
% Calcular la tasa de flujo
tasa_flujo = (v2 - v1) / (t2 - t1); % cm^3/s
% Mostrar resultados
fprintf('El volumen estimado a t = %.1f seg es: %.2f cm^3\n', t_estimar, volumen_estimado);
fprintf('La tasa de flujo estimada es: %.2f cm^3/s\n', tasa_flujo);