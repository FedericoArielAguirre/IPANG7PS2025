% Ejercicio 12-TP3
% Borramos las variables previas y la ventana de comandos
clc; clear; close all;
% Datos de tiempo y concentración
tiempo        = [5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35];                      % Tiempo en segundos
concentracion = [0, 0.1, 0.11, 0.4, 4.1, 9.1, 8, 4.2, 2.3, 1.1, 0.9, 1.75, 2.06, 2.25, 2.32, 2.43]; % Concentración en mg/L
% Cantidad de colorante inyectado
M = 5.6; % mg
% Método 1: Regla del trapecio
A_trapecio = calcular_area_trapecio(tiempo, concentracion);
C_trapecio = calcular_gasto_cardiaco(M, A_trapecio);
% Método 2: Método DE Gauss
A_gauss = calcular_area_gauss(tiempo, concentracion);
C_gauss = calcular_gasto_cardiaco(M, A_gauss);
% Método 3: Regla de Simpson
A_simpson = calcular_area_simpson(tiempo, concentracion);
C_simpson = calcular_gasto_cardiaco(M, A_simpson);
% Mostrar resultados
fprintf('Gasto cardíaco (Trapecio): %.6f L/min\n', C_trapecio);
fprintf('Gasto cardíaco (Gauss):    %.6f L/min\n', C_gauss);
fprintf('Gasto cardíaco (Simpson):  %.6f L/min\n', C_simpson);
% Graficar los resultados
figure;
plot(tiempo, concentracion, 'o-', 'LineWidth', 1.5);
title('Curva de concentración vs tiempo');
xlabel('Tiempo (s)');
ylabel('Concentración (mg/L)');
grid on;
% Mostrar áreas en la figura
text(6, 8, sprintf('Área (Trapecio): %.4f', A_trapecio),'FontSize', 10);
text(6, 7, sprintf('Área (Gauss): %.4f',    A_gauss),   'FontSize', 10);
text(6, 6, sprintf('Área (Simpson): %.4f',  A_simpson), 'FontSize', 10);
% Funciones
function area = calcular_area_trapecio(x, y)
    % Calcular el área bajo la curva usando la regla del trapecio
    area = 0;
    for i = 1:length(x)-1
        % Aplicar la regla del trapecio
        area = area + (y(i) + y(i+1)) / 2 * (x(i+1) - x(i));
    end
end
function area = calcular_area_gauss(x, y)
    % Calcular el área bajo la curva usando el método de Gauss
    area = 0;
    % Pesos y puntos de Gauss para integración de orden 2
    w = [1, 1];
    p = [-1/sqrt(3), 1/sqrt(3)];
    for i = 1:length(x)-1
        a = x(i);
        b = x(i+1);
        % Transformación de coordenadas
        medio = (b + a) / 2;
        h     = (b - a) / 2;
        % Puntos de evaluación
        x_eval = medio + h * p;
        % Interpolar los valores de y en los puntos de evaluación
        y_eval = interp1(x, y, x_eval, 'linear', 'extrap');
        % Sumar la contribución del segmento
        area = area + h * sum(w .* y_eval);
    end
end
function area = calcular_area_simpson(x, y)
    % Calcular el área bajo la curva usando la regla de Simpson
    area = 0;
    % Si no tenemos suficientes puntos o tenemos un número par de intervalos
    % usamos Simpson compuesto
    for i = 1:length(x)-2
        if mod(i, 2) == 1 && i+2 <= length(x)
            h    = (x(i+2) - x(i)) / 2;
            area = area + (h/3) * (y(i) + 4*y(i+1) + y(i+2));
        end
    end    
    % Si queda un último intervalo sin integrar, usamos trapecios
    if mod(length(x), 2) == 0
        i    = length(x) - 1;
        area = area + (y(i) + y(i+1)) / 2 * (x(i+1) - x(i));
    end
end
function gasto_cardiaco = calcular_gasto_cardiaco(M, area)
    % Calcular el gasto cardíaco
    gasto_cardiaco = (M / (area * 60)); % Gasto cardíaco en L/min
end