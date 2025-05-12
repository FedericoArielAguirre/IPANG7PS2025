% Ejercicio 4-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Definir parámetros
R = 3; % Radio del tanque en metros
V = 30;% Volumen deseado en metros cúbicos
% Definir la función que representa la ecuación del volumen V - 30 = 0
f = @(h) pi * h.^2 .* (3*R - h) / 3 - V;
% Implementación del método de bisección para encontrar la raíz
% Límites iniciales para la búsqueda
a = 0;  % Límite inferior (h no puede ser negativo)
b = 2*R;  % Límite superior (h no puede ser mayor que el diámetro)
% Criterio de tolerancia para convergencia
tol      = 1e-8;
max_iter = 100;  % Número máximo de iteraciones
% Verificar que f(a) y f(b) tienen signos opuestos
if f(a) * f(b) >= 0
    error('La función debe tener signos opuestos en los límites del intervalo.');
end
% Método de bisección
iter = 0;
while (b - a) > tol && iter < max_iter
    % Calcular el punto medio
    h_mid = (a + b) / 2;
    % Evaluar la función en el punto medio
    f_mid = f(h_mid);
    % Verificar si hemos encontrado la raíz
    if abs(f_mid) < tol
        break;
    end    
    % Actualizar los límites
    if f(a) * f_mid < 0
        b = h_mid;
    else
        a = h_mid;
    end   
    iter = iter + 1;
end
h_solution = (a + b) / 2;
% Mostrar el resultado con cuatro decimales
fprintf('La profundidad h debe ser aproximadamente %.4f metros\n', h_solution);
% Método de la Regla del Trapecio para calcular el volumen (verificación)
% Función para calcular el área de sección transversal a la altura y
area = @(y) pi * (R.^2 - (R - y).^2);
% Cálculo del volumen usando el método del trapecio (con 100 subintervalos)
V_calculado = trapecio(area, 0, h_solution, 100);
fprintf('Verificación: El volumen calculado por el método del trapecio es: %.4f metros cúbicos\n', V_calculado);
% Cálculo del volumen usando el método de Simpson (con 100 subintervalos)
V_simpson = simpson(area, 0, h_solution, 100);
fprintf('Verificación: El volumen calculado por el método de Simpson es: %.4f metros cúbicos\n', V_simpson);
% Método de Simpson (1/3) para calcular el volumen (verificación adicional)
function V_simp = simpson(func, a, b, n)
    % Asegurar que n es par
    if mod(n, 2) ~= 0
        n = n + 1;
    end
    h = (b - a) / n;
    x = a:h:b;
    y = func(x);
    % Aplicar la regla de Simpson 1/3
    coefs            = ones(1, n+1);
    coefs(2:2:end-1) = 4;  % Coeficientes para índices pares
    coefs(3:2:end-2) = 2;  % Coeficientes para índices impares
    V_simp           = (h/3) * sum(coefs .* y);
end
% Implementación del método del trapecio para integrar el área
function V_trap = trapecio(func, a, b, n)
    h      = (b - a) / n;
    x      = a:h:b;
    y      = func(x);
    V_trap = h * (sum(y) - (y(1) + y(end))/2);
end