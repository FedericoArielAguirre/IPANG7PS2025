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
    
    % Filtrar datos hasta la edad del diagnóstico
    valid_idx = P_data(:,1) <= edad_diagnostico;
    P_data_valid = P_data(valid_idx, :);    
    % Si la última edad no es exactamente la edad del diagnóstico,
    % agregar un punto interpolado en la edad del diagnóstico
    if P_data_valid(end, 1) < edad_diagnostico
        % Encontrar los puntos para interpolar
        idx = find(P_data(:,1) <= edad_diagnostico, 1, 'last');
        if idx < size(P_data, 1)
            t1 = P_data(idx, 1);
            t2 = P_data(idx+1, 1);
            P1 = P_data(idx, 2);
            P2 = P_data(idx+1, 2);
            % Interpolación lineal para obtener la presión en edad_diagnostico
            P_diag = P1 + (P2 - P1) * (edad_diagnostico - t1) / (t2 - t1);            
            % Agregar el punto interpolado
            P_data_valid = [P_data_valid; edad_diagnostico, P_diag];
        end
    end    
    % Si hay suficientes puntos, aplicar el método de Simpson
    n = size(P_data_valid, 1);    
    if n >= 3
        % Para aplicar el método de Simpson necesitamos un número impar de puntos
        % Si tenemos un número par, utilizamos la regla de Simpson en segmentos        
        integral_valor = 0;
        t = P_data_valid(:, 1);
        P = P_data_valid(:, 2);
        P_adj = P - 13; % Ajustar P restando 13        
        % Aplicar el método de Simpson por segmentos
        for j = 1:2:n-2
            h = (t(j+2) - t(j)) / 2;
            integral_valor = integral_valor + (h/3) * (P_adj(j) + 4*P_adj(j+1) + P_adj(j+2));
        end        
        % Si queda un segmento final con sólo dos puntos, usar regla del trapecio
        if mod(n, 2) == 0
            j = n - 1;
            h = t(j+1) - t(j);
            integral_valor = integral_valor + (h/2) * (P_adj(j) + P_adj(j+1));
        end
    else
        % Si hay menos de 3 puntos, usar regla del trapecio
        integral_valor = 0;
        for j = 1:n-1
            t1 = P_data_valid(j, 1);
            t2 = P_data_valid(j+1, 1);
            P1 = P_data_valid(j, 2) - 13; % Ajustar P restando 13
            P2 = P_data_valid(j+1, 2) - 13;            
            integral_valor = integral_valor + (P1 + P2) / 2 * (t2 - t1);
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
fprintf('Valor estimado de k por Simpson: %.4f\n', k);
fprintf('Valor estimado de A por Simpson: %.4f\n', A);
% Opcional: Visualizar el ajuste lineal
figure;
plot(integrales, ln_VL, 'o', 'MarkerFaceColor', 'b');
hold on;
x_fit = linspace(min(integrales), max(integrales), 100);
y_fit = p(1) * x_fit + p(2);
plot(x_fit, y_fit, 'r-');
xlabel('Integral (P-13)');
ylabel('ln(VL)');
title('Ajuste lineal para determinar k y A');
grid on;
legend('Datos', 'Ajuste lineal');