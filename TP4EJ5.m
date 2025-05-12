% Ejercicio 5-TP4
clc; clear; close all
% Definir el polinomio f(x) = x^4 + 2x^2 - x - 3 y su derivada
f  = @(x) x.^4 + 2*x.^2 - x - 3;
df = @(x) 4*x.^3 + 4*x - 1;
% Valores iniciales para buscar raíces
initial_guesses = [-2, -1, 0, 1, 2];
tolerance       = 1e-10;
max_iterations  = 100;
% Almacenar las raíces reales encontradas
real_roots = [];
% Metodo de Newton-Raphson para encontrar raíces
for x0 = initial_guesses
    x = x0;
    for iter = 1:max_iterations
        f_x = f(x);
        df_x = df(x);     
        % Evitar division por cero
        if df_x == 0
            break;
        end
        % Actualizar la estimacion
        x_new = x - f_x / df_x;
        % Verificar convergencia
        if abs(x_new - x) < tolerance
            x = x_new;
            break;
        end
        x = x_new;
    end
    % Verificar si la raíz es real y no ha sido encontrada antes
    if abs(f(x)) < 1e-10  % Tolerancia para considerar que es una raíz
        is_unique = true;
        for r = real_roots
            if abs(r - x) < tolerance
                is_unique = false;
                break;
            end
        end
        if is_unique
            real_roots = [real_roots; x];
        end
    end
end
% Definir las funciones g_i(x)
g1 = @(x) (3 + x - 2*x.^2).^(1/4);
g2 = @(x) ((x + 3 - x.^4)/2).^(1/2);
g3 = @(x) ((x + 3)./(x.^2 + 2)).^(1/2);
g4 = @(x) (3*x.^4 + 2*x.^2 + 3)./(4*x.^3 + 4*x - 1);
% Handles y nombres de las funciones g
g_handles = {g1, g2, g3, g4};
g_names = {'g1', 'g2', 'g3', 'g4'};
% Verificación de puntos fijos
fprintf('Verificación de puntos fijos para las raíces de f(x) = x^4 + 2x^2 - x - 3\n');
fprintf('------------------------------------------------------------\n');
for i = 1:length(real_roots)
    p_i = real_roots(i);
    f_p = f(p_i);
    fprintf('Raíz p = %.6f, f(p) = %.6e\n', p_i, f_p);
    for j = 1:length(g_handles)
        g = g_handles{j};
        name = g_names{j};
        g_p = g(p_i);
        diff = g_p - p_i;
        fprintf('  %s(p) = %.6f, p = %.6f, diferencia = %.6e\n', name, g_p, p_i, diff);
    end
    fprintf('\n');
end
% Notas sobre los dominios
disp('Notas:');
disp(' - g1 es real cuando 3 + x - 2x^2 >= 0');
disp(' - g2 es real cuando (x + 3 - x^4)/2 >= 0');
disp(' - g3 es real cuando (x + 3)/(x^2 + 2) >= 0');
disp(' - g4 está definida siempre que 4x^3 + 4x - 1 ~= 0');