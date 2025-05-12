% Ejercicio 4-TP3 Version 2
% Implementación de Métodos de Integración Numérica
% Implementa los métodos de Gauss, Trapecio y Simpson con visualización
% Limpiar espacio de trabajo y ventana de comandos
clc; clear; close all;
% Definir los puntos de datos
X = [0, 0.5, 1];   % Puntos en el eje x
Y = [0, 0.25, 1];  % Valores de la función en esos puntos (ej., f(x) = x^2)
% Crear una interpolación polinómica para la gráfica
x_fine = linspace(min(X), max(X), 100);
n      = length(X);
grado  = n - 1;
p      = polyfit(X, Y, grado);
y_fine = polyval(p, x_fine);
% Calcular integrales usando diferentes métodos
gauss_result   = calculate_integral(X, Y, 'gauss');
trapz_result   = calculate_integral(X, Y, 'trapezoid');
simpson_result = calculate_integral(X, Y, 'simpson');
% Mostrar los resultados
fprintf('Resultados de la integración:\n');
fprintf('Método de Gauss: %.6f\n',     gauss_result);
fprintf('Método del Trapecio: %.6f\n', trapz_result);
fprintf('Método de Simpson: %.6f\n', simpson_result);
% Crear solución analítica exacta para comparación (para este ejemplo, asumiendo f(x) = x^2)
% La integral analítica de x^2 de 0 a 1 es 1/3
analytical_result = 1/3;
fprintf('Resultado analítico (si f(x) = x^2): %.6f\n', analytical_result);
% Graficar la función y visualizar los métodos de integración
visualize_integration(X, Y, x_fine, y_fine, p);
function result = calculate_integral(X, Y, method)
    % Función para calcular la integral usando el método especificado
    % Calcular los coeficientes de la interpolación polinómica
    n     = length(X);
    grado = n - 1;
    p     = polyfit(X, Y, grado);
    % Definir los límites de integración
    lim_inf = min(X);
    lim_sup = max(X);
    % Elegir el método de integración
    switch lower(method)
        case 'gauss'
            % Para Gauss, estimamos el número de puntos requeridos
            n_puntos = ceil((grado + 1) / 2);
            if n_puntos > 6
                fprintf('Error: Se requieren más de 6 puntos de Gauss, lo cual no está soportado.\n');
                result = NaN;
                return;
            end
            result = gauss_integration(@(x) polyval(p, x), lim_inf, lim_sup, n_puntos);
        case 'trapezoid'
            % Implementar el método del trapecio
            % Para demostración, usar 20 subintervalos
            num_intervals = 20;
            result = trapezoid_integration(@(x) polyval(p, x), lim_inf, lim_sup, num_intervals);
        case 'simpson'
            % Implementar el método de Simpson
            % Para demostración, usar 20 subintervalos (debe ser par)
            num_intervals = 20;
            result        = simpson_integration(@(x) polyval(p, x), lim_inf, lim_sup, num_intervals);
           otherwise
            error('Método de integración desconocido. Use "gauss", "trapezoid", o "simpson".');
    end
end
function result = gauss_integration(func, lim_inf, lim_sup, n_puntos)
    % Función para calcular la integral usando la cuadratura de Gauss
    % Definir los pesos y las posiciones de los puntos de Gauss
    switch n_puntos
        case 2
            w = [1, 1];                    % Pesos
            z = [0.5773502, -0.5773502];   % Raíces
        case 3
            w = [0.5555555555555556, 0.8888888888888888, 0.5555555555555556]; % Pesos
            z = [0.7745966692414834, 0, -0.7745966692414834];                % Raíces
        case 4
            w = [0.3478548451374539, 0.6521451548625461, 0.6521451548625461, 0.3478548451374539];   % Pesos
            z = [0.8611363115940526, 0.3399810435848563, -0.3399810435848563, -0.8611363115940526]; % Raíces
        case 5
            w = [0.2369268850561891, 0.4786286704993665, 0.5688888888888889, 0.4786286704993665, 0.2369268850561891]; % Pesos
            z = [0.9061798459386639, 0.5384693101056831, 0, -0.5384693101056831, -0.9061798459386639];               % Raíces
        case 6
            w = [0.1713244923791703, 0.3607615730481386, 0.4679139345726910, 0.4679139345726910, 0.3607615730481386, 0.1713244923791703];     % Pesos
            z = [0.9324695142031521, 0.6612093864662645, 0.2386191860831969, -0.2386191860831969, -0.6612093864662645, -0.9324695142031521]; % Raíces
        otherwise
            error('Número de puntos inválido. Debe estar entre 2 y 6.');
    end
    % Cambiar el intervalo [lim_inf, lim_sup] a [-1, 1]
    % y calcular la integral
    result = 0;
    for i = 1:n_puntos
        % Transformar las raíces de Gauss al intervalo [lim_inf, lim_sup]
        x_i = 0.5 * (lim_sup - lim_inf) * z(i) + 0.5 * (lim_sup + lim_inf);
        result = result + w(i) * func(x_i);
    end 
    % Escalar el resultado por el ancho del intervalo
    result = 0.5 * (lim_sup - lim_inf) * result;
end
function result = trapezoid_integration(func, lim_inf, lim_sup, num_intervals)
    % Función para calcular la integral usando la regla del Trapecio
    % Calcular el tamaño del paso
    h = (lim_sup - lim_inf) / num_intervals;
    % Inicializar la suma
    result = func(lim_inf)/2 + func(lim_sup)/2;
    % Sumar los puntos internos
    for i = 1:num_intervals-1
        x_i    = lim_inf + i*h;
        result = result + func(x_i);
    end 
    % Multiplicar por el tamaño del paso
    result = h * result;
end
function result = simpson_integration(func, lim_inf, lim_sup, num_intervals)
    % Función para calcular la integral usando la regla de Simpson
    % Nota: num_intervals debe ser par
    if mod(num_intervals, 2) ~= 0
        error('El número de intervalos debe ser par para la regla de Simpson.');
    end
    % Calcular el tamaño del paso
    h = (lim_sup - lim_inf) / num_intervals;  
    % Inicializar la suma con el primer y último punto
    result = func(lim_inf) + func(lim_sup);
    % Sumar los puntos con índice par (multiplicados por 2)
    for i = 2:2:num_intervals
        x_i    = lim_inf + i*h;
        result = result + 2*func(x_i);
    end
    % Sumar los puntos con índice impar (multiplicados por 4)
    for i = 1:2:num_intervals-1
        x_i    = lim_inf + i*h;
        result = result + 4*func(x_i);
    end 
    % Multiplicar por h/3
    result = (h/3) * result;
end
function visualize_integration(X, Y, x_fine, y_fine, p)
    % Función para visualizar los métodos de integración
    % Crear figura principal
    figure;
    % Subgráfico 1: Función original e interpolación polinómica
    subplot(2, 2, 1);
    plot(x_fine, y_fine, 'b-', 'LineWidth', 2);
    hold on;
    plot(X, Y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    title('Función y Puntos de Interpolación');
    xlabel('x');
    ylabel('f(x)');
    grid on;
    legend('Función Interpolada', 'Puntos de Datos', 'Location', 'northwest');
    % Subgráfico 2: Visualización de la Integración de Gauss
    subplot(2, 2, 2);
    plot(x_fine, y_fine, 'b-', 'LineWidth', 2);
    hold on;    
    % Para la visualización, mostrar puntos de Gauss para la regla de 3 puntos
    lim_inf  = min(X);
    lim_sup  = max(X);
    n_puntos = 3;
    % Puntos y pesos de Gauss para la regla de 3 puntos
    w = [0.5555555555555556, 0.8888888888888888, 0.5555555555555556]; % Pesos
    z = [0.7745966692414834, 0, -0.7745966692414834];                 % Raíces
    % Graficar puntos de Gauss
    for i = 1:n_puntos
        x_i = 0.5 * (lim_sup - lim_inf) * z(i) + 0.5 * (lim_sup + lim_inf);
        y_i = polyval(p, x_i);
        % Graficar punto y línea vertical
        plot(x_i, y_i, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
        plot([x_i, x_i], [0, y_i], 'g--', 'LineWidth', 1.5); 
        % Anotar peso
        text(x_i, y_i + 0.05, ['w = ', num2str(w(i), '%.2f')], 'HorizontalAlignment', 'center');
    end
    % Rellenar el área bajo la curva
    fill([x_fine, fliplr(x_fine)], [polyval(p, x_fine), zeros(size(x_fine))], 'g', 'FaceAlpha', 0.2);
    title('Integración de Gauss');
    xlabel('x');
    ylabel('f(x)');
    grid on;
    % Subgráfico 3: Visualización de la Regla del Trapecio
    subplot(2, 2, 3);
    plot(x_fine, y_fine, 'b-', 'LineWidth', 2);
    hold on;
    % Para la visualización, usar menos intervalos que en el cálculo
    num_intervals = 6;
    h             = (lim_sup - lim_inf) / num_intervals;
    % Graficar trapecios
    for i = 0:num_intervals-1
        x_left  = lim_inf + i*h;
        x_right = lim_inf + (i+1)*h;
        y_left  = polyval(p, x_left);
        y_right = polyval(p, x_right);
        % Graficar trapecio
        fill([x_left, x_right, x_right, x_left], [0, 0, y_right, y_left], 'r', 'FaceAlpha', 0.2); 
        % Graficar puntos y líneas verticales
        plot(x_left, y_left, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        plot(x_right, y_right, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
        plot([x_left, x_left], [0, y_left], 'r--', 'LineWidth', 1);
        plot([x_right, x_right], [0, y_right], 'r--', 'LineWidth', 1);
    end
    title('Integración por Trapecios');
    xlabel('x');
    ylabel('f(x)');
    grid on;
    % Subgráfico 4: Visualización de la Regla de Simpson
    subplot(2, 2, 4);
    plot(x_fine, y_fine, 'b-', 'LineWidth', 2);
    hold on;
    % Para la visualización, usar menos intervalos que en el cálculo
    num_intervals = 6;  % Debe ser par
    h = (lim_sup - lim_inf) / num_intervals;
    % Graficar las parábolas de Simpson
    for i = 0:2:num_intervals-1
        x_left  = lim_inf + i*h;
        x_mid   = lim_inf + (i+1)*h;
        x_right = lim_inf + (i+2)*h;
        y_left  = polyval(p, x_left);
        y_mid   = polyval(p, x_mid);
        y_right = polyval(p, x_right);
        % Crear puntos más finos para la parábola
        x_parabola = linspace(x_left, x_right, 50);
        % Calcular los coeficientes de la parábola
        p_simpson  = lagrange_interpolation([x_left, x_mid, x_right], [y_left, y_mid, y_right]);
        y_parabola = polyval(p_simpson, x_parabola);
        % Rellenar el área bajo la parábola
        fill([x_parabola, fliplr(x_parabola)], [y_parabola, zeros(size(y_parabola))], 'c', 'FaceAlpha', 0.2); 
        % Graficar puntos
        plot(x_left, y_left, 'co', 'MarkerSize', 6, 'MarkerFaceColor', 'c');
        plot(x_mid, y_mid, 'co', 'MarkerSize', 6, 'MarkerFaceColor', 'c');
        plot(x_right, y_right, 'co', 'MarkerSize', 6, 'MarkerFaceColor', 'c');
    end
    title('Integración de Simpson');
    xlabel('x');
    ylabel('f(x)');
    grid on; 
    % Añadir un título principal a la figura
    sgtitle('Visualización de Métodos de Integración Numérica', 'FontSize', 14, 'FontWeight', 'bold');
end
function p = lagrange_interpolation(x, y)
    % Función para calcular los coeficientes del polinomio de interpolación de Lagrange
    % Esto se usa para la visualización de la regla de Simpson
    n = length(x);
    p = zeros(1, n);
    % Para 3 puntos, podemos calcular directamente los coeficientes cuadráticos
    if n == 3
        % Calcular los coeficientes cuadráticos a*x^2 + b*x + c
        % Usando el sistema de ecuaciones para tres puntos
        x1 = x(1); x2 = x(2); x3 = x(3);
        y1 = y(1); y2 = y(2); y3 = y(3);
        % Crear matriz del sistema
        A = [x1^2, x1, 1;
             x2^2, x2, 1;
             x3^2, x3, 1];
        % Lado derecho
        b = [y1; y2; y3];
        % Resolver para los coeficientes
        coeff = A \ b;
        % Devolver en formato polinómico (potencia más alta primero)
        p = coeff';
    else
        % Para el caso general (no necesario en esta función específica pero bueno tenerlo)
        p = polyfit(x, y, n-1);
    end
end