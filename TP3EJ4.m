% Ejercicio 4-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definir los puntos de datos
X = [0, 0.5, 1];  % Puntos en el eje X
Y = [0, 0.25, 1]; % Valores de la función en esos puntos (por ejemplo, f(x) = x^2)

% Llamar a la función para calcular la integral
resultado = gauss_integration_from_points(X, Y);

% Mostrar el resultado
if isnan(resultado)
    fprintf('No se pudo calcular la integral.\n');
else
    fprintf('La integral del polinomio interpolante es: %.4f\n', resultado);
end

function resultado = gauss_integration_from_points(X, Y)
    % Función que calcula la integral de un polinomio interpolante
    % a partir de los puntos dados en los vectores X e Y utilizando
    % el método de integración de Gauss.
    
    % Paso 1: Calcular el polinomio interpolante
    n     = length(X);            % Número de puntos
    grado = n - 1;                % Grado del polinomio
    p     = polyfit(X, Y, grado); % Coeficientes del polinomio interpolante
    
    % Paso 2: Estimar el número de parámetros necesarios
    % Para un polinomio de grado 'grado', se necesitan (grado + 1) / 2 puntos de Gauss
    n_puntos = ceil((grado + 1) / 2);
    
    % Paso 3: Verificar si la rutina de integración puede calcular la integral exacta
    if n_puntos > 6
        fprintf('Error: Se requieren más de 6 puntos de Gauss, lo cual no es soportado.\n');
        resultado = NaN;
        return;
    end
    
    % Paso 4: Calcular la integral exacta utilizando la rutina de integración de Gauss
    lim_inf = min(X); % Límite inferior
    lim_sup = max(X); % Límite superior
    
    resultado = gauss_integration(@(x) polyval(p, x), lim_inf, lim_sup, n_puntos);
    
    % Paso 5: Si la integral no se puede calcular, mostrar un mensaje de error
    if isnan(resultado)
        fprintf('Error al calcular la integral.\n');
        resultado = NaN;
    end
end

function resultado = gauss_integration(funcion, lim_inf, lim_sup, n_puntos)
    % Función que calcula la integral de 'funcion' en el intervalo [lim_inf, lim_sup]
    % utilizando el método de integración de Gauss con n_puntos.
    
    % Definir los pesos y las posiciones de los puntos de Gauss
    switch n_puntos
        case 2
            w = [1, 1];                  % Pesos
            z = [0.5773502, -0.5773502]; % Raíces
        case 3
            w = [0.5555555555555556, 0.8888888888888888, 0.5555555555555556]; % Pesos
            z = [0.7745966692414834, 0, -0.7745966692414834];                 % Raíces
        case 4
            w = [0.3478548451374539, 0.6521451548625461, 0.6521451548625461, 0.3478548451374539];   % Pesos
            z = [0.8611363115940526, 0.3399810435848563, -0.3399810435848563, -0.8611363115940526]; % Raíces
        case 5
            w = [0.2369268850561891, 0.4786286704993665, 0.5688888888888889, 0.4786286704993665, 0.2369268850561891]; % Pesos
            z = [0.9061798459386639, 0.5384693101056831, 0, -0.5384693101056831, -0.9061798459386639];                % Raíces
        case 6
            w = [0.1713244923791703, 0.3607615730481386, 0.4679139345726910, 0.4679139345726910, 0.3607615730481386, 0.1713244923791703];    % Pesos
            z = [0.9324695142031521, 0.6612093864662645, 0.2386191860831969, -0.2386191860831969, -0.6612093864662645, -0.9324695142031521]; % Raíces
        otherwise
            error('Número de puntos no válido. Debe ser entre 2 y 6.');
    end
    
    % Cambiar el intervalo [lim_inf, lim_sup] a [-1, 1]
    % y calcular la integral
    resultado = 0;
    for i = 1:n_puntos
        % Transformar las raíces de Gauss al intervalo [lim_inf, lim_sup]
        x_i       = 0.5 * (lim_sup - lim_inf) * z(i) + 0.5 * (lim_sup + lim_inf);
        resultado = resultado + w(i) * funcion(x_i);
    end
    
    % Escalar el resultado por el ancho del intervalo
    resultado = 0.5 * (lim_sup - lim_inf) * resultado;
end