% Ejercicio 13-TP3 - Comparación de métodos de integración
% Borramos las variables previas y la ventana de comandos
clc; clear; close all;
% Datos de los pacientes
edades  = [65, 43, 80]; % Edad al emitir el diagnóstico
VL      = [60, 40, 30]; % Porcentaje de pérdida de visión
% Datos de presión intraocular
presion = {
    [25, 13; 40, 15; 50, 22; 60, 23; 65, 24], ... % Paciente A
    [25, 11; 40, 30; 41, 32; 42, 33; 43, 35], ... % Paciente B
    [25, 13; 40, 14; 50, 15; 60, 17; 80, 19]      % Paciente C
};
% Inicializar vectores para ln(VL) y las integrales
ln_VL               = log(VL);
integrales_gauss    = zeros(3, 1);
integrales_trapecio = zeros(3, 1);
integrales_simpson  = zeros(3, 1);
% Calcular la integral para cada paciente con los tres métodos
for i = 1:3
    [integrales_gauss(i), integrales_trapecio(i), integrales_simpson(i)] = ...
        calcular_integrales(presion{i}, edades(i));
end
% Ajustes lineales para los tres métodos
p_gauss    = polyfit(integrales_gauss, ln_VL, 1);
p_trapecio = polyfit(integrales_trapecio, ln_VL, 1);
p_simpson  = polyfit(integrales_simpson, ln_VL, 1);
% Extraer parámetros k y A
metodos   = {'Gauss', 'Trapecio', 'Simpson'};
k_valores = [p_gauss(1); p_trapecio(1); p_simpson(1)];
A_valores = [exp(p_gauss(2)); exp(p_trapecio(2)); exp(p_simpson(2))];
% Mostrar resultados en formato tabular
fprintf('%-10s %-15s %-15s\n', 'Método', 'k', 'A');
fprintf('%-10s %-15s %-15s\n', '------', '----------', '----------');
for m = 1:3
    fprintf('%-10s %-15.4f %-15.4f\n', metodos{m}, k_valores(m), A_valores(m));
end
% Visualizar los tres ajustes lineales
figure;
plot(integrales_gauss, ln_VL, 'o', 'MarkerFaceColor', 'b');
hold on;
x_min = min([integrales_gauss; integrales_trapecio; integrales_simpson]);
x_max = max([integrales_gauss; integrales_trapecio; integrales_simpson]);
x_fit = linspace(x_min, x_max, 100);
estilos = {'r-', 'g--', 'b-.'};
for m = 1:3
    p     = [k_valores(m), log(A_valores(m))];
    y_fit = p(1) * x_fit + p(2);
    plot(x_fit, y_fit, estilos{m}, 'LineWidth', 1.5);
end
xlabel('Integral (P-13)');
ylabel('ln(VL)');
title('Comparación de ajustes lineales para los tres métodos');
grid on;
legend('Datos', metodos{:}, 'Location', 'northwest');
% Funciones auxiliares
function [integral_gauss, integral_trapecio, integral_simpson] = calcular_integrales(P_data, edad_diagnostico)
    % Preprocesamiento de datos
    P_data_valid = preprocesar_datos(P_data, edad_diagnostico);  
    % Calcular con cada método
    integral_gauss    = integrar_gauss(P_data_valid);
    integral_trapecio = integrar_trapecio(P_data_valid);
    integral_simpson  = integrar_simpson(P_data_valid);
end
function P_data_valid = preprocesar_datos(P_data, edad_diagnostico)
    % Filtrar datos hasta la edad del diagnóstico
    valid_idx    = P_data(:,1) <= edad_diagnostico;
    P_data_valid = P_data(valid_idx, :);  
    % Si la última edad no es exactamente la edad del diagnóstico,
    % agregar un punto interpolado
    if P_data_valid(end, 1) < edad_diagnostico
        idx = find(P_data(:,1) <= edad_diagnostico, 1, 'last');
        if idx < size(P_data, 1)
            t1 = P_data(idx, 1);
            t2 = P_data(idx+1, 1);
            P1 = P_data(idx, 2);
            P2 = P_data(idx+1, 2);            
            % Interpolación lineal
            P_diag       = P1 + (P2 - P1) * (edad_diagnostico - t1) / (t2 - t1);
            P_data_valid = [P_data_valid; edad_diagnostico, P_diag];
        end
    end    
    % Ordenar por tiempo
    P_data_valid = sortrows(P_data_valid, 1);
end
function integral = integrar_gauss(P_data_valid)
    integral = 0;
    n        = size(P_data_valid, 1);  
    for j = 1:n-1
        a = P_data_valid(j, 1);
        b = P_data_valid(j+1, 1);
        % Cuadratura de Gauss de 2 puntos
        x1 = 0.5 * (b - a) * (-1/sqrt(3)) + 0.5 * (b + a);
        x2 = 0.5 * (b - a) * (1/sqrt(3))  + 0.5 * (b + a);
        P1 = interp1(P_data_valid(:,1), P_data_valid(:,2), x1, 'linear') - 13;
        P2 = interp1(P_data_valid(:,1), P_data_valid(:,2), x2, 'linear') - 13;
        integral = integral + 0.5 * (b - a) * (P1 + P2);
    end
end
function integral = integrar_trapecio(P_data_valid)
    integral = 0;
    n        = size(P_data_valid, 1);    
    for j = 1:n-1
        t1 = P_data_valid(j, 1);
        t2 = P_data_valid(j+1, 1);
        P1 = P_data_valid(j, 2) - 13;
        P2 = P_data_valid(j+1, 2) - 13;        
        integral = integral + (P1 + P2) / 2 * (t2 - t1);
    end
end
function integral = integrar_simpson(P_data_valid)
    n = size(P_data_valid, 1); 
    if n >= 3
        t = P_data_valid(:, 1);
        P_adj = P_data_valid(:, 2) - 13;
        integral = 0;        
        % Aplicar método de Simpson por segmentos
        for j = 1:2:n-2
            h        = (t(j+2) - t(j)) / 2;
            integral = integral + (h/3) * (P_adj(j) + 4*P_adj(j+1) + P_adj(j+2));
        end        
        % Segmento final (si es necesario)
        if mod(n, 2) == 0
            j        = n - 1;
            h        = t(j+1) - t(j);
            integral = integral + (h/2) * (P_adj(j) + P_adj(j+1));
        end
    else
        integral = integrar_trapecio(P_data_valid);
    end
end