% Ejercicio 12-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos de tiempo y concentración
tiempo        = [5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35];                      % Tiempo en segundos
concentracion = [0, 0.1, 0.11, 0.4, 4.1, 9.1, 8, 4.2, 2.3, 1.1, 0.9, 1.75, 2.06, 2.25, 2.32, 2.43]; % Concentración en mg/L

% Cantidad de colorante inyectado
M = 5.6; % mg

% Inicializar el área
A = 0;

% Calcular el área bajo la curva usando la regla del trapecio
for i = 1:length(tiempo)-1
    % Aplicar la regla del trapecio
    A = A + (concentracion(i) + concentracion(i+1)) / 2 * (tiempo(i+1) - tiempo(i));
end

% Calcular el gasto cardíaco
C = (M / (A * 60)); % Gasto cardíaco en L/min

% Mostrar resultados
fprintf('El gasto cardíaco es: %.4f L/min\n', C);