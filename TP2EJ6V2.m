% Ejercicio 6-TP2 Versión 2

% Borramos las variables previas y la ventana de comandos
clc;
clear;
close all;

% Definición de los puntos de datos para las tres curvas y sus derivadas en los extremos

% Curva 1
x1 = [1, 2, 5, 6, 7, 8, 10, 13, 17];
y1 = [3.0, 3.7, 3.9, 4.2, 5.7, 6.6, 7.1, 6.7, 4.5];
d1_start = 1.0;     % f'(x) en x = 1
d1_end = -0.67;     % f'(x) en x = 17

% Curva 2
x2 = [17, 20, 23, 24, 25, 27, 27.7];
y2 = [4.5, 7.0, 6.1, 5.6, 5.8, 5.2, 4.1];
d2_start = 3.0;     % f'(x) en x = 17
d2_end = -4.0;      % f'(x) en x = 27.7

% Curva 3
x3 = [27.7, 28, 29, 30];
y3 = [4.1, 4.3, 4.1, 3.0];
d3_start = 0.33;    % f'(x) en x = 27.7
d3_end = -1.5;      % f'(x) en x = 30

% a) Interpolación polinómica para cada curva
figure;
hold on;
grid on;
title('Interpolación Polinómica de la Curva');
xlabel('x');
ylabel('f(x)');

% Crear vectores densos x para evaluación
x1_denso = linspace(min(x1), max(x1), 100);
x2_denso = linspace(min(x2), max(x2), 100);
x3_denso = linspace(min(x3), max(x3), 100);

% Calcular interpolantes polinómicos para cada curva
p1 = polyfit(x1, y1, length(x1)-1);
p2 = polyfit(x2, y2, length(x2)-1);
p3 = polyfit(x3, y3, length(x3)-1);

% Evaluar polinomios en puntos densos
y1_poly = polyval(p1, x1_denso);
y2_poly = polyval(p2, x2_denso);
y3_poly = polyval(p3, x3_denso);

% Graficar puntos originales
plot(x1, y1, 'ro', 'MarkerSize', 8, 'DisplayName', 'Puntos Curva 1');
plot(x2, y2, 'go', 'MarkerSize', 8, 'DisplayName', 'Puntos Curva 2');
plot(x3, y3, 'bo', 'MarkerSize', 8, 'DisplayName', 'Puntos Curva 3');

% Graficar polinomios interpolantes
plot(x1_denso, y1_poly, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 1');
plot(x2_denso, y2_poly, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 2');
plot(x3_denso, y3_poly, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 3');

legend('show');

% b) Interpolación con Splines Cúbicos con condiciones de derivada
figure;
hold on;
grid on;
title('Interpolación con Splines Cúbicos de la Curva');
xlabel('x');
ylabel('f(x)');

% Función spline cúbica personalizada que incorpora condiciones de derivada
% Para Curva 1
x1_spline = [x1(1), x1, x1(end)];
y1_spline = [d1_start, y1, d1_end];
[~, unique_idx] = unique(x1_spline); % Obtener índices únicos
pp1 = spline(x1_spline(unique_idx), y1_spline(unique_idx));
y1_spline = ppval(pp1, x1_denso);

% Para Curva 2
x2_spline = [x2(1), x2, x2(end)];
y2_spline = [d2_start, y2, d2_end];
[~, unique_idx] = unique(x2_spline); % Obtener índices únicos
pp2 = spline(x2_spline(unique_idx), y2_spline(unique_idx));
y2_spline = ppval(pp2, x2_denso);

% Para Curva 3
x3_spline = [x3(1), x3, x3(end)];
y3_spline = [d3_start, y3, d3_end];
[~, unique_idx] = unique(x3_spline); % Obtener índices únicos
pp3 = spline(x3_spline(unique_idx), y3_spline(unique_idx));
y3_spline = ppval(pp3, x3_denso);

% Graficar puntos originales
plot(x1, y1, 'ro', 'MarkerSize', 8, 'DisplayName', 'Puntos Curva 1');
plot(x2, y2, 'go', 'MarkerSize', 8, 'DisplayName', 'Puntos Curva 2');
plot(x3, y3, 'bo', 'MarkerSize', 8, 'DisplayName', 'Puntos Curva 3');

% Graficar splines cúbicos
plot(x1_denso, y1_spline, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 1');
plot(x2_denso, y2_spline, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 2');
plot(x3_denso, y3_spline, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 3');

legend('show');

% c) Comparación de interpolación polinómica vs splines cúbicos
figure;

subplot(2,1,1);
hold on;
grid on;
title('Interpolación Polinómica');
xlabel('x');
ylabel('f(x)');
plot(x1_denso, y1_poly, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 1');
plot(x2_denso, y2_poly, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 2');
plot(x3_denso, y3_poly, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 3');
plot([x1, x2, x3], [y1, y2, y3], 'ko', 'MarkerSize', 6, 'DisplayName', 'Puntos de Datos');
legend('show');

subplot(2,1,2);
hold on;
grid on;
title('Interpolación con Splines Cúbicos');
xlabel('x');
ylabel('f(x)');
plot(x1_denso, y1_spline, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 1');
plot(x2_denso, y2_spline, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 2');
plot(x3_denso, y3_spline, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 3');
plot([x1, x2, x3], [y1, y2, y3], 'ko', 'MarkerSize', 6, 'DisplayName', 'Puntos de Datos');
legend('show');

% d) Mostrar el gráfico final
figure;
hold on;
grid on;
title('Comparación Final');
xlabel('x');
ylabel('f(x)');
plot(x1_denso, y1_poly, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 1');
plot(x2_denso, y2_poly, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 2');
plot(x3_denso, y3_poly, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Polinomio Curva 3');
plot(x1_denso, y1_spline, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 1');
plot(x2_denso, y2_spline, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 2');
plot(x3_denso, y3_spline, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Spline Curva 3');
legend('show');