% Ejercicio 2c-TP6
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Programa MATLAB para implementar el método de Runge Kutta
% Definimos la ecuación diferencial como una función anónima: dy/dx = (x - y)/2
% Esto es equivalente a la función `dydx` en Python.
dydx_anon = @(x_val, y_val) (x_val - y_val)/2;
% --- Bloque de ejecución principal ---
% Definir los parámetros iniciales
x0           = 0;   % Valor inicial de x
y0           = 1;   % Valor inicial de y en x0
x_target_val = 2;   % Valor de x para el que queremos encontrar y
h_step       = 0.2; % Tamaño de paso
% Llamar a la función Runge Kutta para calcular el valor de y
final_y_result = rungeKutta(x0, y0, x_target_val, h_step, dydx_anon);
% Mostrar el resultado
fprintf('El valor de y en x es: %f\n', final_y_result);
% --- Definición de funciones auxiliares ---
% rungeKutta: Encuentra el valor de y para un x_target dado
% usando el tamaño de paso h y el valor inicial y0_initial en x0_initial.
% Argumentos:
%   x0_initial: El valor inicial de x.
%   y0_initial: El valor inicial de y en x0_initial.
%   x_target: El valor de x para el que queremos encontrar y.
%   h: El tamaño de paso.
%   dydx_func: La función que representa dy/dx.
%
% Retorna:
%   y_final: El valor de y en x_target.
function y_final = rungeKutta(x0_initial, y0_initial, x_target, h, dydx_func)
    % Inicializar x y y para las iteraciones del método
    x_current = x0_initial;
    y_current = y0_initial;
    % Calcular el número de pasos necesarios para ir de x0 a x_target
    % 'round' se usa para asegurar que 'n' sea un entero, asumiendo que
    % (x_target - x0_initial) es divisible por h.
    n = round((x_target - x0_initial) / h);
    % Bucle para aplicar el método de Runge Kutta paso a paso
    for i = 1:n
        % Calcular los coeficientes k1, k2, k3
        % Nota: El código Python original utiliza una fórmula que se asemeja a
        % una versión de Runge-Kutta de tercer orden (RK3) o una RK4 incompleta,
        % ya que le falta el término k4 para ser un RK4 estándar.
        % Para un RK4 estándar, se necesitaría un k4 adicional y la fórmula final sería:
        % k4 = h * dydx_func(x_current + h, y_current + k3);
        % y_current = y_current + (1.0 / 6.0) * (k1 + 2*k2 + 2*k3 + k4);
        k1 = h * dydx_func(x_current, y_current);
        k2 = h * dydx_func(x_current + 0.5 * h, y_current + 0.5 * k1);
        k3 = h * dydx_func(x_current + 0.5 * h, y_current + 0.5 * k2);
        % Actualizar el valor de y usando la fórmula del método de Runge-Kutta
        y_current = y_current + (1.0 / 6.0) * (k1 + 2 * k2 + 2 * k3);
        % Actualizar el valor de x para la siguiente iteración
        x_current = x_current + h;
    end
    % Retornar el valor final de y después de todas las iteraciones
    y_final = y_current;
end