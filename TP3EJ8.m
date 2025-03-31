% Ejercicio 8-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos proporcionados
t = [10, 20, 30, 40, 50, 60];             % Tiempo
c = [3.52, 2.48, 1.75, 1.23, 0.87, 0.61]; % Concentración

% Calcular dc/dt
dc_dt = diff(c) ./ diff(t); % Diferencias finitas para calcular la derivada

% Solución: Crear un nuevo dc_dt con la misma longitud que c
% Opción 1: Añadir un valor al final (diferencia hacia adelante)
dc_dt_extended          = zeros(size(c));
dc_dt_extended(1:end-1) = dc_dt;          % Primeros 5 elementos
dc_dt_extended(end)     = dc_dt(end);     % Repetir el último valor para el sexto elemento

% Opción un mejor enfoque: Centrar los valores derivados
t_mid        = (t(1:end-1) + t(2:end))/2;                    % Puntos medios de intervalos de tiempo
dc_dt_interp = interp1(t_mid, dc_dt, t, 'linear', 'extrap'); % Interpolar a los puntos de tiempo originales

% Calcular log(-dc/dt) y log(c)
log_dc_dt = log(-dc_dt_interp); % Logaritmo de la tasa de cambio
log_c     = log(c);             % Logaritmo de la concentración

% Realizar regresión lineal

% Ajustar una línea a los datos logarítmicos
p = polyfit(log_c, log_dc_dt, 1); % p(1) = n, p(2) = log(k)

% Extraer k y n
n = p(1);      % Orden de reacción
k = exp(p(2)); % Tasa de reacción

% Mostrar resultados
fprintf('El valor estimado de n (orden de reacción) es: %.4f\n', n);
fprintf('El valor estimado de k (tasa de reacción) es: %.4f\n', k);