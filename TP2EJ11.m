% Ejercicio 11-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Parámetros
g   = 9.81; % m/s^2
m   = 68.1; % kg
c_d = 0.25; % kg/m

% a) Integración analítica
syms t;                                        % Definir variable simbólica
v_t = (g * m / c_d) * tanh((g * c_d / m) * t); % Velocidad como función de t

% Integrar para obtener la distancia
s_t             = int(v_t, t);              % Distancia como función de t
s_10_analytical = double(subs(s_t, t, 10)); % Evaluar en t = 10 segundos

fprintf('a) Distancia caída después de 10 segundos (analítica): %.4f m\n', s_10_analytical);

% b) Integración numérica usando el método de Newton-Cotes
t_start     = 0;    % Tiempo inicial
t_end       = 10;   % Tiempo final
n_intervals = 100;  % Número de intervalos para la integración

% Crear un vector de tiempos
t_values = linspace(t_start, t_end, n_intervals + 1);
dt       = t_values(2) - t_values(1); % Tamaño del paso

% Calcular la velocidad en cada punto de tiempo
v_values = (g * m / c_d) * tanh((g * c_d / m) * t_values);

% Método del rectángulo para la integración numérica
s_numeric = sum(v_values(1:end-1) * dt); % Integrar usando el método de rectángulos

fprintf('b) Distancia caída después de 10 segundos (numérica): %.4f m\n', s_numeric);
