% Ejercicio 13-TP3
% Borramos las variables previas y la ventana de comandos
clear; close all;
% Datos de los pacientes
edades  = [65, 43, 80]; % Edad al emitir el diagnóstico
VL      = [60, 40, 30]; % Porcentaje de pérdida de visión
% Datos de presión intraocular
presion = {
    [25, 13; 40, 15; 50, 22; 60, 23; 65, 24], ... % Paciente A
    [25, 11; 40, 30; 41, 32; 42, 33; 43, 35], ... % Paciente B
    [25, 13; 40, 14; 50, 15; 60, 17; 80, 19]      % Paciente C
};
% Inicializar vectores para ln(VL) y la integral
ln_VL      = log(VL);
integrales = zeros(3, 1);
% Calcular la integral para cada paciente
for i = 1:3
    edad_diagnostico = edades(i);
    P_data           = presion{i}; % Datos de presión del paciente
    % Calcular la integral de P - 13 desde 25 hasta la edad del paciente
    integral_valor = 0;
    for j = 1:size(P_data, 1)-1
        t1 = P_data(j, 1);
        t2 = P_data(j+1, 1);
        P1 = P_data(j, 2);
        P2 = P_data(j+1, 2);        
        % Calcular el área usando la regla del trapecio
        if t1 < edad_diagnostico
            if t2 > edad_diagnostico
                t2 = edad_diagnostico; % Limitar al tiempo de diagnóstico
            end
integral_valor = integral_valor + (P1 - 13 + P2 - 13) / 2 * (t2 - t1);
        end
    end
    integrales(i) = integral_valor; % Guardar el valor de la integral
end
% Ajuste lineal para encontrar k y A
% ln(VL) = ln(A) + k * integral
p    = polyfit(integrales, ln_VL, 1); % Ajuste lineal
k    = p(1);                          % Pendiente
ln_A = p(2);                          % Intersección
A    = exp(ln_A);                     % Calcular A
% Mostrar resultados
fprintf('Valor estimado de k por trapecios: %.4f\n', k);
fprintf('Valor estimado de A por trapecios: %.4f\n', A);