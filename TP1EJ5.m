% Ejercicio 5-TP1 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Llamamos la funcion main
main()
function main()
    % Definir el rango de decimales a analizar
    decimales = 1:8; % Rango de análisis (1 a 8 decimales)
    
    % Preasignar memoria para resultados
    ops_single = zeros(1, length(decimales));
    ops_double = zeros(1, length(decimales));
    abs_errors_single = zeros(1, length(decimales));
    abs_errors_double = zeros(1, length(decimales));
    rel_errors_single = zeros(1, length(decimales));
    rel_errors_double = zeros(1, length(decimales));
    rel_errors_percent_single = zeros(1, length(decimales));
    rel_errors_percent_double = zeros(1, length(decimales));

    % Iterar sobre el rango de decimales
    for i = 1:length(decimales)
        n_terms = 10^decimales(i); % Número de términos según los decimales

        % Cálculo de π en precisión simple
        [pi_single, ops_single(i), abs_errors_single(i), rel_errors_single(i), rel_errors_percent_single(i), error_bound_single] = calculate_pi_single(n_terms);
        fprintf('Precisión Simple (Decimales: %d):\n', decimales(i));
        fprintf('Valor de π: %.7f\n', pi_single);
        fprintf('Operaciones: %d\n', ops_single(i));
        fprintf('Error Absoluto: %.7e\n', abs_errors_single(i));
        fprintf('Error Relativo: %.7e\n', rel_errors_single(i));
        fprintf('Error Relativo Porcentual: %.7f%%\n', rel_errors_percent_single(i));
        fprintf('Cota del Error: %.7e\n\n', error_bound_single);

        % Cálculo de π en precisión doble
        [pi_double, ops_double(i), abs_errors_double(i), rel_errors_double(i), rel_errors_percent_double(i), error_bound_double] = calculate_pi_double(n_terms);
        fprintf('Precisión Doble (Decimales: %d):\n', decimales(i));
        fprintf('Valor de π: %.15f\n', pi_double);
        fprintf('Operaciones: %d\n', ops_double(i));
        fprintf('Error Absoluto: %.15e\n', abs_errors_double(i));
        fprintf('Error Relativo: %.15e\n', rel_errors_double(i));
        fprintf('Error Relativo Porcentual: %.15f%%\n', rel_errors_percent_double(i));
        fprintf('Cota del Error: %.15e\n\n', error_bound_double);
    end

    % Gráficos
    %figure('Position', [100, 100, 1200, 800]); % Figura más grande
    figure();
    % Gráfico de operaciones (escala normal)
    subplot(2, 2, 1);
    
    % Gráfico con una línea continua, marcadores en forma de cuadrados, grosor y tamaño ajustados,
    % y prepara la leyenda para identificar la serie como "Simple".
    plot(decimales, ops_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    
    % Mantengo en memoria
    hold on;

    % Gráfico con una línea continua, marcadores en forma de cuadrados, grosor y tamaño ajustados, 
    % y prepara la etiqueta para identificar la serie como "Doble".
    plot(decimales, ops_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    
    % Agrego titulo
    title('Cantidad de Operaciones vs Decimales', 'FontSize', 12);
    
    % Agrego etiqueta del eje x
    xlabel('Número de Decimales', 'FontSize', 11);

    % Agrego etiqueta del eje y
    ylabel('Cantidad de Operaciones', 'FontSize', 11);
    
    % Agrego mensaje al cuadro
    legend('Location', 'northwest', 'FontSize', 10);
    
    % Activo la grilla
    grid on;
    
    % Ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Gráfico de error absoluto (escala logarítmica)
    subplot(2, 2, 2);

    % gráfico en el que los valores del eje y están en escala logarítmica. Se utiliza una línea continua con 
    % marcadores circulares para representar los puntos, se ajustan el grosor de la línea y el tamaño de los marcadores,
    % y se establece un nombre ("Simple") para esta serie
    semilogy(decimales, abs_errors_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    
    % Mantengo en memoria
    hold on;
    
    %gráfico con escala logarítmica en el eje y, utiliza una línea continua
    %con marcadores cuadrados, ajusta el grosor de la línea y el tamaño de
    %los marcadores, y asigna un nombre ("Doble") para la etiqueta
    semilogy(decimales, abs_errors_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    
    % Agrego el titulo
    title('Error Absoluto vs Decimales (Escala Log)', 'FontSize', 12);
    
    % Agrego etiqueta del eje x
    xlabel('Número de Decimales', 'FontSize', 11);
    
    % Agrego etiqueta del eje y
    ylabel('Error Absoluto (Log)', 'FontSize', 11);

    % Agrego la etiqueta
    legend('Location', 'southwest', 'FontSize', 10);
    
    % Activo la grilla
    grid on;

    % Ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Gráfico de error relativo (escala logarítmica)
    subplot(2, 2, 3);

    % Gráfico con una escala logarítmica en el eje y, utiliza una línea continua con marcadores cuadrados
    % ajusta el grosor y tamaño de los marcadores, y prepara la etiqueta para identificar esta serie como "Simple".
    semilogy(decimales, rel_errors_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    
    % Mantengo en memoria
    hold on;
    
    % Gráfico con una escala logarítmica en el eje y, utiliza una línea continua con marcadores cuadrados
    % ajusta el grosor y tamaño de los marcadores, y prepara la leyenda para identificar esta serie como "Doble".
    semilogy(decimales, rel_errors_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    
    % Agrego el titulo
    title('Error Relativo vs Decimales (Escala Log)', 'FontSize', 12);
    
    % Agrego etiqueta del eje x
    xlabel('Número de Decimales', 'FontSize', 11);
    
    % Agrego etiqueta del eje y
    ylabel('Error Relativo (Log)', 'FontSize', 11);
    
    % Agrego etiqueta
    legend('Location', 'southwest', 'FontSize', 10);
    
    % Mantengo en memoria
    grid on;

    % ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Gráfico de error relativo porcentual (escala logarítmica)
    subplot(2, 2, 4);

    semilogy(decimales, rel_errors_percent_single, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Simple');
    
    % Mantengo en memoria
    hold on;
    semilogy(decimales, rel_errors_percent_double, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Doble');
    
    % Agrego el titulo 
    title('Error Relativo Porcentual vs Decimales (Escala Log)', 'FontSize', 12);
    
    % Etiqueto el eje x
    xlabel('Número de Decimales', 'FontSize', 11);
    
    % Etiqueto el eje y
    ylabel('Error Relativo Porcentual (%) (Log)', 'FontSize', 11);
    
    % Agrego la etiqueta
    legend('Location', 'southwest', 'FontSize', 10);
    
    % Activo la grilla
    grid on;

    % Ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Ajuste del espaciado entre los subplots

    % Ajuste del fondo de la ventana grafica actual a blanco
    set(gcf, 'Color', 'white'); 

    % Agrego el titulo
    sgtitle('Comparación de Precisión Simple vs Doble', 'FontSize', 14);
    
    % Gráfica adicional para comparación directa
    figure('Position', [100, 100, 1200, 400]);
    
    % Error absoluto: simple vs doble (gráfico de barras)
    subplot(1, 3, 1);
    
    % gráfico de barras para visualizar las matrices
    bar([abs_errors_single', abs_errors_double']);
    
    % Transforma la escala del eje y a logarítmica
    set(gca, 'YScale', 'log');
    
    % Agrego el titulo 
    title('Error Absoluto por Precisión', 'FontSize', 12);
    
    % Agrego el titulo del eje x
    xlabel('Número de Decimales', 'FontSize', 11);
    
    % Agrego el titulo del eje x
    ylabel('Error Absoluto (Log)', 'FontSize', 11);

    % Toma la traspuesta de decimales, convierte a string
    % convierte a a arrgelos de celda, establecemos las etiquetas del eje x
    xticklabels(cellstr(num2str(decimales')));

    % agrega una leyenda con los nombres "Simple" y "Doble", 
    % la posiciona en la esquina inferior izquierda y ajusta el tamaño de la fuente a 10 puntos
    legend('Simple', 'Doble', 'Location', 'southwest', 'FontSize', 10);
    
    % Activo la grilla
    grid on;
    
    % Ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Error relativo: simple vs doble (gráfico de barras)
    subplot(1, 3, 2);
    
    % gráfico de barras para visualizar las matrices
    bar([rel_errors_single', rel_errors_double']);
    
    % Transforma la escala del eje y a logarítmica
    set(gca, 'YScale', 'log');
    
    % Agregamos el título     
    title('Error Relativo por Precisión', 'FontSize', 12);
    
    % Agrego el titulo del eje x
    xlabel('Número de Decimales', 'FontSize', 11);
    
    % Agrego el titulo del eje y
    ylabel('Error Relativo (Log)', 'FontSize', 11);

    % Toma la traspuesta de decimales, convierte a string
    % convierte a arreglos de celda, establecemos las etiquetas del eje x
    xticklabels(cellstr(num2str(decimales'))); 
    
    
    % Agrega una leyenda con los nombres "Simple" y "Doble", 
    % la posiciona en la esquina inferior izquierda y ajusta el tamaño de la fuente a 10 puntos
    legend('Simple', 'Doble', 'Location', 'southwest', 'FontSize', 10);
    
    % Activo la grilla
    grid on;

    % Ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Error relativo porcentual: simple vs doble (gráfico de barras)
    subplot(1, 3, 3);
    
    % gráfico de barras para visualizar las matrices
    bar([rel_errors_percent_single', rel_errors_percent_double']);
    
    % Transformamos la escala del eje y a logaritmica
    set(gca, 'YScale', 'log');
    
    % Agregamos el título
    title('Error Relativo % por Precisión', 'FontSize', 12);
    
    % Agrego el titulo del eje x
    xlabel('Número de Decimales', 'FontSize', 11);
    
    % Agrego el titulo del eje y
    ylabel('Error Relativo % (Log)', 'FontSize', 11);
    
    % Toma la traspuesta de decimales, convierte a string
    % convierte a arreglos de celda, establecemos las etiquetas del eje x
    xticklabels(cellstr(num2str(decimales')));
    
    % agrega una leyenda con los nombres "Simple" y "Doble",
    % la posiciona en la esquina inferior izquierda y ajusta el tamaño de la fuente a 10 puntos
    legend('Simple', 'Doble', 'Location', 'southwest', 'FontSize', 10);
    
    % Agrega la grilla
    grid on;

    % Ajusta la fuente de todo el texto en los ejes actuales a un tamaño de 10 puntos
    set(gca, 'FontSize', 10);
    
    % Ajuste del espaciado entre los subplots
    set(gcf, 'Color', 'white');
    % Agrega el titulo 
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
