% Ejercicio 5-TP4: Comparación de Métodos de Búsqueda de Raíces
% Mejorado con los métodos de Broyden y Bisección, y visualización
clc; clear; close all

% Definir el polinomio y su derivada
f  = @(x) x.^4 + 2*x.^2 - x - 3;
df = @(x) 4*x.^3 + 4*x - 1;

% Parámetros para todos los métodos
initial_guesses = [-2, -1, 0, 1, 2];% Suposiciones iniciales
tolerance       = 1e-10;            % Tolerancia
max_iterations  = 100;              % Iteraciones máximas
real_roots      = [];               % Raíces reales

% Crear figuras para visualización
fig_convergence = figure('Name', 'Convergencia de Métodos de Búsqueda de Raíces');
fig_function    = figure('Name', 'Función y Sus Raíces');

% 1. Método de Newton-Raphson
fprintf('============== Método de Newton-Raphson ==============\n');
newton_roots      = []; % Raíces de Newton
newton_iterations = {}; % Iteraciones de Newton
newton_errors     = {}; % Errores de Newton

for i = 1:length(initial_guesses)
    x0         = initial_guesses(i);
    x          = x0;
    iterations = x0;
    errors     = [];
    
    for iter = 1:max_iterations
        f_x  = f(x);
        df_x = df(x);
        
        % Evitar división por cero
        if abs(df_x) < 1e-15
            fprintf('Newton-Raphson: Derivada demasiado cercana a cero en x = %.6f\n', x);
            break;
        end
        % Actualizar estimación
        x_new = x - f_x / df_x;
        iterations = [iterations, x_new];
        errors = [errors, abs(x_new - x)];
        
        % Verificar convergencia
        if abs(x_new - x) < tolerance
            x = x_new;
            fprintf('Newton-Raphson convergió desde x0 = %.2f a la raíz %.10f en %d iteraciones\n', x0, x, iter);
            break;
        end
        
        x = x_new;
        
        % Verificar si se alcanzó el máximo de iteraciones
        if iter == max_iterations
            fprintf('Newton-Raphson: Máximo de iteraciones alcanzado para x0 = %.2f\n', x0);
        end
    end
    
    % Registrar resultados
    if abs(f(x)) < tolerance
        is_unique = true;
        for r = newton_roots
            if abs(r - x) < tolerance
                is_unique = false;
                break;
            end
        end
        if is_unique
            newton_roots = [newton_roots; x];
            newton_iterations{end+1} = iterations;
            newton_errors{end+1} = errors;
        end
    end
end

% Ordenar raíces para un orden consistente
newton_roots = sort(newton_roots);
fprintf('Newton-Raphson encontró %d raíces únicas:\n', length(newton_roots));
disp(newton_roots);

% 2. Método de Bisección
fprintf('\n============== Método de Bisección ==============\n');
bisection_roots = []; % Raíces de bisección
bisection_iterations = {}; % Iteraciones de bisección
bisection_errors = {}; % Errores de bisección

% Definir intervalos para buscar raíces
intervals = [-2 -1; -1 0; 0 1; 1 2];

for i = 1:size(intervals, 1)
    a = intervals(i, 1);
    b = intervals(i, 2);
    % 
    % Verificar si hay un cambio de signo en el intervalo
    if f(a) * f(b) >= 0
        fprintf('Bisección: No hay cambio de signo en el intervalo [%.2f, %.2f]\n', a, b);
        continue;
    end
    
    iterations = [a, b];
    % errors = [];
    
    for iter = 1:max_iterations
        c = (a + b) / 2;
        iterations = [iterations, c];
        
        f_c = f(c);
        
        % Verificar si se encontró una raíz
        if abs(f_c) < tolerance
            fprintf('Bisección convergió a la raíz %.10f en el intervalo [%.2f, %.2f] después de %d iteraciones\n', c, intervals(i,1), intervals(i,2), iter);
            break;
        end
        
        if f(a) * f_c < 0
            errors = [errors, abs(b - c)];
            b = c;
        else
            errors = [errors, abs(a - c)];
            a = c;
        end
        
        % Verificar convergencia
        if abs(b - a) < tolerance
            c = (a + b) / 2;
            fprintf('Bisección convergió a la raíz %.10f en el intervalo [%.2f, %.2f] después de %d iteraciones\n', c, intervals(i,1), intervals(i,2), iter);
            break;
        end
        
        % Verificar si se alcanzó el máximo de iteraciones
        if iter == max_iterations
            fprintf('Bisección: Máximo de iteraciones alcanzado para el intervalo [%.2f, %.2f]\n', intervals(i,1), intervals(i,2));
        end
    end
    
    % Registrar resultados
    if abs(f(c)) < tolerance
        is_unique = true;
        for r = bisection_roots
            if abs(r - c) < tolerance
                is_unique = false;
                break;
            end
        end
        if is_unique
            bisection_roots = [bisection_roots; c];
            bisection_iterations{end+1} = iterations;
            bisection_errors{end+1} = errors;
        end
    end
end

% Ordenar raíces para un orden consistente
bisection_roots = sort(bisection_roots);
fprintf('Bisección encontró %d raíces únicas:\n', length(bisection_roots));
disp(bisection_roots);

% 3. Método de Broyden
fprintf('\n============== Método de Broyden ==============\n');
broyden_roots = []; % Raíces de Broyden
broyden_iterations = {}; % Iteraciones de Broyden
broyden_errors = {}; % Errores de Broyden

for i = 1:length(initial_guesses)
    x0 = initial_guesses(i);
    x = x0;
    
    % Aproximación inicial del Jacobiano (derivada para el caso 1D)
    J = df(x0);
    
    iterations = x0;
    errors = [];
    
    for iter = 1:max_iterations
        f_x = f(x);
        
        % Evitar división por cero
        if abs(J) < 1e-15
            fprintf('Broyden: Jacobiano demasiado cercano a cero en x = %.6f\n', x);
            break;
        end
        
        % Actualizar estimación
        s = -f_x / J;
        x_new = x + s;
        iterations = [iterations, x_new];
        errors = [errors, abs(x_new - x)];
        
        % Verificar convergencia
        if abs(x_new - x) < tolerance
            x = x_new;
            fprintf('Broyden convergió desde x0 = %.2f a la raíz %.10f en %d iteraciones\n', x0, x, iter);
            break;
        end
        
        % Actualizar Jacobiano usando la fórmula de Broyden
        f_x_new = f(x_new);
        y = f_x_new - f_x;
        J = J + (y - J*s) / s * s;
        
        x = x_new;
        
        % Verificar si se alcanzó el máximo de iteraciones
        if iter == max_iterations
            fprintf('Broyden: Máximo de iteraciones alcanzado para x0 = %.2f\n', x0);
        end
    end
    
    % Registrar resultados
    if abs(f(x)) < tolerance
        is_unique = true;
        for r = broyden_roots
            if abs(r - x) < tolerance
                is_unique = false;
                break;
            end
        end
        if is_unique
            broyden_roots = [broyden_roots; x];
            broyden_iterations{end+1} = iterations;
            broyden_errors{end+1} = errors;
        end
    end
end

% Ordenar raíces para un orden consistente
broyden_roots = sort(broyden_roots);
fprintf('Broyden encontró %d raíces únicas:\n', length(broyden_roots));
disp(broyden_roots);

% Combinar todas las raíces y asegurar unicidad
all_roots = [newton_roots; bisection_roots; broyden_roots];
real_roots = [];

for r = all_roots'
    is_unique = true;
    for existing_r = real_roots
        if abs(existing_r - r) < tolerance
            is_unique = false;
            break;
        end
    end
    if is_unique
        real_roots = [real_roots; r];
    end
end

real_roots = sort(real_roots);
fprintf('\nTodos los métodos combinados encontraron %d raíces únicas:\n', length(real_roots));
disp(real_roots);

% Graficar la función y sus raíces
figure(fig_function);
x_range = linspace(-2.5, 2.5, 1000);
y_range = f(x_range);

% Graficar la función
plot(x_range, y_range, 'b-', 'LineWidth', 2);
hold on;
plot(x_range, zeros(size(x_range)), 'k--', 'LineWidth', 0.5); % Eje x
grid on;

% Graficar las raíces
for i = 1:length(real_roots)
    plot(real_roots(i), 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(real_roots(i), 0.5, ['Raíz = ', num2str(real_roots(i), '%.4f')], 'FontSize', 12);
end

title('Polinomio f(x) = x^4 + 2x^2 - x - 3 y sus raíces', 'FontSize', 14);
xlabel('x', 'FontSize', 12);
ylabel('f(x)', 'FontSize', 12);
legend('f(x)', 'y = 0', 'Raíces', 'Location', 'best');
xlim([-2.5, 2.5]);
ylim([-5, 15]);

% Graficar el comportamiento de convergencia
figure(fig_convergence);

% Crear subgráficos para cada método
subplot(3, 1, 1);
hold on;
colors = {'r', 'g', 'b', 'm', 'c'};
for i = 1:length(newton_iterations)
    iterations = newton_iterations{i};
    plot(0:length(iterations)-1, iterations, [colors{mod(i-1, length(colors))+1}, '-o'], 'LineWidth', 1.5);
end
title('Método de Newton-Raphson: Convergencia', 'FontSize', 12);
xlabel('Iteración', 'FontSize', 10);
ylabel('Aproximación', 'FontSize', 10);
grid on;
legend_entries = cell(1, length(newton_iterations));
for i = 1:length(newton_iterations)
    legend_entries{i} = ['x_0 = ', num2str(newton_iterations{i}(1))];
end
legend(legend_entries, 'Location', 'bestoutside');

subplot(3, 1, 2);
hold on;
for i = 1:length(bisection_iterations)
    iterations = bisection_iterations{i};
    plot(0:length(iterations)-1, iterations, [colors{mod(i-1, length(colors))+1}, '-o'], 'LineWidth', 1.5);
end
title('Método de Bisección: Convergencia', 'FontSize', 12);
xlabel('Iteración', 'FontSize', 10);
ylabel('Aproximación', 'FontSize', 10);
grid on;
legend_entries = cell(1, length(bisection_iterations));
for i = 1:length(bisection_iterations)
    legend_entries{i} = ['Intervalo [', num2str(bisection_iterations{i}(1)), ',', num2str(bisection_iterations{i}(2)), ']'];
end
legend(legend_entries, 'Location', 'bestoutside');

subplot(3, 1, 3);
hold on;
for i = 1:length(broyden_iterations)
    iterations = broyden_iterations{i};
    plot(0:length(iterations)-1, iterations, [colors{mod(i-1, length(colors))+1}, '-o'], 'LineWidth', 1.5);
end
title('Método de Broyden: Convergencia', 'FontSize', 12);
xlabel('Iteración', 'FontSize', 10);
ylabel('Aproximación', 'FontSize', 10);
grid on;
legend_entries = cell(1, length(broyden_iterations));
for i = 1:length(broyden_iterations)
    legend_entries{i} = ['x_0 = ', num2str(broyden_iterations{i}(1))];
end
legend(legend_entries, 'Location', 'bestoutside');

% Crear figura para graficar la convergencia de errores
figure('Name', 'Convergencia de Errores');

% Graficar la convergencia de errores para cada método
subplot(3, 1, 1);
hold on;
for i = 1:length(newton_errors)
    errors = newton_errors{i};
    semilogy(1:length(errors), errors, [colors{mod(i-1, length(colors))+1}, '-o'], 'LineWidth', 1.5);
end
title('Método de Newton-Raphson: Convergencia de Errores', 'FontSize', 12);
xlabel('Iteración', 'FontSize', 10);
ylabel('Error (escala logarítmica)', 'FontSize', 10);
grid on;
legend(legend_entries, 'Location', 'bestoutside');

subplot(3, 1, 2);
hold on;
for i = 1:length(bisection_errors)
    errors = bisection_errors{i};
    semilogy(1:length(errors), errors, [colors{mod(i-1, length(colors))+1}, '-o'], 'LineWidth', 1.5);
end
title('Método de Bisección: Convergencia de Errores', 'FontSize', 12);
xlabel('Iteración', 'FontSize', 10);
ylabel('Error (escala logarítmica)', 'FontSize', 10);
grid on;
legend_entries = cell(1, length(bisection_iterations));
for i = 1:length(bisection_iterations)
    legend_entries{i} = ['Intervalo [', num2str(bisection_iterations{i}(1)), ',', num2str(bisection_iterations{i}(2)), ']'];
end
legend(legend_entries, 'Location', 'bestoutside');

subplot(3, 1, 3);
hold on;
for i = 1:length(broyden_errors)
    errors = broyden_errors{i};
    semilogy(1:length(errors), errors, [colors{mod(i-1, length(colors))+1}, '-o'], 'LineWidth', 1.5);
end
title('Método de Broyden: Convergencia de Errores', 'FontSize', 12);
xlabel('Iteración', 'FontSize', 10);
ylabel('Error (escala logarítmica)', 'FontSize', 10);
grid on;
legend_entries = cell(1, length(broyden_iterations));
for i = 1:length(broyden_iterations)
    legend_entries{i} = ['x_0 = ', num2str(broyden_iterations{i}(1))];
end
legend(legend_entries, 'Location', 'bestoutside');

% Definir las funciones g_i(x)
g1 = @(x) (3 + x - 2*x.^2).^(1/4);
g2 = @(x) ((x + 3 - x.^4)/2).^(1/2);
g3 = @(x) ((x + 3)./(x.^2 + 2)).^(1/2);
g4 = @(x) (3*x.^4 + 2*x.^2 + 3)./(4*x.^3 + 4*x - 1);

% Manejadores y nombres de las funciones g
g_handles = {g1, g2, g3, g4};
g_names = {'g1', 'g2', 'g3', 'g4'};

% Verificación de puntos fijos
fprintf('\n========== Verificación de Puntos Fijos ==========\n');
fprintf('Verificación de puntos fijos para las raíces de f(x) = x^4 + 2x^2 - x - 3\n');
fprintf('------------------------------------------------------------\n');

for i = 1:length(real_roots)
    p_i = real_roots(i);
    f_p = f(p_i);
    fprintf('Raíz p = %.10f, f(p) = %.6e\n', p_i, f_p);
    
    for j = 1:length(g_handles)
        try
            g = g_handles{j};
            name = g_names{j};
            g_p = g(p_i);
            diff = abs(g_p - p_i);
            fprintf('  %s(p) = %.10f, p = %.10f, diferencia = %.6e\n', name, g_p, p_i, diff);
        catch ME
            fprintf('  %s(p): %s\n', name, ME.message);
        end
    end
    fprintf('\n');
end

% Graficar las iteraciones de punto fijo
figure('Name', 'Visualización de Puntos Fijos');

% Crear rangos x válidos para cada función g (considerando restricciones de dominio)
x_valid = linspace(-2.5, 2.5, 1000);
y_valid = x_valid; % Línea y = x

subplot(2, 2, 1);
hold on;
g1_valid_indices = (3 + x_valid - 2*x_valid.^2) >= 0;
plot(x_valid, y_valid, 'k--', 'LineWidth', 1); % Línea y = x
plot(x_valid(g1_valid_indices), g1(x_valid(g1_valid_indices)), 'b-', 'LineWidth', 2);
for i = 1:length(real_roots)
    plot(real_roots(i), real_roots(i), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
end
title('g1(x) = (3 + x - 2x^2)^{1/4}', 'FontSize', 12);
xlabel('x', 'FontSize', 10);
ylabel('g1(x)', 'FontSize', 10);
grid on;
xlim([-2.5, 2.5]);
ylim([-2.5, 2.5]);
legend('y = x', 'g1(x)', 'Puntos Fijos', 'Location', 'best');

subplot(2, 2, 2);
hold on;
g2_valid_indices = ((x_valid + 3 - x_valid.^4)/2) >= 0;
plot(x_valid, y_valid, 'k--', 'LineWidth', 1); % Línea y = x
plot(x_valid(g2_valid_indices), g2(x_valid(g2_valid_indices)), 'b-', 'LineWidth', 2);
for i = 1:length(real_roots)
    plot(real_roots(i), real_roots(i), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
end
title('g2(x) = ((x + 3 - x^4)/2)^{1/2}', 'FontSize', 12);
xlabel('x', 'FontSize', 10);
ylabel('g2(x)', 'FontSize', 10);
grid on;
xlim([-2.5, 2.5]);
ylim([-2.5, 2.5]);
legend('y = x', 'g2(x)', 'Puntos Fijos', 'Location', 'best');

subplot(2, 2, 3);
hold on;
g3_valid_indices = (x_valid + 3) >= 0;
plot(x_valid, y_valid, 'k--', 'LineWidth', 1); % Línea y = x
plot(x_valid(g3_valid_indices), g3(x_valid(g3_valid_indices)), 'b-', 'LineWidth', 2);
for i = 1:length(real_roots)
    plot(real_roots(i), real_roots(i), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
end
title('g3(x) = ((x + 3)/(x^2 + 2))^{1/2}', 'FontSize', 12);
xlabel('x', 'FontSize', 10);
ylabel('g3(x)', 'FontSize', 10);
grid on;
xlim([-2.5, 2.5]);
ylim([-2.5, 2.5]);
legend('y = x', 'g3(x)', 'Puntos Fijos', 'Location', 'best');

subplot(2, 2, 4);
hold on;
% Encontrar dónde el denominador no es cero para g4
g4_valid_indices = abs(4*x_valid.^3 + 4*x_valid - 1) > 1e-10;
plot(x_valid, y_valid, 'k--', 'LineWidth', 1); % Línea y = x
plot(x_valid(g4_valid_indices), g4(x_valid(g4_valid_indices)), 'b-', 'LineWidth', 2);
for i = 1:length(real_roots)
    plot(real_roots(i), real_roots(i), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
end
title('g4(x) = (3x^4 + 2x^2 + 3)/(4x^3 + 4x - 1)', 'FontSize', 12);
xlabel('x', 'FontSize', 10);
ylabel('g4(x)', 'FontSize', 10);
grid on;
xlim([-2.5, 2.5]);
ylim([-2.5, 2.5]);
legend('y = x', 'g4(x)', 'Puntos Fijos', 'Location', 'best');

% Notas sobre dominios
fprintf('\n========== Notas sobre Dominios ==========\n');
disp('Restricciones de dominio para las funciones g:');
disp(' - g1 es real cuando 3 + x - 2x^2 >= 0');
disp(' - g2 es real cuando (x + 3 - x^4)/2 >= 0');
disp(' - g3 es real cuando (x + 3)/(x^2 + 2) >= 0');
disp(' - g4 está definida cuando 4x^3 + 4x - 1 ~= 0');

% Comparación de métodos y conclusión
fprintf('\n========== Comparación de Métodos ==========\n');
fprintf('Método\t\tRaíces Encontradas\tVelocidad de Convergencia\n');
fprintf('-----------------------------------------------\n');
fprintf('Newton-Raphson\t%d\t\tCuadrática\n', length(newton_roots));
fprintf('Bisección\t%d\t\tLineal\n', length(bisection_roots));
fprintf('Broyden\t\t%d\t\tSuperlineal\n', length(broyden_roots));
fprintf('-----------------------------------------------\n');