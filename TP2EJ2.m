% Ejercicio 2-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definimos los vectores de entrada
vec_x = [1; 1.3; 2; 2.9; 3; 4; 7; 12];
vec_y = [1 2 3 4 5 6 7 8];


% Generamos un rango de valores para graficar
x_eval = linspace(min(vec_x) - 100, max(vec_x) + 100, 1000);
L = lagrange(vec_x, vec_y, x_eval);

% Graficamos los polinomios de Lagrange
figure;
hold on;
plot(x_eval, L, 'b-', 'DisplayName', 'Polinomio de Lagrange');
scatter(vec_x, vec_y, 'ro', 'filled', 'DisplayName', 'Puntos de datos');
title('Polinomio de Lagrange');
xlabel('x');
ylabel('y');
legend;
grid on;

% b) Generar y graficar el polinomio interpolante sumando los polinomios de Lagrange
% Ya se ha hecho en el paso anterior, el polinomio de Lagrange ya es la suma de los polinomios.

% c) Generar y graficar el polinomio interpolante mediante polyfit y polyval
% Usamos polyfit para obtener los coeficientes del polinomio
n_polyfit = length(vec_x) - 1; % Grado del polinomio
coef_polyfit = polyfit(vec_x, vec_y, n_polyfit);
y_polyfit = polyval(coef_polyfit, x_eval);

% Graficamos el polinomio de polyfit
plot(x_eval, y_polyfit, 'g--', 'DisplayName', 'Polinomio de Polyfit');
legend;


% Usamos la función con los datos del peso de la persona
meses = [1, 2, 3, 4, 6, 7, 9, 12]; % Meses
pesos = [95, 95.5, 97.2, 97, 97.6, 98, 101, 103.3]; % Pesos

% Evaluamos el polinomio de Lagrange en un rango de meses
x_eval_pesos = linspace(min(meses), max(meses), 100);
L_eval_pesos = evalLagrange(meses, pesos, x_eval_pesos);

% Graficamos el polinomio de Lagrange para los pesos
figure;
hold on;
plot(x_eval_pesos, L_eval_pesos, 'b-', 'DisplayName', 'Polinomio de Lagrange (Pesos)');
scatter(meses, pesos, 'ro', 'filled', 'DisplayName', 'Datos de pesos');
title('Polinomio de Lagrange para los pesos');
xlabel('Meses');
ylabel('Peso (kg)');
legend;
grid on;

% Comparación con el polinomio de polyfit para los pesos
coef_polyfit_pesos = polyfit(meses, pesos, length(meses) - 1);
y_polyfit_pesos = polyval(coef_polyfit_pesos, x_eval_pesos);
plot(x_eval_pesos, y_polyfit_pesos, 'g--', 'DisplayName', 'Polinomio de Polyfit (Pesos)');
legend;

% d) Función para evaluar el polinomio de Lagrange en puntos específicos
function L_eval = evalLagrange(x, y, x_eval)
    L_eval = lagrange(x, y, x_eval);
end

% a) Generar y graficar los distintos polinomios de Lagrange
% Definimos la función de Lagrange
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