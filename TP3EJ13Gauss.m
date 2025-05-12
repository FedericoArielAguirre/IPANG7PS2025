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
% Calcular la integral para cada paciente usando cuadratura de Gauss
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
    
    % Ordenar por tiempo para asegurar integración correcta
    P_data_valid = sortrows(P_data_valid, 1);
    
    % Aplicar cuadratura de Gauss a cada segmento entre puntos de datos
    integral_valor = 0;
    n = size(P_data_valid, 1);    
    for j = 1:n-1
        a = P_data_valid(j, 1);    % Límite inferior del intervalo
        b = P_data_valid(j+1, 1);  % Límite superior del intervalo        
        % Utilizamos cuadratura de Gauss de 2 puntos
        % Los puntos de Gauss-Legendre para n=2 son ±1/sqrt(3) en [-1,1]
        % Convertimos al intervalo [a,b]
        x1 = 0.5 * (b - a) * (-1/sqrt(3)) + 0.5 * (b + a);
        x2 = 0.5 * (b - a) * (1/sqrt(3)) + 0.5 * (b + a);        
        % Interpolar la presión en los puntos de Gauss
        P1 = interp1(P_data_valid(:,1), P_data_valid(:,2), x1, 'linear') - 13;
        P2 = interp1(P_data_valid(:,1), P_data_valid(:,2), x2, 'linear') - 13;       
        % Para Gauss-Legendre de 2 puntos, los pesos son [1, 1]
        % El valor de la integral en este segmento es:
        segmento_integral = 0.5 * (b - a) * (P1 + P2);        
        integral_valor = integral_valor + segmento_integral;
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
fprintf('Valor estimado de k por Gauss: %.4f\n', k);
fprintf('Valor estimado de A por Gauss: %.4f\n', A);
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
% Función para implementar cuadratura de Gauss más general (para uso futuro)
function integral = gauss_quadrature(func, a, b, n)
    % Aplicar la cuadratura de Gauss con n puntos al intervalo [a,b]
    % para la función definida por func    
    if n == 2
        % Puntos y pesos para Gauss-Legendre de 2 puntos
        x = [-1/sqrt(3), 1/sqrt(3)];
        w = [1, 1];
    elseif n == 3
        % Puntos y pesos para Gauss-Legendre de 3 puntos
        x = [-sqrt(3/5), 0, sqrt(3/5)];
        w = [5/9, 8/9, 5/9];
    elseif n == 4
        % Puntos y pesos para Gauss-Legendre de 4 puntos
        x = [-sqrt(3/7 + 2/7*sqrt(6/5)), -sqrt(3/7 - 2/7*sqrt(6/5)), ...
             sqrt(3/7 - 2/7*sqrt(6/5)), sqrt(3/7 + 2/7*sqrt(6/5))];
        w = [(18-sqrt(30))/36, (18+sqrt(30))/36, (18+sqrt(30))/36, (18-sqrt(30))/36];
    elseif n == 5
        % Puntos y pesos para Gauss-Legendre de 5 puntos
        x = [-sqrt(5+2*sqrt(10/7))/3, -sqrt(5-2*sqrt(10/7))/3, 0, ...
             sqrt(5-2*sqrt(10/7))/3, sqrt(5+2*sqrt(10/7))/3];
        w = [(322-13*sqrt(70))/900, (322+13*sqrt(70))/900, 128/225, ...
             (322+13*sqrt(70))/900, (322-13*sqrt(70))/900];
    else
        error('Solo se admiten órdenes 2, 3, 4 o 5 para la cuadratura de Gauss');
    end    
    % Transformar puntos de [-1,1] a [a,b]
    x_transformed = 0.5 * (b - a) * x + 0.5 * (b + a);    
    % Calcular la integral
    integral = 0;
    for i = 1:n
        integral = integral + w(i) * func(x_transformed(i));
    end    
    % Aplicar el factor de escala
    integral = 0.5 * (b - a) * integral;
end