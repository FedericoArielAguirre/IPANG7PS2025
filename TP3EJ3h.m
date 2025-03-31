% Ejercicio 3h-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Ejemplo de uso de la función de integración por Gauss
f        = @(x) x.^2; % Definir la función a integrar
lim_inf  = 0;         % Límite inferior
lim_sup  = 1;         % Límite superior
n_puntos = 4;         % Elegir el número de puntos (2, 3, 4, 5 o 6)

% Calcular la integral utilizando el método de Gauss
resultado_gauss = gauss_integration(f, lim_inf, lim_sup, n_puntos);
fprintf('Integral de la función f(x) = x^2 utilizando el método de Gauss con %d puntos: %.4f\n', n_puntos, resultado_gauss);

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
