% Primer Parcial 12-04-25 G7PS2025
% Borramos las variables previas y la ventana de comandos
clc; clear; close all;

% Parámetros físicos y de simulación
params = struct('h', 1.4, 'g', 9.81, 'v0', 8, 'coef_rest', 0.75, ...
                'dt', 0.01, 'x_pared', 12);

% Parte a) Simulación principal
[tiempo, pos_x, pos_y, vel_x, vel_y, tiempo_vuelo, altura_impacto, idx_rebotes] = simularPelota(params);

% Resultados principales
fprintf('Tiempo de vuelo: %.4f segundos\n'             ,tiempo_vuelo  );
fprintf('Altura de impacto con la pared: %.4f metros\n',altura_impacto);

% Parte b) Gráficas de velocidad y posición
plotGraficasB(tiempo, pos_x, vel_x, vel_y);

% Parte c) Ajuste de funciones para la trayectoria
plotTrayectoriaAjustada(pos_x, pos_y, idx_rebotes);

% Parte d) Análisis de error con coeficiente variable
analizarError(params);

% Parte e) Comparación de métodos de interpolación
compararInterpolaciones(params);

% Funciones
function [tiempo, pos_x, pos_y, vel_x, vel_y, tiempo_vuelo, altura_impacto, idx_rebotes] = simularPelota(params)
    % Extrae parámetros
    h         = params.h;g = params.g;
    v0        = params.v0;
    coef_rest = params.coef_rest;
    dt        = params.dt;
    x_pared   = params.x_pared;
    
    % Inicialización (como en el primer código)
    x = 0; vx = v0; t = 0;
    y = h; vy = 0 ;
       
    % Vectores para almacenar resultados
    tiempo      = t;
    pos_x       = x;
    pos_y       = y;
    vel_x       = vx;
    vel_y       = vy;
    idx_rebotes = [];
    
    % Límite de iteraciones para evitar bucles infinitos
    max_iter = 10000;
    iter = 0;
    
    % Primer bucle: hasta que toque el suelo por primera vez
    i = 1;
    while y > 0 && iter < max_iter
        x_prev = x;
        y_prev = y;
        
        % Actualización
        x = x + vx * dt;
        y = y + vy * dt + 1/2 * (-g) * dt^2;
        vy = vy + (-g) * dt;
        t = t + dt;
        
        % Guardar resultados
        i         = i + 1; pos_x(i)  = x; vel_x(i)  = vx;
        tiempo(i) = t;     pos_y(i)  = y; vel_y(i)  = vy;
        
        iter = iter + 1;
    end
    
    if iter >= max_iter
        disp('Se alcanzó el límite de iteraciones en el primer bucle.');
    end
    
    % Primer rebote
    v_ini = sqrt(vx^2 + vy^2);
    v_fin = sqrt(v_ini^2 * coef_rest);
    ang   = atan(vy / vx);
    vx    = v_fin * cos(ang);
    vy    = -v_fin * sin(ang);
    
    % Guardar índice del rebote
    idx_rebotes = [idx_rebotes, i];
    
    % Actualizar posición después del rebote
    x = x + vx * dt;
    y = y + vy * dt + 1/2 * (-g) * dt^2;
    t = t + dt;
    
    % Guardar resultados
    i         = i + 1; pos_x(i)  = x; vel_x(i)  = vx;
    tiempo(i) = t;     pos_y(i)  = y; vel_y(i)  = vy;
          
    % Asegurar que y sea positivo para iniciar el segundo bucle
    y = max(y, 1e-5);
    
    % Segundo bucle: hasta que toque el suelo por segunda vez
    iter = 0;
    while y > 0 && iter < max_iter
        % Actualización
        x  = x + vx * dt;
        y  = y + vy * dt + 1/2 * (-g) * dt^2;
        vy = vy + (-g) * dt;
        t  = t + dt;
        
        % Guardar resultados
        i         = i + 1; pos_x(i)  = x; vel_x(i)  = vx;
        tiempo(i) = t;     pos_y(i)  = y; vel_y(i)  = vy;
            
        iter      = iter + 1;
    end
    
    if iter >= max_iter
        disp('Se alcanzó el límite de iteraciones en el segundo bucle.');
    end
    
    % Segundo rebote
    v_ini = sqrt(vx^2 + vy^2);
    v_fin = sqrt(v_ini^2 * coef_rest);
    ang   = atan(vy / vx);
    vx    = v_fin * cos(ang);
    vy    = -v_fin * sin(ang);
    
    % Guardar índice del rebote
    idx_rebotes = [idx_rebotes, i];
    
    % Actualizar posición después del rebote
    x = x + vx * dt;
    y = y + vy * dt + 1/2 * (-g) * dt^2;
    t = t + dt;
    
    % Guardar resultados
    i         = i + 1; pos_x(i)  = x; vel_x(i)  = vx;
    tiempo(i) = t;     pos_y(i)  = y; vel_y(i)  = vy;
      
    % Asegurar que y sea positivo para iniciar el tercer bucle
    y = max(y, 1e-5);
    
    % Tercer bucle: hasta que toque la pared o el suelo
    iter = 0;
    while y > 0 && x < x_pared && iter < max_iter
        x_prev = x;
        y_prev = y;
        
        % Actualización
        x  = x + vx * dt;
        y  = y + vy * dt + 1/2 * (-g) * dt^2;
        vy = vy + (-g) * dt;
        t  = t + dt;
        
        % Guardar resultados
        i         = i + 1; pos_x(i)  = x; vel_x(i)  = vx; 
        tiempo(i) = t;     pos_y(i)  = y; vel_y(i)  = vy;  
        iter      = iter + 1;
        
        % Si toca el suelo nuevamente antes de la pared
        if y <= 0 && x < x_pared
            % Guardar índice del rebote
            idx_rebotes = [idx_rebotes, i];
            
            % Calcular el rebote
            v_ini = sqrt(vx^2 + vy^2);
            v_fin = sqrt(v_ini^2 * coef_rest);
            ang   = atan(vy / vx);
            vx    = v_fin * cos(ang);
            vy    = -v_fin * sin(ang);
            
            % Asegurar que y sea positivo
            y = max(y, 1e-5);
        end
    end
    
    if iter >= max_iter
        disp('Se alcanzó el límite de iteraciones en el tercer bucle.');
    end
    
    % Cálculo del impacto con la pared mediante interpolación lineal
    [tiempo_vuelo, altura_impacto] = calcularImpacto(tiempo, pos_x, pos_y, x_pared);
end

function [tiempo_vuelo, altura_impacto] = calcularImpacto(tiempo, pos_x, pos_y, x_pared)
    idx = find(pos_x >= x_pared, 1, 'first');
    if idx > 1
        factor         = (x_pared - pos_x(idx-1)) / (pos_x(idx) - pos_x(idx-1));
        altura_impacto = pos_y(idx-1) + factor * (pos_y(idx) - pos_y(idx-1));
        tiempo_vuelo   = tiempo(idx-1) + factor * (tiempo(idx) - tiempo(idx-1));
    else
        altura_impacto = pos_y(idx);
        tiempo_vuelo   = tiempo(idx);
    end
end

function plotGraficasB(tiempo, pos_x, vel_x, vel_y)
    figure(1);
    subplot(3,1,1);
    plot(tiempo, vel_y, 'b-');
    xlabel('Tiempo (s)'); ylabel('Velocidad Vertical (m/s)');
    title('Velocidad Vertical vs Tiempo'); grid on;
    
    subplot(3,1,2);
    plot(tiempo, vel_x, 'r-');
    xlabel('Tiempo (s)'); ylabel('Velocidad Horizontal (m/s)');
    title('Velocidad Horizontal vs Tiempo'); grid on;
    
    subplot(3,1,3);
    plot(tiempo, pos_x, 'g-');
    xlabel('Tiempo (s)'); ylabel('Distancia Horizontal (m)');
    title('Distancia Horizontal vs Tiempo'); grid on;
end

function plotTrayectoriaAjustada(pos_x, pos_y, idx_rebotes)
    figure(2);
    plot(pos_x, pos_y, 'b-');
    xlabel('Distancia Horizontal (m)'); ylabel('Altura (m)');
    title('Trayectoria de la Pelota con Ajustes por Tramos'); grid on; hold on;
    
    % Definir los tramos usando idx_rebotes, incluyendo inicio y final
    idx_tramos = [1, idx_rebotes, length(pos_x)];
    
    % Colores para los ajustes
    colores = ['r', 'g', 'm', 'c', 'y', 'k'];
    
    % Realizar ajuste polinómico por cada tramo
    for i = 1:length(idx_tramos)-1
        % Extraer el tramo actual
        idx_start = idx_tramos(i);
        idx_end   = idx_tramos(i+1);
        x_tramo   = pos_x(idx_start:idx_end);
        y_tramo   = pos_y(idx_start:idx_end);
        
        % Ajuste polinómico de grado 2
        p = polyfit(x_tramo, y_tramo, min(2, length(x_tramo)-1));
        
        % Generar puntos para graficar el ajuste
        x_fit = linspace(min(x_tramo), max(x_tramo), 100);
        y_fit = polyval(p, x_fit);
        
        % Graficar el ajuste con un color diferente
        plot(x_fit, y_fit, '--', 'Color', colores(mod(i-1, length(colores))+1), 'LineWidth', 1.5);
    end
    
    % Crear leyenda dinámica
    legend_entries = {'Trayectoria Real'};
    for i = 1:length(idx_tramos)-1
        legend_entries{end+1} = sprintf('Ajuste Polyfit Grado 2 Tramo %d', i);
    end
    legend(legend_entries);
    hold off;
end

function analizarError(params)
    % Coeficientes de restitución
    coef_nominal = params.coef_rest;
    error_coef   = 0.03 * coef_nominal;
    coef_max     = coef_nominal + error_coef;
    coef_min     = coef_nominal - error_coef;
    
    % Simular con diferentes coeficientes
    params_nom = params;
    params_max = params; params_max.coef_rest = coef_max;
    params_min = params; params_min.coef_rest = coef_min;
    
    [~, ~, ~, ~, ~, tiempo_nominal, ~] = simularPelota(params_nom);
    [~, ~, ~, ~, ~, tiempo_max, ~]     = simularPelota(params_max);
    [~, ~, ~, ~, ~, tiempo_min, ~]     = simularPelota(params_min);
    
    % Cálculo de errores
    error_tiempo_max    = abs(tiempo_max - tiempo_nominal);
    error_tiempo_min    = abs(tiempo_min - tiempo_nominal);
    cota_error_absoluto = max(error_tiempo_max, error_tiempo_min);
    error_relativo      = 100 * cota_error_absoluto / tiempo_nominal;
    
    % Mostrar resultados
    fprintf('\nd) Análisis de error: \n');
    fprintf('Tiempo con coef. nominal (%.4f): %.4f s\n', coef_nominal, tiempo_nominal);
    fprintf('Tiempo con coef. máximo (%.4f): %.4f s\n', coef_max, tiempo_max);
    fprintf('Tiempo con coef. mínimo (%.4f): %.4f s\n', coef_min, tiempo_min);
    
    fprintf('Cota de error absoluto: %.4f s\n', cota_error_absoluto);
    fprintf('Error relativo: %.2f%%\n', error_relativo);
end

function compararInterpolaciones(params)
    % Simular la trayectoria completa de la pelota
    [tiempo, pos_x, pos_y, vel_x, vel_y, ~, ~, idx_rebotes] = simularPelota(params);
    
    % Seleccionar puntos para interpolación
    % Para hacer una comparación significativa, seleccionamos una muestra de puntos
    % uniformemente distribuidos a lo largo de toda la trayectoria
    num_puntos_muestra = 10;  % Número de puntos de muestra a lo largo de la trayectoria
    
    % Índices de los puntos de muestra (distribuidos uniformemente)
    indices_muestra = round(linspace(1, length(pos_x), num_puntos_muestra));
    
    % Extraer coordenadas de los puntos de muestra
    x_muestra = pos_x(indices_muestra);
    y_muestra = pos_y(indices_muestra);
    
    % Generar puntos de evaluación a lo largo de toda la trayectoria
    x_eval = linspace(min(pos_x), max(pos_x), 200);
    
    % 1. Interpolación de Newton
    [y_newton] = interpolacionNewton(x_muestra, y_muestra, x_eval);
    
    % 2. Ajuste por mínimos cuadrados
    % Para mínimos cuadrados, consideramos un polinomio de grado mayor para capturar los rebotes
    grado_poly = min(6, length(x_muestra)-1);  % Grado máximo según número de puntos
    p_mc       = polyfit(x_muestra, y_muestra, grado_poly);
    y_mc       = polyval(p_mc, x_eval);
    
    % Interpolar los valores reales en los puntos de evaluación
    y_eval_real = interp1(pos_x, pos_y, x_eval, 'spline');
    
    % Cálculo de errores
    error_newton          = abs(y_newton - y_eval_real);
    error_mc              = abs(y_mc - y_eval_real);
    error_relativo_newton = sqrt(sum(error_newton.^2)) / sqrt(sum(y_eval_real.^2));
    error_relativo_mc     = sqrt(sum(error_mc.^2)) / sqrt(sum(y_eval_real.^2));
    
    % Graficar resultados
    figure(3);
    subplot(2,1,1);
    plot(    pos_x, pos_y,     'k-', 'LineWidth', 2); hold on;                 % Trayectoria real completa
    plot(   x_eval, y_newton, 'r--', 'LineWidth', 1.5);                        % Interpolación Newton
    plot(   x_eval, y_mc,     'b-.', 'LineWidth', 1.5);                        % Mínimos cuadrados
    plot(x_muestra, y_muestra, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Puntos de muestra
    
    % Marcar los puntos de rebote
    if ~isempty(idx_rebotes)
        plot(pos_x(idx_rebotes), pos_y(idx_rebotes), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    end
    
    legend('Trayectoria Real', 'Interpolación Newton', 'Mínimos Cuadrados', 'Puntos Muestra', 'Rebotes');
    xlabel('Distancia Horizontal (m)'); ylabel('Altura (m)');
    title('Comparación de Métodos de Interpolación sobre Trayectoria'); grid on;
    
    % Graficar diferencias
    subplot(2,1,2);
    plot(x_eval, error_newton, 'r-', 'LineWidth', 1.5); hold on;
    plot(x_eval, error_mc    , 'b-', 'LineWidth', 1.5);
    legend('Error Newton', 'Error Mínimos Cuadrados');
    xlabel('Distancia Horizontal (m)'); ylabel('Error Absoluto (m)');
    title('Comparación de Errores'); grid on;
    
    % Mostrar resultados numéricos
    fprintf('\ne) Comparación de errores (trayectoria completa)\n');
    fprintf('Error relativo con Interpolación de Newton: %.7f\n', error_relativo_newton);
    fprintf('Error relativo con Mínimos Cuadrados: %.7f\n', error_relativo_mc);
    
    if error_relativo_newton < error_relativo_mc
        fprintf('Conclusión: La interpolación de Newton tiene menor error relativo\n');
    else
        fprintf('Conclusión: El ajuste por mínimos cuadrados tiene menor error relativo\n');
    end
end

function [y_newton] = interpolacionNewton(x_data, y_data, x_eval)
    n = length(x_data);
    dd = zeros(n, n);
    dd(:, 1) = y_data;
    
    for j = 2:n
        for i = j:n
            dd(i, j) = (dd(i, j-1) - dd(i-1, j-1)) / (x_data(i) - x_data(i-j+1));
        end
    end
    
    y_newton = zeros(size(x_eval));
    for k = 1:length(x_eval)
        temp = dd(n, n);
        for i = n-1:-1:1
            temp = temp * (x_eval(k) - x_data(i)) + dd(i, i);
        end
        y_newton(k) = temp;
    end
end