% Ejercicio 14-TP3 - Métodos de integración numérica con visualización
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Cargar datos experimentales
[flujo, tiempo, A] = cargarDatos();
% Crear interpolación para evaluación continua
[x_fino, y_fino] = crearInterpolacion(tiempo, flujo);
% Calcular integrales usando diferentes métodos
Q_trapecio = calcularTrapecio(tiempo, flujo);
Q_simpson  = calcularSimpsonRobusto(tiempo, flujo);
Q_gauss    = calcularGauss(tiempo, flujo);
% Calcular la cantidad total de insulina distribuida para cada método
Q_total_trapecio = Q_trapecio * A;% mg
Q_total_simpson  = Q_simpson  * A;% mg
Q_total_gauss    = Q_gauss    * A;% mg   
% Mostrar resultados
mostrarResultados(Q_total_trapecio, Q_total_simpson, Q_total_gauss);
% Visualizar datos y métodos
graficarDatosOriginales(tiempo, flujo, x_fino, y_fino);
graficarComparacionMetodos(Q_total_trapecio, Q_total_simpson, Q_total_gauss);
graficarVisualizacionMetodos(tiempo, flujo, x_fino, y_fino);
function [flujo, tiempo, A] = cargarDatos()
    % Datos de flujo y tiempo
    flujo  = [15, 14, 12, 11, 9, 8, 5, 2.5, 2, 1]; % Flujo en mg/cm²/h
    tiempo = [0, 1, 2, 3, 4, 5, 10, 15, 20, 24];   % Tiempo en horas   
    A      = 12;                                   % Área del parche en cm²
end
function [x_fino, y_fino] = crearInterpolacion(tiempo, flujo)
    % Crear una interpolación de la función para evaluarla en cualquier punto
    x_fino = linspace(min(tiempo), max(tiempo), 1000);
    y_fino = interp1(tiempo, flujo, x_fino, 'spline');
end
function Q_trapecio = calcularTrapecio(tiempo, flujo)
    % Implementación del método del trapecio
    Q_trapecio = 0; % Inicializar la cantidad total de insulina
    for i = 1:length(tiempo)-1
        % Aplicar la regla del trapecio
        Q_trapecio = Q_trapecio + (flujo(i) + flujo(i+1)) / 2 * (tiempo(i+1) - tiempo(i));
    end
end
function Q_simpson = calcularSimpson(tiempo, flujo)
    % Implementación del método de Simpson para datos irregulares
    Q_simpson = 0; i = 1; 
    while i <= length(tiempo)-2
        h1 = tiempo(i+1) - tiempo(i);
        h2 = tiempo(i+2) - tiempo(i+1);        
        % Si los puntos están equiespaciados, podemos usar Simpson
        if abs(h1 - h2) < 1e-10
            % Simpson 1/3
            Q_simpson = Q_simpson + (h1/3) * (flujo(i) + 4*flujo(i+1) + flujo(i+2));
            % Avanzamos un punto extra ya que Simpson usa 3 puntos
            i = i + 2;
        else
            % Si no son equiespaciados, usamos trapecio para este segmento
            Q_simpson = Q_simpson + (flujo(i) + flujo(i+1)) / 2 * h1;
            i         = i + 1;
        end
    end
    % Verificar si falta calcular el último segmento
    if i == length(tiempo)-1
        h         = tiempo(end) - tiempo(end-1);
        Q_simpson = Q_simpson + (flujo(end-1) + flujo(end)) / 2 * h;
    end
end
function Q_simpson = calcularSimpsonRobusto(tiempo, flujo)
    % Versión más robusta de Simpson para datos no equiespaciados usando interpolación
    % Crear puntos equiespaciados para aplicar Simpson
    n_pts     = 1001; % Número impar de puntos para Simpson
    t_eq      = linspace(min(tiempo), max(tiempo), n_pts);
    f_eq      = interp1(tiempo, flujo, t_eq, 'spline'); 
    Q_simpson = 0;
    h         = (t_eq(end) - t_eq(1)) / (n_pts - 1);
    % Aplicar regla de Simpson 1/3 con los puntos equiespaciados
    for i = 1:2:n_pts-2
        Q_simpson = Q_simpson + (h/3) * (f_eq(i) + 4*f_eq(i+1) + f_eq(i+2));
    end
end
function Q_gauss = calcularGauss(tiempo, flujo)
    % Implementación del método de cuadratura gaussiana
    Q_gauss = 0;    
    % Puntos y pesos de la cuadratura gaussiana de 5 puntos en [-1,1]
    [x_gauss, w_gauss] = obtenerPuntosGauss();
    for i = 1:length(tiempo)-1
        a = tiempo(i);
        b = tiempo(i+1);
        % Transformación de los puntos de Gauss al intervalo [a,b]
        x_local = ((b-a)/2) * x_gauss + (a+b)/2;
        % Evaluar la función en los puntos de Gauss
        f_local = interp1(tiempo, flujo, x_local, 'spline');
        % Calcular la integral en este segmento
        Q_gauss = Q_gauss + ((b-a)/2) * sum(w_gauss .* f_local);
    end
end
function [x_gauss, w_gauss] = obtenerPuntosGauss()
    % Puntos y pesos de la cuadratura gaussiana de 5 puntos en [-1,1]
    x_gauss = [-0.9061798459, -0.5384693101, 0.0, 0.5384693101, 0.9061798459];
    w_gauss = [0.2369268851, 0.4786286705, 0.5688888889, 0.4786286705, 0.2369268851];
end
function mostrarResultados(Q_total_trapecio, Q_total_simpson, Q_total_gauss)
    % Mostrar resultados de los métodos
    fprintf('La cantidad total de insulina distribuida en 24 horas usando diferentes métodos:\n');
    fprintf('  - Método del Trapecio: %.1f mg\n', Q_total_trapecio);
    fprintf('  - Método de Simpson: %.1f mg\n', Q_total_simpson);
    fprintf('  - Método de Gauss: %.1f mg\n', Q_total_gauss);
end
function graficarDatosOriginales(tiempo, flujo, x_fino, y_fino)
    % Gráfico de los datos y área bajo la curva
    figure(1);
    hold on;    
    % Graficar puntos de datos originales
    plot(tiempo, flujo, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);
    % Graficar la curva interpolada
    plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5);
    % Rellenar el área bajo la curva
    fill([x_fino, x_fino(1)], [y_fino, 0], 'b', 'FaceAlpha', 0.2); 
    grid on;
    title('Flujo de Insulina vs Tiempo', 'FontSize', 14);
    xlabel('Tiempo (horas)', 'FontSize', 12);
    ylabel('Flujo (mg/cm²/h)', 'FontSize', 12);
    legend('Datos experimentales', 'Curva interpolada', 'Área bajo la curva');
end
function graficarComparacionMetodos(Q_total_trapecio, Q_total_simpson, Q_total_gauss)
    % Gráfico comparativo de los métodos numéricos
    figure(2);
    bar([Q_total_trapecio, Q_total_simpson, Q_total_gauss]);
    xticklabels({'Trapecio', 'Simpson', 'Gauss'});
    grid on;
    title('Comparación de Métodos de Integración Numérica', 'FontSize', 14);
    ylabel('Cantidad Total de Insulina (mg)', 'FontSize', 12); 
    % Añadir valores numéricos sobre las barras
    text(1, Q_total_trapecio + 1, sprintf('%.1f mg', Q_total_trapecio), 'HorizontalAlignment', 'center');
    text(2, Q_total_simpson + 1, sprintf('%.1f mg', Q_total_simpson), 'HorizontalAlignment', 'center');
    text(3, Q_total_gauss + 1, sprintf('%.1f mg', Q_total_gauss), 'HorizontalAlignment', 'center');
end
function graficarVisualizacionMetodos(tiempo, flujo, x_fino, y_fino)
    % Visualización adicional: Ilustración de cada método
    figure('Position', [100, 100, 1100, 500]);
    % 1. Trapecio
    subplot(1,3,1);
    visualizarTrapecio(tiempo, flujo);
    % 2. Simpson
    subplot(1,3,2);
    visualizarSimpson(tiempo, flujo, x_fino, y_fino);
    % 3. Gauss
    subplot(1,3,3);
    visualizarGauss(tiempo, flujo, x_fino, y_fino);
end
function visualizarTrapecio(tiempo, flujo)
    hold on;
    plot(tiempo, flujo, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
    plot(tiempo, flujo, 'b-', 'LineWidth', 1.5);    
    % Dibujar los trapecios
    for i = 1:length(tiempo)-1
        % Puntos del trapecio
        x_trap = [tiempo(i), tiempo(i+1), tiempo(i+1), tiempo(i)];
        y_trap = [0, 0, flujo(i+1), flujo(i)];
        fill(x_trap, y_trap, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r');
    end    
    title('Método del Trapecio', 'FontSize', 12);
    xlabel('Tiempo (horas)');
    ylabel('Flujo (mg/cm²/h)');
    grid on;
end
function visualizarSimpson(tiempo, flujo, x_fino, y_fino)
    hold on;
    plot(tiempo, flujo, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
    plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5);    
    % Crear puntos equiespaciados para visualizar Simpson
    n_pts = 1001; % Número impar de puntos para Simpson
    t_eq = linspace(min(tiempo), max(tiempo), n_pts);
    f_eq = interp1(tiempo, flujo, t_eq, 'spline');    
    % Visualizar segmentos Simpson (mostramos curvas parabólicas)
    for i = 1:3:length(t_eq)-2
        seg_x = t_eq(i:i+2);
        seg_y = f_eq(i:i+2);
        fill([seg_x, fliplr(seg_x)], [seg_y, zeros(1,3)], 'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    end    
    title('Método de Simpson', 'FontSize', 12);
    xlabel('Tiempo (horas)');
    ylabel('Flujo (mg/cm²/h)');
    grid on;
end
function visualizarGauss(tiempo, flujo, x_fino, y_fino)
    hold on;
    plot(tiempo, flujo, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
    plot(x_fino, y_fino, 'b-', 'LineWidth', 1.5);
    % Obtener puntos de Gauss
    [x_gauss, ~] = obtenerPuntosGauss();    
    % Visualizar puntos de Gauss en algunos intervalos
    for i = 1:length(tiempo)-1
        a = tiempo(i);
        b = tiempo(i+1);        
        % Transformación de los puntos de Gauss al intervalo [a,b]
        x_local = ((b-a)/2) * x_gauss + (a+b)/2;
        % Evaluar la función en los puntos de Gauss
        f_local = interp1(tiempo, flujo, x_local, 'spline');
        % Dibujar puntos de Gauss
        plot(x_local, f_local, 'r*', 'MarkerSize', 8);
        % Rellenar el área del intervalo
        x_fill = linspace(a, b, 50);
        y_fill = interp1(tiempo, flujo, x_fill, 'spline');
        fill([x_fill, fliplr(x_fill)], [y_fill, zeros(1,50)], 'm', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    end
    title('Método de Gauss', 'FontSize', 12);
    xlabel('Tiempo (horas)');
    ylabel('Flujo (mg/cm²/h)');
    grid on;
end