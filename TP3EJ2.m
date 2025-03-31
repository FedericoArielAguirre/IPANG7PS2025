% Ejercicio 2-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Métodos de Integración Numérica en MATLAB

% a) Diagramas de flujo para los métodos de integración

% Diagrama de flujo para el método de Trapecios:
% Inicio
%     Definir a, b (límites de integración)
%     Definir n (número de intervalos)
%     h = (b - a) / n
%     S = 0
%     Para i = 1 hasta n
%         x_i = a + i * h
%         S = S + f(x_i)
%     Fin Para
%     S = (h / 2) * (f(a) + 2 * S + f(b))
% Fin

% Diagrama de flujo para el método de Simpson 1/3:
% Inicio
%     Definir a, b (límites de integración)
%     Definir n (número de intervalos, debe ser par)
%     h = (b - a) / n
%     S = f(a) + f(b)
%     Para i = 1 hasta n-1
%         x_i = a + i * h
%         Si i es impar
%             S = S + 4 * f(x_i)
%         Sino
%             S = S + 2 * f(x_i)
%         Fin Si
%     Fin Para
%     S = S * (h / 3)
% Fin

% Diagrama de flujo para el método de Gauss de 4 puntos:
% Inicio
%     Definir a, b (límites de integración)
%     c1 = (b - a) / 2
%     c2 = (b + a) / 2
%     S = (c1 / 2) * (f(c2 - c1 * sqrt(3/5)) + f(c2 + c1 * sqrt(3/5)) + ...
%                    f(c2 - c1 * sqrt(1/5)) + f(c2 + c1 * sqrt(1/5))
% Fin

% Ejemplo de uso de la función de trapecios con una función
f = @(x) x.^2; % Definir la función a integrar
a = 0;         % Límite inferior
b = 1;         % Límite superior
n = 100;       % Número de intervalos

resultado_func = trapecios(f, a, b, n);
fprintf('Integral de la función f(x) = x^2 en [0, 1]: %.4f\n', resultado_func);

% Ejemplo de uso de la función de trapecios con vectores
X = [0, 0.5, 1];  % Puntos en el eje X
Y = [0, 0.25, 1]; % Valores de la función en esos puntos

resultado_vector = trapecios_vector(X, Y);
fprintf('Integral de los puntos dados: %.4f\n', resultado_vector);

% b) Función para el Método de Trapecios
function integral = trapecios(func, a, b, n)
    % Función que calcula la integral de 'func' en el intervalo [a, b]
    % utilizando el método de trapecios con n intervalos.
    
    h = (b - a) / n;               % Ancho de los intervalos
    S = 0.5 * (func(a) + func(b)); % Inicializar con los extremos
    
    for i = 1:n-1
        x_i = a + i * h;     % Calcular el punto x_i
        S   = S + func(x_i); % Sumar el valor de la función en x_i
    end
    
    integral = h * S; % Calcular la integral
end

% c) Modificación para Aceptar Vectores
function integral = trapecios_vector(X, Y)
    % Función que calcula la integral de los puntos dados por los vectores
    % X e Y utilizando el método de trapecios.
    
    n = length(X); % Número de puntos
    if n ~= length(Y)
        error('Los vectores X e Y deben tener la misma longitud.');
    end
    
    integral = 0; % Inicializar la integral
    
    for i = 1:n-1
        h        = X(i+1) - X(i);                        % Ancho del intervalo
        integral = integral + (h / 2) * (Y(i) + Y(i+1)); % Sumar el área del trapecio
    end
end