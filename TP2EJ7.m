% Ejercicio 7-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos
T = [0, 8, 16, 24, 32, 140]; % Temperaturas
o = [14.621, 11.843, 9.870, 8.418, 7.305, 6.413]; % Concentraciones

% Interpolación lineal
T_interp = 27;
o_interp_linear = interp1(T, o, T_interp, 'linear');
fprintf('Interpolación lineal: O(27) = %.6f mg/L\n', o_interp_linear);

% Polinomio de interpolación de Newton
p = polyfit(T, o, 4); % Ajuste polinómico de grado 4
o_interp_newton = polyval(p, T_interp);
fprintf('Polinomio de interpolación de Newton: O(27) = %.6f mg/L\n', o_interp_newton);

% Spline cúbico
o_interp_spline = spline(T, o, T_interp);
fprintf('Spline cúbico: O(27) = %.6f mg/L\n', o_interp_spline);