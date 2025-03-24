% Ejercicio 8-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos
vec1 = [1 2 3 4 5 6 7 9 12 1 2 3 4 5 6 7 8 9 10 11 12 1 2 3 4 5 6 7 8 9 10 11 12]; % abscisas  
vec2 = [95 95.5 97.2 97 97.6 98 101 103 76 78 78 79 78.5 77 76.2 75.6 74.9 74.1 73.4 72.8 71 71.2 71.4 71.3 70.9 71.3 71.6 71.5 71.1 70.8 71.2 71.3]; % ordenadas  

% a) Construir el polinomio interpolante usando la matriz de Vandermonde manualmente
n = length(vec1);
V = zeros(n, n);
for i = 1:n
    for j = 1:n
        V(i, j) = vec1(i)^(n-j); % Matriz de Vandermonde
    end
end

% Intentar resolver el sistema
try
    coeffs = V \ vec2'; % Resolver el sistema
    fprintf('Polinomio interpolante construido usando la matriz de Vandermonde.\n');
catch
    fprintf('No se puede construir un polinomio interpolante debido a puntos repetidos.\n');
end


% Intentar construir el polinomio de Newton
try
    coeffs_newton = newton_interpolation(vec1, vec2);
    fprintf('Polinomio de interpolación de Newton construido.\n');
catch
    fprintf('No se puede construir un polinomio de interpolación de Newton debido a puntos repetidos.\n');
end

% c) Ajuste polinómico de grado 31
p = polyfit(vec1, vec2, 31);
fprintf('Coeficientes del ajuste polinómico de grado 31:\n');
disp(p);

% d) Pregunta sobre el ajuste polinómico de grado 31
fprintf('Un ajuste polinómico de grado 31 sobre 32 puntos puede ser un polinomio interpolante, pero no es único debido a puntos repetidos.\n');

% e) Ajustes polinómicos de grado 1 al 5
figure;
hold on;

% Evaluar y graficar polinomios de grado 1 a 5
x_eval = linspace(min(vec1), max(vec1), 30);
for degree = 1:5
    p = polyfit(vec1, vec2, degree);
    y_eval = polyval(p, x_eval);
    plot(x_eval, y_eval, 'DisplayName', sprintf('Grado %d', degree));
end

% Graficar los datos originales manualmente
for i = 1:length(vec1)
    plot(vec1(i), vec2(i), 'ro', 'MarkerFaceColor', 'r'); % Puntos originales
end

legend show;
xlabel('Abscisas');
ylabel('Ordenadas');
title('Ajustes polinómicos de grado 1 a 5');
hold off;


% Ejemplo de uso
coeficientes = polyfit(vec1, vec2, 3); % Ajuste de grado 3
ecm_resultado = calcular_ecm(coeficientes, vec1, vec2);
fprintf('Error cuadrático medio para el ajuste de grado 3: %.4f\n', ecm_resultado);

% g) Generar conjuntos de datos
% Conjunto 1
mesR = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
PesoR = [60, 62, 64, 66, 68, 70, 72, 74, 76, 78];

% Conjunto 2
mesLe = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
PesoLe = [55, 57, 59, 61, 63, 65, 67, 69, 71, 73];

% Conjunto 3
mesLu = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
PesoLu = [70, 72, 74, 76, 78, 80, 82, 84, 86, 88];

% Ajustes polinómicos y cálculo del ECM
degrees = 1:5; % Grados de ajuste
ecmR = zeros(length(degrees), 1);
ecmLe = zeros(length(degrees), 1);
ecmLu = zeros(length(degrees), 1);

for i = 1:length(degrees)
    % Ajuste para mesR
    pR = polyfit(mesR, PesoR, degrees(i));
    ecmR(i) = calcular_ecm(pR, mesR, PesoR);
    
    % Ajuste para mesLe
    pLe = polyfit(mesLe, PesoLe, degrees(i));
    ecmLe(i) = calcular_ecm(pLe, mesLe, PesoLe);
    
    % Ajuste para mesLu
    pLu = polyfit(mesLu, PesoLu, degrees(i));
    ecmLu(i) = calcular_ecm(pLu, mesLu, PesoLu);
end

% Mostrar resultados
fprintf('ECM para mesR: \n');
disp(ecmR);
fprintf('ECM para mesLe: \n');
disp(ecmLe);
fprintf('ECM para mesLu: \n');
disp(ecmLu);

% h) Análisis de la pandemia COVID-19
% Datos de COVID-19
dias = [1, 2, 3, 4, 5, 6, 7, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 91, 122, 153, 183, 214, 244, 275, 306, 334, 365];
casos_totales = [1133, 1265, 1353, 1451, 1554, 1628, 1715, 1975, 2571, 3031, 3780, 4428, 5020, 6034, 7479, 9283, 16214, 64530, 191302, 441735, 751001, 1166924, 1257227, 1613928, 1927239, 2107365, 2348821];

% Ajuste exponencial
% Transformación logarítmica
log_casos = log(casos_totales);
p_exp = polyfit(dias, log_casos, 1); % Ajuste lineal en el logaritmo

% Predicción
y_pred_exp = exp(polyval(p_exp, dias));

% Calcular ECM
ecm_exp = calcular_ecm(p_exp, dias, log_casos);

% Graficar resultados
figure;
plot(dias, casos_totales, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Datos Reales');
hold on;
plot(dias, y_pred_exp, 'b-', 'DisplayName', 'Ajuste Exponencial');
xlabel('Días');
ylabel('Casos Totales');
title('Ajuste Exponencial a los Casos Totales de COVID-19');
legend show;
hold off;

% Mostrar el error cuadrático medio
fprintf('Error cuadrático medio para el ajuste exponencial: %.4f\n', ecm_exp);

% Análisis de la hipótesis
fprintf(['La hipótesis inicial de crecimiento exponencial puede dejar de cumplirse debido a factores como' ...
    ' medidas de control, vacunación y cambios en el comportamiento social.\n']);

% h) Análisis de la pandemia COVID-19
% Datos de COVID-19
dias = [1, 2, 3, 4, 5, 6, 7, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 91, 122, 153, 183, 214, 244, 275, 306, 334, 365];
casos_totales = [1133, 1265, 1353, 1451, 1554, 1628, 1715, 1975, 2571, 3031, 3780, 4428, 5020, 6034, 7479, 9283, 16214, 64530, 191302, 441735, 751001, 1166924, 1257227, 1613928, 1927239, 2107365, 2348821];

% Ajuste exponencial
% Transformación logarítmica
log_casos = log(casos_totales);
p_exp = polyfit(dias, log_casos, 1); % Ajuste lineal en el logaritmo

% Predicción
y_pred_exp = exp(polyval(p_exp, dias));

% Calcular ECM
ecm_exp = calcular_ecm(p_exp, dias, log_casos);

% Graficar resultados
figure;
plot(dias, casos_totales, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Datos Reales');
hold on;
plot(dias, y_pred_exp, 'b-', 'DisplayName', 'Ajuste Exponencial');
xlabel('Días');
ylabel('Casos Totales');
title('Ajuste Exponencial a los Casos Totales de COVID-19');
legend show;
hold off;

% Mostrar el error cuadrático medio
fprintf('Error cuadrático medio para el ajuste exponencial: %.4f\n', ecm_exp);

% Análisis de la hipótesis
fprintf(['La hipótesis inicial de crecimiento exponencial puede dejar de cumplirse debido a factores como' ...
    ' medidas de control, vacunación y cambios en el comportamiento social.\n']);

% b) Polinomio de interpolación de Newton
function coeffs = newton_interpolation(x, y)
    n = length(x);
    coeffs = zeros(n, n);
    coeffs(:, 1) = y(:);
    
    for j = 2:n
        for i = 1:n-j+1
            coeffs(i, j) = (coeffs(i+1, j-1) - coeffs(i, j-1)) / (x(i+j-1) - x(i));
        end
    end
end

% f) Función para calcular el error cuadrático medio
function ecm = calcular_ecm(coeficientes, x, y)
    y_pred = polyval(coeficientes, x);
    ecm = mean((y - y_pred).^2);
end
