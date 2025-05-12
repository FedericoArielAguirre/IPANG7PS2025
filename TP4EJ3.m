% Ejercicio 3-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Definir constantes
g        = 9.8; % Aceleración debido a la gravedad en m/s^2
t        = 1;   % Tiempo en segundos
x_target = 0.1; % Desplazamiento objetivo en metros
% Definir la función f(omega) = x(t) - x_target
f = @(omega) - (g / (2 * omega^2)) * ( (exp(omega * t) - exp(-omega * t)) / 2 - sin(omega * t) ) - x_target;
% Implementar búsqueda binaria para encontrar omega
% Definir tolerancia para omega
tol = 1e-5;
% Límites iniciales para búsqueda binaria
lower = -10;
upper = -0.01;
% Verificar si la solución está dentro de los límites
if f(lower) * f(upper) > 0
    error('La solución no está en el intervalo especificado.');
end
% Búsqueda binaria
while (upper - lower > tol)
    mid = (lower + upper) / 2;
    if f(mid) * f(lower) < 0
        upper = mid;
    else
        lower = mid;
    end
end
% Resultado final
omega = (lower + upper) / 2;
% Mostrar el resultado
fprintf('La velocidad angular omega es aproximadamente: %.6f rad/s\n', omega);