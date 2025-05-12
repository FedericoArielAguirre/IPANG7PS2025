% Ejercicio 1-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Definimos la función f(x) = x^2 - 3
f = @(x) x^2 - 3;
% Intervalo inicial [a, b] donde f(a) y f(b) tienen signos opuestos
a = 1;  % f(1) = 1 - 3 = -2 < 0
b = 2;  % f(2) = 4 - 3 = 1 > 0
% Tolerancia de error deseada
tol = 1e-4;
% Número máximo de iteraciones
max_iter = 1000;
% Inicializar variables
iter  = 0;
error = b - a;
% Mostrar encabezado para la tabla de iteraciones
fprintf('Iter\t   a\t\t   b\t\t   m\t\t f(m)\t\tError\n');
fprintf('--------------------------------------------------------------------\n');    
% Algoritmo de bisección
    while (error > tol && iter < max_iter)
        % Calcular el punto medio
        m = (a + b) / 2;        
        % Evaluar la función en el punto medio
        fm = f(m);        
        % Mostrar información de la iteración
        fprintf('%3d\t%1.8f\t%1.8f\t%1.8f\t%1.8f\t%1.8f\n', iter, a, b, m, fm, error);        
        % Actualizar intervalo
        if fm == 0
            % Raíz exacta encontrada
            a = m;
            b = m;
        elseif f(a) * fm < 0
            % La raíz está en la mitad izquierda
            b = m;
        else
            % La raíz está en la mitad derecha
            a = m;
        end        
        % Actualizar error y contador de iteraciones
        error = b - a;
        iter  = iter + 1;
    end
% La aproximación final es el punto medio del intervalo final
 approx_sqrt3 = (a + b) / 2;    
% Mostrar resultados
fprintf('\nAproximación de sqrt(3) = %1.8f\n', approx_sqrt3);
fprintf('sqrt(3) real = %1.8f\n'             , sqrt(3));
fprintf('Error absoluto = %1.8f\n'           , abs(approx_sqrt3 - sqrt(3)));
fprintf('Número de iteraciones = %d\n'       , iter);