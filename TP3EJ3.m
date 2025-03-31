% Ejercicio 3-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Métodos de Integración Numérica en MATLAB

% a) El código original utiliza el método de Simpson 1/3 para la integración.
% Este método combina los valores de la función en los extremos y en los puntos intermedios,
% utilizando coeficientes específicos para los puntos pares e impares.

% Ejemplo de uso de la función de integración por trapecios
f       = @(x) x.^2; % Definir la función a integrar
lim_inf = 0;         % Límite inferior
lim_sup = 1;         % Límite superior
nPasos  = 100;       % Número de intervalos

% Calcular la integral utilizando el método de trapecios
resultado_trapecios = integral_trapecios(f, lim_inf, lim_sup, nPasos);
fprintf('Integral de la función f(x) = x^2 utilizando el método de trapecios: %.4f\n', resultado_trapecios);

% Comparar con el método de Simpson
resultado_simpson = integral_simpson(f, lim_inf, lim_sup, nPasos);
fprintf('Integral de la función f(x) = x^2 utilizando el método de Simpson: %.4f\n', resultado_simpson);

% Función para el método de trapecios
function resultado = integral_trapecios(funcion, lim_inf, lim_sup, nPasos)
    % Función que calcula la integral de 'funcion' en el intervalo [lim_inf, lim_sup]
    % utilizando el método de trapecios con nPasos intervalos.
    
    n    = nPasos;
    h    = (lim_sup - lim_inf) / n; % Ancho de los intervalos
    suma = 0;                       % Inicializar la suma
    
    % Calcular la suma de los valores de la función en los extremos
    suma = funcion(lim_inf) + funcion(lim_sup);
    
    % Sumar los valores de la función en los puntos intermedios
    for i = 1:n-1
        x_i  = lim_inf + i * h;        % Calcular el punto x_i
        suma = suma + 2 * funcion(x_i);% Sumar el valor de la función en x_i
    end
    
    resultado = (h / 2) * suma; % Calcular la integral
end

% Función para el método de Simpson
function resultado = integral_simpson(funcion, lim_inf, lim_sup, nPasos)
    % Función que calcula la integral de 'funcion' en el intervalo [lim_inf, lim_sup]
    % utilizando el método de Simpson 1/3 con nPasos intervalos.
    
    n = nPasos;
    if mod(n, 2) == 1
        error('El número de pasos debe ser par para el método de Simpson.');
    end
    
    h    = (lim_sup - lim_inf) / n;             % Ancho de los intervalos
    suma = funcion(lim_inf) + funcion(lim_sup); % Inicializar con los extremos
    
    % Sumar los valores de la función en los puntos intermedios
    for i = 1:n-1
        x_i = lim_inf + i * h; % Calcular el punto x_i
        if mod(i, 2) == 0
            suma = suma + 2 * funcion(x_i); % Sumar para puntos pares
        else
            suma = suma + 4 * funcion(x_i); % Sumar para puntos impares
        end
    end
    
    resultado = (h / 3) * suma; % Calcular la integral
end