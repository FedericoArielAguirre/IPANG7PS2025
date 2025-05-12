% Ejercicio 8-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
tol      = 1e-4; % Tolerancia para el error
max_iter = 100;  % Número máximo de iteraciones
x        = 0.5;  % Suposición inicial
for i = 1:max_iter
f       = 4*x^3 + 2*x - 2;  % Evaluar la función
f_prime = 12*x^2 + 2;       % Evaluar la derivada
x_next  = x - f / f_prime;  % Aplicar la fórmula de Newton-Raphson
  if abs(x_next - x) < tol  % Verificar la condición de parada
  x = x_next;  % Actualizar el valor de x
  break;  % Salir del bucle si se cumple la tolerancia
  end
  x = x_next;  % Actualizar x para la siguiente iteración
end
disp(['La abscisa aproximada es: ', num2str(x)]);  % Mostrar el resultado