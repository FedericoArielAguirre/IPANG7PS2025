% Ejercicio 8-TP2 Version 2

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definición de los vectores
vec1 = [1 2 3 4 5 6 7 9 12 ...
        1 2 3 4 5 6 7 8 9 10 11 12 ...
        1 2 3 4 5 6 7 8 9 10 11 12]; % abscisas  
vec2 = [95 95.5 97.2 97 97.6 98 101 103 ...
        76 78 78 79 78.5 77 76.2 75.6 74.9 74.1 73.4 72.8 ...
        71 71.2 71.4 71.3 70.9 71.3 71.6 71.5 71.1 70.8 71.2 ...
        71.3 71.3]; % ordenadas


% a) Polinomio interpolante usando la matriz de Vandermonde
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

% b) Polinomio de Newton
coeffs_newton = newton_interpolation(vec1, vec2); % Función definida al final

% c) Ajuste polinómico de grado 5 (reducido para evitar problemas)
try
    p5 = polyfit(vec1, vec2, 5);
    disp('Coeficientes del ajuste polinómico de grado 5:');
    disp(p5);
catch ME
    disp('Error al calcular el ajuste polinómico de grado 5:');
    disp(ME.message);
end

% Verificación si es un polinomio interpolante
if exist('p5', 'var') % Check if p5 exists
    is_interpolating = all(abs(polyval(p5, vec1) - vec2') < 1e-10);
    disp(['¿Es el ajuste un polinomio interpolante? ', num2str(is_interpolating)]);
else
    disp('No se puede verificar si es un polinomio interpolante porque p5 no está definido.');
end

% d) Pregunta sobre el ajuste polinómico de grado 31
disp('Un ajuste polinómico de grado 31 sobre 32 puntos puede resultar en un polinomio interpolante porque un polinomio de grado n puede ajustarse exactamente a n+1 puntos.');

% e) Ajustes polinómicos de grado 1 al 5
figure;
hold on;
xq = linspace(min(vec1), max(vec1), 30); % 30 puntos para graficar
for degree = 1:5
    p  = polyfit(vec1, vec2, degree);
    yq = polyval(p, xq);
    plot(xq, yq, 'DisplayName', ['Grado ' num2str(degree)]);
end
scatter(vec1, vec2, 'filled', 'r'); % Puntos originales
legend show;
title('Ajustes polinómicos de grado 1 a 5');
xlabel('Abscisas');
ylabel('Ordenadas');
hold off;

% g) Generación de conjuntos de datos
mesR   = [1 2 3 4 5 6 7 10 15 20 25 30 35 40 45 50 60 91 122 153 183 214 244 275 306 334 365];
PesoR  = [79 132 88 98 103 74 87 81 128 90 173 143 134 258 345 474 795 2262 5929 9309 14392 9745 5726 11765 4975 3168 16056];

mesLe  = [1 2 3 4 5 6 7 10 15 20 25 30 35 40 45 50 60 91 122 153 183 214 244 275 306 334 365];
PesoLe = [79 132 88 98 103 74 87 81 128 90 173 143 134 258 345 474 795 2262 5929 9309 14392 9745 5726 11765 4975 3168 16056];

mesLu  = [1 2 3 4 5 6 7 10 15 20 25 30 35 40 45 50 60 91 122 153 183 214 244 275 306 334 365];
PesoLu = [79 132 88 98 103 74 87 81 128 90 173 143 134 258 345 474 795 2262 5929 9309 14392 9745 5726 11765 4975 3168 16056];

% Ajustes y cálculo de errores cuadráticos medios
for i = 1:3
    if i == 1
        x = mesR;  y = PesoR;
    elseif i == 2
        x = mesLe; y = PesoLe;
    else
        x = mesLu; y = PesoLu;
    end
    
    for degree = 1:5
        p   = polyfit(x, y, degree);
        mse = calcular_error_cuadratico_medio(p, x, y);
        disp(['Error cuadrático medio para conjunto ' num2str(i) ' y grado ' num2str(degree) ': ' num2str(mse)]);
    end
end

% Análisis de la pandemia COVID-19
dias          = [1 2 3 4 5 6 7 10 15 20 25 30 35 40 45 50 60 91 122 153 183 214 244 275 306 334 365];
casos_nuevos  = [79 132 88 98 103 74 87 81 128 90 173 143 134 258 345 474 795 2262 5929 9309 14392 9745 5726 11765 4975 3168 16056];
casos_totales = [1133 1265 1353 1451 1554 1628 1715 1975 2571 3031 3780 4428 5020 6034 7479 9283 16214 64530 191302 441735 751001 1166924 1257227 1613928 1927239 2107365 2348821];

% Ajuste exponencial
log_casos_totales = log(casos_totales);
p_exp             = polyfit(dias, log_casos_totales, 1); % Ajuste lineal en el logaritmo
a                 = exp(p_exp(2)); % Coeficiente a
b                 = p_exp(1); % Coeficiente b

% Generar valores ajustados
y_exp = a * exp(b * dias);

% Graficar resultados
figure;
hold on;
scatter(dias, casos_totales, 'filled', 'r', 'DisplayName', 'Casos Totales');
plot(dias, y_exp, 'b-', 'DisplayName', 'Ajuste Exponencial');
title('Ajuste Exponencial a los Casos Totales de COVID-19');
xlabel('Días');
ylabel('Casos Totales');
legend show;
hold off;

% Análisis de la validez del modelo
mse_exp = mean((casos_totales - y_exp).^2);
disp(['Error cuadrático medio del ajuste exponencial: ', num2str(mse_exp)]);

% Evaluar el momento en que la hipótesis deja de cumplirse
% Se puede observar el crecimiento de los casos y determinar visualmente
% o mediante análisis estadístico en qué punto el modelo deja de ser válido.

% f) Función para calcular el error cuadrático medio
function mse = calcular_error_cuadratico_medio(coefs, x, y)
    y_pred = polyval(coefs, x);
    mse    = mean((y - y_pred).^2);
end

% b) Polinomio de interpolación de Newton
function coeffs = newton_interpolation(x, y)
    n            = length(x);
    coeffs       = zeros(n, n);
    coeffs(:, 1) = y(:);
    
    for j = 2:n
        for i = 1:n-j+1
            coeffs(i, j) = (coeffs(i+1, j-1) - coeffs(i, j-1)) / (x(i+j-1) - x(i));
        end
    end
end