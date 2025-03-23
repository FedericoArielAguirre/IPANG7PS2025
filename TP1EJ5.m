% Ejercicio 5-TP1 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Llamamos la funcion main
main()
function main()
    % Definir el rango de decimales a analizar
    decimals = 1:7; % Rango de análisis (1 a 7 decimales)
    
    % Preasignar memoria para resultados
    ops_single = zeros(1, length(decimals));
    ops_double = zeros(1, length(decimals));
    abs_errors_single = zeros(1, length(decimals));
    abs_errors_double = zeros(1, length(decimals));
    rel_errors_single = zeros(1, length(decimals));
    rel_errors_double = zeros(1, length(decimals));
    rel_errors_percent_single = zeros(1, length(decimals));
    rel_errors_percent_double = zeros(1, length(decimals));

    % Iterar sobre el rango de decimales
    for i = 1:length(decimals)
        n_terms = 10^decimals(i); % Número de términos según los decimales

        % Cálculo de π en precisión simple
        [pi_single, ops_single(i), abs_errors_single(i), rel_errors_single(i), rel_errors_percent_single(i), error_bound_single] = calculate_pi_single(n_terms);
        fprintf('Precisión Simple (Decimales: %d):\n', decimals(i));
        fprintf('Valor de π: %.7f\n', pi_single);
        fprintf('Operaciones: %d\n', ops_single(i));
        fprintf('Error Absoluto: %.7e\n', abs_errors_single(i));
        fprintf('Error Relativo: %.7e\n', rel_errors_single(i));
        fprintf('Error Relativo Porcentual: %.7f%%\n', rel_errors_percent_single(i));
        fprintf('Cota del Error: %.7e\n\n', error_bound_single);

        % Cálculo de π en precisión doble
        [pi_double, ops_double(i), abs_errors_double(i), rel_errors_double(i), rel_errors_percent_double(i), error_bound_double] = calculate_pi_double(n_terms);
        fprintf('Precisión Doble (Decimales: %d):\n', decimals(i));
        fprintf('Valor de π: %.15f\n', pi_double);
        fprintf('Operaciones: %d\n', ops_double(i));
        fprintf('Error Absoluto: %.15e\n', abs_errors_double(i));
        fprintf('Error Relativo: %.15e\n', rel_errors_double(i));
        fprintf('Error Relativo Porcentual: %.15f%%\n', rel_errors_percent_double(i));
        fprintf('Cota del Error: %.15e\n\n', error_bound_double);
    end

    % Gráficos mejorados
    %figure('Position', [100, 100, 1200, 800]); % Figura más grande
    figure();
    % Gráfico de operaciones (escala normal)
    subplot(2, 2, 1);
    plot(decimals, ops_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    hold on;
    plot(decimals, ops_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    title('Cantidad de Operaciones vs Decimales', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Cantidad de Operaciones', 'FontSize', 11);
    legend('Location', 'northwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Gráfico de error absoluto (escala logarítmica)
    subplot(2, 2, 2);
    semilogy(decimals, abs_errors_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    hold on;
    semilogy(decimals, abs_errors_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    title('Error Absoluto vs Decimales (Escala Log)', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Error Absoluto (Log)', 'FontSize', 11);
    legend('Location', 'southwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Gráfico de error relativo (escala logarítmica)
    subplot(2, 2, 3);
    semilogy(decimals, rel_errors_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    hold on;
    semilogy(decimals, rel_errors_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    title('Error Relativo vs Decimales (Escala Log)', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Error Relativo (Log)', 'FontSize', 11);
    legend('Location', 'southwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Gráfico de error relativo porcentual (escala logarítmica)
    subplot(2, 2, 4);
    semilogy(decimals, rel_errors_percent_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    hold on;
    semilogy(decimals, rel_errors_percent_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    title('Error Relativo Porcentual vs Decimales (Escala Log)', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Error Relativo Porcentual (%) (Log)', 'FontSize', 11);
    legend('Location', 'southwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Ajuste del espaciado entre los subplots
    set(gcf, 'Color', 'white');
    sgtitle('Comparación de Precisión Simple vs Doble', 'FontSize', 14);
    
    % Gráfica adicional para comparación directa
    figure('Position', [100, 100, 1200, 400]);
    
    % Error absoluto: simple vs doble (gráfico de barras)
    subplot(1, 3, 1);
    bar([abs_errors_single', abs_errors_double']);
    set(gca, 'YScale', 'log');
    title('Error Absoluto por Precisión', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Error Absoluto (Log)', 'FontSize', 11);
    xticklabels(cellstr(num2str(decimals')));
    legend('Simple', 'Doble', 'Location', 'southwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Error relativo: simple vs doble (gráfico de barras)
    subplot(1, 3, 2);
    bar([rel_errors_single', rel_errors_double']);
    set(gca, 'YScale', 'log');
    title('Error Relativo por Precisión', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Error Relativo (Log)', 'FontSize', 11);
    xticklabels(cellstr(num2str(decimals')));
    legend('Simple', 'Doble', 'Location', 'southwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Error relativo porcentual: simple vs doble (gráfico de barras)
    subplot(1, 3, 3);
    bar([rel_errors_percent_single', rel_errors_percent_double']);
    set(gca, 'YScale', 'log');
    title('Error Relativo % por Precisión', 'FontSize', 12);
    xlabel('Número de Decimales', 'FontSize', 11);
    ylabel('Error Relativo % (Log)', 'FontSize', 11);
    xticklabels(cellstr(num2str(decimals')));
    legend('Simple', 'Doble', 'Location', 'southwest', 'FontSize', 10);
    grid on;
    set(gca, 'FontSize', 10);
    
    % Ajuste del espaciado entre los subplots
    set(gcf, 'Color', 'white');
    sgtitle('Comparación de Errores: Precisión Simple vs Doble', 'FontSize', 14);
end

function [pi_value, operations, abs_error, rel_error, rel_error_percent, error_bound] = calculate_pi_single(n)
    % Inicialización
    pi_value   = single(0);
    operations = 0;

    % Cálculo de π usando la serie de Leibniz
    for k = 0:n-1
        pi_value   = pi_value + single((-1)^k / (2*k + 1));
        operations = operations + 1; % Contar la operación
    end
    pi_value = pi_value * 4; % Multiplicar por 4

    % Cálculo de errores
    true_pi           = single(pi); % Valor verdadero de π en precisión simple
    abs_error         = abs(true_pi - pi_value);
    rel_error         = abs_error / abs(true_pi);
    rel_error_percent = rel_error * 100; % Convertir a porcentaje
    error_bound       = single(4 / (2*n + 1)); % Cota del error

end

function [pi_value, operations, abs_error, rel_error, rel_error_percent, error_bound] = calculate_pi_double(n)
    % Inicialización
    pi_value   = 0;
    operations = 0;

    % Cálculo de π usando la serie de Leibniz
    for k = 0:n-1
        pi_value   = pi_value + (-1)^k / (2*k + 1);
        operations = operations + 1; % Contar la operación
    end
    pi_value = pi_value * 4; % Multiplicar por 4

    % Cálculo de errores
    true_pi           = pi; % Valor verdadero de π en precisión doble
    abs_error         = abs(true_pi - pi_value);
    rel_error         = abs_error / true_pi;
    rel_error_percent = rel_error * 100; % Convertir a porcentaje
    error_bound       = 4 / (2*n + 1); % Cota del error
end