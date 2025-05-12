% Ejercicio 7-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Parámetros
V = 1e6;  % volumen del lago, m^3
Q = 1e5;  % caudal, m^3/año
W = 1e6;  % tasa de entrada de contaminante, g/año
k = 0.25; % constante de tasa de reacción, g^0.5/(m^1.5 * año)
% Estimación inicial para la concentración
c = 10;  % g/m^3
% Parámetros de convergencia
tol      = 1e-6; % tolerancia
max_iter = 1000; % número máximo de iteraciones
iter     = 0;    % contador de iteraciones
% Iteración de punto fijo
while iter < max_iter
    c_new = (W - k * V * sqrt(c)) / Q;
    % Comprobar concentración negativa
    if c_new < 0
        error('La concentración se volvió negativa. Ajuste la estimación inicial o los parámetros.');
    end
    % Comprobar convergencia
    if abs(c_new - c) < tol
        break;
    end 
    c = c_new;
    iter = iter + 1;
end
% Mostrar resultados
if iter == max_iter
    disp('Se alcanzó el número máximo de iteraciones. La solución podría no haber convergido.');
else
    disp(['Iteraciones necesarias: ',num2str(iter)]);
end
disp(['Concentración en estado estacionario c = ', num2str(c_new), ' g/m^3']);