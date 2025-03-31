% Ejercicio 14-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos de flujo y tiempo
flujo   = [15, 14, 12, 11, 9, 8, 5, 2.5, 2, 1]; % Flujo en mg/cm²/h
tiempo  = [0, 1, 2, 3, 4, 5, 10, 15, 20, 24];   % Tiempo en horas

% Área del parche
A = 12; % cm²

% Calcular el área bajo la curva usando la regla del trapecio
Q_integral = 0; % Inicializar la cantidad total de insulina

for i = 1:length(tiempo)-1
    % Aplicar la regla del trapecio
    Q_integral = Q_integral + (flujo(i) + flujo(i+1)) / 2 * (tiempo(i+1) - tiempo(i));
end

% Calcular la cantidad total de insulina distribuida
Q_total = Q_integral * A; % mg

% Mostrar resultados
fprintf('La cantidad total de insulina distribuida en 24 horas es: %.4f mg\n', Q_total);