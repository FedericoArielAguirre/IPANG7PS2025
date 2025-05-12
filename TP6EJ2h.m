% Ejercicio 2h-TP6
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Solución de la ecuación diferencial dy/dt = -y + t + 1
% con condición inicial y(0) = 1, para t en [0, 5]
% con paso inicial de 0.1 y error máximo de 10^-4

% Definimos la EDO como una función anónima
f = @(t, y) -y + t + 1;

% Intervalo de integración
t0  = 0;
tf  = 5;
y0  = 1;    % Condición inicial
h   = 0.1;  % Paso inicial
tol = 1e-4; % Tolerancia de error

% 1. MÉTODO 1: Solución Analítica
% La solución analítica es y(t) = t + 1 + Ce^(-t)
% Con y(0) = 1, tenemos 1 = 0 + 1 + C, entonces C = 0
% Por lo tanto, y(t) = t + 1

t_analitica = t0:h:tf;
y_analitica = t_analitica + 1;

% 2. MÉTODO 2: Método de Runge-Kutta de 4to orden
[t_rk4, y_rk4] = rk4_adaptativo(f, t0, tf, y0, h, tol);

% 3. MÉTODO 3: Utilizando la función ode45 de MATLAB
opciones = odeset('RelTol', tol, 'AbsTol', tol);
[t_ode45, y_ode45] = ode45(f, [t0 tf], y0, opciones);

% Graficamos los resultados
figure;
plot(t_analitica, y_analitica, 'k-', 'LineWidth', 2);
hold on;
plot(t_rk4, y_rk4, 'ro-', 'MarkerSize', 3);
plot(t_ode45, y_ode45, 'b.', 'MarkerSize', 8);
hold off;
grid on;

legend('Solución Analítica', 'Runge-Kutta 4 Adaptativo', 'ODE45', 'Location', 'Best');
title('Solución de dy/dt = -y + t + 1, y(0) = 1');
xlabel('t');
ylabel('y');

% Calculamos los errores
fprintf('Errores con respecto a la solución analítica:\n');

% Para RK4
errores_rk4 = zeros(size(t_rk4));
for i = 1:length(t_rk4)
    y_exacta = t_rk4(i) + 1;
    errores_rk4(i) = abs(y_rk4(i) - y_exacta);
end
error_max_rk4 = max(errores_rk4);
fprintf('Error máximo en RK4: %e\n', error_max_rk4);

% Para ODE45
errores_ode45 = zeros(size(t_ode45));
for i = 1:length(t_ode45)
    y_exacta = t_ode45(i) + 1;
    errores_ode45(i) = abs(y_ode45(i) - y_exacta);
end
error_max_ode45 = max(errores_ode45);
fprintf('Error máximo en ODE45: %e\n', error_max_ode45);

% Función para implementar Runge-Kutta 4to orden con paso adaptativo
function [t, y] = rk4_adaptativo(f, t0, tf, y0, h_inicial, tol)
    % Implementación de RK4 con paso adaptativo
    t = t0;
    y = y0;
    h = h_inicial;
    
    while t(end) < tf
        if t(end) + h > tf
            h = tf - t(end);  % Ajuste para no pasar tf
        end
        
        k1 = h * f(t(end), y(end));
        k2 = h * f(t(end) + h/2, y(end) + k1/2);
        k3 = h * f(t(end) + h/2, y(end) + k2/2);
        k4 = h * f(t(end) + h, y(end) + k3);
        
        % Solución RK4
        y_nuevo = y(end) + (k1 + 2*k2 + 2*k3 + k4) / 6;
        
        % Estimación del error
        % Usamos la diferencia entre RK4 y RK2 como estimación
        y_rk2 = y(end) + h * f(t(end) + h/2, y(end) + k1/2);
        error_est = abs(y_nuevo - y_rk2);
        
        % Ajuste del paso
        if error_est <= tol
            % Aceptamos el paso y continuamos
            t = [t; t(end) + h];
            y = [y; y_nuevo];
            
            % Podemos aumentar el paso si el error es muy pequeño
            if error_est < tol/10
                h = h * 1.1;
            end
        else
            % Rechazamos el paso y reducimos h
            h = h * 0.5;
        end
    end
end