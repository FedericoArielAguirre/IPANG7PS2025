% Ejercicio 1-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Expansión Polinómica y Derivadas Numéricas en MATLAB

% a) Expansión polinómica de grado 1 en función de x = x + x0
% La expansión es:
% f(x) ≈ f(x0) + f'(x0)(x - x0)
% Derivada primera:
% f'(x0) = (f(x) - f(x0)) / (x - x0)
% Esta derivada se llama derivada progresiva.

% b) Expansión polinómica en función de x = x - x0
% La expansión es:
% f(x) ≈ f(x0) + f'(x0)(x - x0)
% Derivada primera:
% f'(x0) = (f(x0) - f(x)) / (x0 - x)
% Esta derivada se llama derivada regresiva.

% c) Derivada centrada
% A partir de la suma de ambas expansiones:
% f'(x0) ≈ (f(x0 + h) - f(x0 - h)) / (2h)
% Esta expresión se llama derivada centrada.

% d) Orden de errores
% - Derivadas laterales (progresiva y regresiva) tienen un error de orden O(h).
% - Derivada centrada tiene un error de orden O(h^2).
% La derivada centrada es más precisa, por lo que se prefiere usarla cuando se dispone de datos suficientes.

% Diagrama de flujo (pseudocódigo):
% Inicio
%     Si hay datos suficientes para calcular derivadas centradas
%         Usar derivada centrada
%     Sino
%         Si hay datos suficientes para calcular derivadas progresivas
%             Usar derivada progresiva
%         Sino
%             Usar derivada regresiva
% Fin

% e) Derivada segunda centrada
% f''(x0) ≈ (f(x0 + h) - 2f(x0) + f(x0 - h)) / (h^2)
% El error es de orden O(h^2).

% f) Condiciones para el cálculo de derivadas
% Una condición que puede impedir el cálculo de la derivada numérica es la falta de datos suficientes en los extremos del conjunto de puntos.

% g) Diagrama de flujo para derivadas regresivas, progresivas y centrales
% Inicio
%     Para cada punto en x
%         Si no es el primer punto y no es el último
%             Calcular derivada centrada
%         Si no es el primer punto
%             Calcular derivada regresiva
%         Si no es el último punto
%             Calcular derivada progresiva
% Fin


% i) Aplicación y gráfica de derivadas
% Datos de ejemplo
x = linspace(0, 10, 100);          % Vector de puntos
y = sin(x) + 0.1 * randn(size(x)); % Función con ruido

[d_regresiva, d_progresiva, d_centrada] = derivadas(x, y);

% Graficar
figure;
hold on;
plot(x, y, 'k', 'DisplayName', 'Datos Originales');
plot(x, d_regresiva, 'r', 'DisplayName', 'Derivada Regresiva');
plot(x, d_progresiva, 'g', 'DisplayName', 'Derivada Progresiva');
plot(x, d_centrada, 'b', 'DisplayName', 'Derivada Centrada');
legend;
title('Derivadas Numéricas');
xlabel('x');
ylabel('Derivadas');
hold off;

% j) Salteando uno de cada dos puntos
x_salteado = x(1:2:end);
y_salteado = y(1:2:end);

[d_regresiva_salteado, d_progresiva_salteado, d_centrada_salteado] = derivadas(x_salteado, y_salteado);

% Graficar
figure;
hold on;
plot(x_salteado, y_salteado, 'k', 'DisplayName', 'Datos Originales (Salteados)');
plot(x_salteado, d_regresiva_salteado, 'r', 'DisplayName', 'Derivada Regresiva (Salteados)');
plot(x_salteado, d_progresiva_salteado, 'g', 'DisplayName', 'Derivada Progresiva (Salteados)');
plot(x_salteado, d_centrada_salteado, ' b', 'DisplayName', 'Derivada Centrada (Salteados)');
legend;
title('Derivadas Numéricas con Puntos Salteados');
xlabel('x');
ylabel('Derivadas');
hold off;

% k) Variar el valor de d (ruido)
d           = 0.5;                         % Modificar este valor para cambiar el ruido
y_con_ruido = sin(x) + d * randn(size(x)); % Función con ruido variable

[d_regresiva_ruido, d_progresiva_ruido, d_centrada_ruido] = derivadas(x, y_con_ruido);

% Graficar
figure;
hold on;
plot(x, y_con_ruido, 'k', 'DisplayName', 'Datos Originales con Ruido');
plot(x, d_regresiva_ruido, 'r', 'DisplayName', 'Derivada Regresiva');
plot(x, d_progresiva_ruido, 'g', 'DisplayName', 'Derivada Progresiva');
plot(x, d_centrada_ruido, 'b', 'DisplayName', 'Derivada Centrada');
legend;
title('Derivadas Numéricas con Ruido Variable');
xlabel('x');
ylabel('Derivadas');
hold off;

% l) Variar el paso en la generación del vector x
x_nuevo = 0:0.1:10;                                  % Cambiar el paso
y_nuevo = sin(x_nuevo) + 0.1 * randn(size(x_nuevo)); % Función con ruido

[d_regresiva_nuevo, d_progresiva_nuevo, d_centrada_nuevo] = derivadas(x_nuevo, y_nuevo);

% Graficar
figure;
hold on;
plot(x_nuevo, y_nuevo, 'k', 'DisplayName', 'Datos Originales con Nuevo Paso');
plot(x_nuevo, d_regresiva_nuevo, 'r', 'DisplayName', 'Derivada Regresiva');
plot(x_nuevo, d_progresiva_nuevo, 'g', 'DisplayName', 'Derivada Progresiva');
plot(x_nuevo, d_centrada_nuevo, 'b', 'DisplayName', 'Derivada Centrada');
legend;
title('Derivadas Numéricas con Nuevo Paso');
xlabel('x');
ylabel('Derivadas');
hold off;

% h) Función para calcular derivadas
function [d_regresiva, d_progresiva, d_centrada] = derivadas(x, y)
    n = length(x);
    d_regresiva = zeros(1, n);
    d_progresiva = zeros(1, n);
    d_centrada = zeros(1, n);
    
    % Derivada regresiva
    for i = 2:n
        d_regresiva(i)  = (y(i) - y(i-1)) / (x(i) - x(i-1));
    end
    
    % Derivada progresiva
    for i = 1:n-1
        d_progresiva(i) = (y(i+1) - y(i)) / (x(i+1) - x(i));
    end
    
    % Derivada centrada
    for i = 2:n-1
        d_centrada(i)   = (y(i+1) - y(i-1)) / (x(i+1) - x(i-1));
    end
end
