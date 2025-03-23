% Ejercicio 2-TP1 con análisis de errores
% Borramos las variables previas y la ventana de comandos
clc;
clear;
close all;

% Definimos las variables
pos_inicial = single(input('Ingrese el valor para la posición inicial: \n'));
pos_final   = single(input('Ingrese el valor para la posición final: \n'));
delta       = single(input('Ingrese el valor para el paso de avance: \n')); 
i           = 0; 
pos_barra   = single(pos_inicial);

% Verificación para evitar loops infinitos
if delta == 0
    error('El paso de avance no puede ser cero');
elseif (delta > 0 && pos_inicial > pos_final) || (delta < 0 && pos_inicial < pos_final)
    error('La dirección del paso no permite alcanzar la posición final');
end

% Variables para análisis de errores
pos_exacta = pos_inicial; % Inicialmente la posición exacta es igual a la inicial
pos_calculada = pos_barra; % Valor aproximado usando precisión simple
errores_abs = []; % Error absoluto
errores_rel = []; % Error relativo
posiciones = []; % Para registrar la posición actual en cada iteración

% Bucle con análisis de errores
while pos_exacta < pos_final - single(1e-6) % Tolerancia para comparación de flotantes
    i = i + 1;
    pos_exacta = pos_inicial + i * double(delta); % Usamos doble precisión como referencia exacta
    pos_barra = single(pos_inicial + i * delta); % Calculamos la posición usando precisión simple
    
    % Error absoluto y relativo
    error_abs = abs(double(pos_barra) - pos_exacta);
    error_rel = error_abs / abs(pos_exacta);
    
    % Almacenamos los valores
    
    errores_abs = [errores_abs, error_abs];
    errores_rel = [errores_rel, error_rel];
    posiciones = [posiciones, double(pos_barra)];

    % Cota del error (debido a precisión de single)
    cota_error = abs(eps(single(pos_barra)) * double(pos_barra));
    
    % Imprimimos para control
    %fprintf('Iteración %d: Posición Calculada = %.6f, Error Abs = %.6f, Error Rel = %.6f, Cota = %.6f\n', ...
    %       i, pos_barra, error_abs, error_rel, cota_error);
    
    % Verificación de seguridad para evitar loops infinitos
    if i > 1000000
        warning('Se alcanzó el límite máximo de iteraciones');
        break;
    end
end

% Graficamos los errores
figure;
subplot(2, 1, 1);
plot(posiciones, errores_abs, 'b', 'LineWidth', 1.5);
xlabel('Posición (Calculada)');
ylabel('Error Absoluto');
title('Error Absoluto en función de la Posición');
grid on;

subplot(2, 1, 2);
plot(posiciones, errores_rel, 'r', 'LineWidth', 1.5);
xlabel('Posición (Calculada)');
ylabel('Error Relativo');
title('Error Relativo en función de la Posición');
grid on;

% Mostramos los resultados finales
disp('El valor de la iteración es: ');
disp(i);
disp('El valor para la posición de la barra: ');
disp(pos_barra);
