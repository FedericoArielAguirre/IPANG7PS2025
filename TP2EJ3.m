% Ejercicio 3-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% a) Condiciones adicionales para la interpolación cúbica
% Para que la interpolación cúbica (o la interpolación con 
% arcos de parábola) esté bien definida, se deben agregar condiciones 
% adicionales además de que el polinomio pase por los puntos de datos. 
% Estas condiciones pueden incluir:
% 
% Condiciones de continuidad: Asegurar que la función interpolante
% sea continua en todos los puntos de datos.
% 
% Condiciones de derivabilidad: Asegurar que la primera derivada 
% de la función interpolante sea continua en los puntos de datos. 
% Esto significa que las pendientes de los segmentos de 
% interpolación deben coincidir en los nodos.
% 
% Condiciones de frontera: Se pueden imponer condiciones
% en los extremos del intervalo, como la derivada en el 
% primer o último punto, o simplemente suponer que la 
% derivada es cero (condición de "clamped").
% 
% b) Resumen de las funciones pchip y ppval
% pchip: Esta función realiza la interpolación cúbica
% preservando la forma de los datos. Los argumentos son:
% 
% x: Un vector que contiene las abscisas de los puntos de datos.
% y: Un vector que contiene las ordenadas de los puntos de datos.
% El resultado es una estructura que representa el polinomio
% por tramos cúbico, que se puede usar para evaluar la 
% interpolación en puntos intermedios.
% ppval: Esta función evalúa el polinomio por tramos cúbico que 
% se ha creado con pchip. Los argumentos son:
% 
% pp: La estructura de polinomio por tramos que se obtiene de pchip.
% xq: Un vector de puntos en los que se desea evaluar el polinomio.
% El resultado es un vector que contiene los valores del polinomio evaluado en los puntos xq.


% Datos del peso
meses = [1, 2, 3, 4, 6, 7, 9, 12]; % Meses
pesos = [95, 95.5, 97.2, 97, 97.6, 98, 101, 103.3]; % Pesos

% Generamos un rango de valores para graficar
x_eval = linspace(min(meses), max(meses), 100);

% Interpolación con pchip
pp      = pchip(meses, pesos); % Crear el polinomio por tramos cúbico
y_pchip = ppval(pp, x_eval);   % Evaluar el polinomio en los puntos x_eval

% Graficar los resultados
figure;
hold on;
plot(x_eval, y_pchip, 'm-', 'DisplayName', 'Interpolación PCHIP');
scatter(meses, pesos, 'ro', 'filled', 'DisplayName', 'Datos de pesos');

% Graficar el polinomio de Lagrange
L_eval_pesos = evalLagrange(meses, pesos, x_eval);
plot(x_eval, L_eval_pesos, 'b-', 'DisplayName', 'Polinomio de Lagrange');

% Graficar el polinomio de Polyfit
coef_polyfit_pesos = polyfit(meses, pesos, length(meses) - 1);
y_polyfit_pesos    = polyval(coef_polyfit_pesos, x_eval);
plot(x_eval, y_polyfit_pesos, 'g--', 'DisplayName', 'Polinomio de Polyfit');

% Configuración de la gráfica
title('Comparación de Métodos de Interpolación');
xlabel('Meses');
ylabel('Peso (kg)');
legend;
grid on;
hold off;

function L_eval = evalLagrange(x, y, x_eval)
    L_eval = lagrange(x, y, x_eval);
end

function L = lagrange(x, y, x_eval)
    n = length(x);
    L = zeros(size(x_eval));
    
    for j = 1:n
        % Calculamos el polinomio de Lagrange para cada punto
        L_j = ones(size(x_eval));
        for i = [1:j-1, j+1:n]
            L_j = L_j .* (x_eval - x(i)) / (x(j) - x(i));
        end
        L = L + y(j) * L_j; % Suma de los polinomios de Lagrange
    end
end