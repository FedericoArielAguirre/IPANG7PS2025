% Ejercicio 6-TP4  Método de punto fijo para encontrar el tiempo de caída de un objeto
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Definición de parámetros
s0  = 91.44;   % altura inicial en metros
m   = 0.11;    % masa en kg
g   = 9.8;     % aceleración gravitacional en m/s^2
k   = 0.15;    % coeficiente de resistencia del aire en kg·seg/m
tol = 0.01;    % tolerancia de error en segundos
% Función s(t) que da la altura en función del tiempo
s = @(t) s0 - (m*g/k)*t + (m^2*g/k^2)*(1 - exp(-k*t/m));
% Para aplicar el método de punto fijo, despejamos t de s(t) = 0
% Reescribimos como t = G(t) donde G es la función de iteración
G = @(t) (s0 + (m^2*g/k^2)*(1 - exp(-k*t/m)))/(m*g/k);
% Estimación inicial: caída libre sin resistencia del aire
t0 = sqrt(2*s0/g);
fprintf('Estimación inicial t0 = %.6f segundos\n', t0);
% Implementación del método de punto fijo
max_iter = 100;
t_actual = t0;
iter     = 0;
error    = tol + 1;  % Inicializar con un valor mayor que la tolerancia
fprintf('Iteración | t_actual | t_nuevo | Error | s(t)\n');
fprintf('----------|----------|---------|-------|--------\n');
while error > tol && iter < max_iter
    t_nuevo = G(t_actual);
    error   = abs(t_nuevo - t_actual);
    altura  = s(t_nuevo);
    fprintf('%9d | %8.6f | %7.6f | %5.6f | %7.6f\n', iter, t_actual, t_nuevo, error, altura);
    t_actual = t_nuevo;
    iter     = iter + 1;
end
% Verificar si el método convergió
if iter < max_iter
    fprintf('\nEl método convergió después de %d iteraciones.\n', iter);
    fprintf('El tiempo de caída es aproximadamente %.6f segundos.\n', t_actual);
    fprintf('La altura en ese tiempo es %.10f metros.\n', s(t_actual));
else
    fprintf('\nEl método no convergió después de %d iteraciones.\n', max_iter);
end
% Gráfica de la altura en función del tiempo
t_rango = linspace(0, t_actual*1.2, 1000);
alturas = zeros(size(t_rango));
for i = 1:length(t_rango)
    alturas(i) = s(t_rango(i));
end
figure;
plot(t_rango, alturas, 'b-', 'LineWidth', 2);
hold on;
plot([0, t_actual*1.2], [0, 0], 'k--');  % Línea del suelo
plot([t_actual, t_actual], [min(alturas), max(alturas)], 'r--');  % Tiempo de caída
grid on;
xlabel('Tiempo (s)');
ylabel('Altura (m)');
title('Altura del objeto en función del tiempo');
legend('s(t)', 'Suelo', 'Tiempo de caída');