% Ejercicio 12-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos de concentración de E. coli

% Vector de tiempo
t = [4, 8, 12, 16, 20, 24];

% Vector de concentración
c = [1600, 1320, 1000, 890, 650, 560];

% Modelo exponencial: c(t) = c0 * exp(-k*t)
% Realizaremos un ajuste de mínimos cuadrados no lineal

% Función de ajuste
modelo = @(param, t) param(1) * exp(-param(2)*t);

% Estimación inicial de parámetros
param0 = [1600, 0.1];

% Opciones de optimización
opciones = optimset('Display', 'off');

% Ajuste no lineal usando lsqcurvefit
[param_ajustados, ~] = lsqcurvefit(modelo, param0, t, c, [], [], opciones);

% Parámetros ajustados
c0 = param_ajustados(1);  % Concentración inicial
k = param_ajustados(2);   % Constante de decaimiento

% a) Estimación de la concentración al final de la tormenta (t=0)
conc_inicial = c0;

% b) Tiempo para alcanzar 200 CFU/100 mL
tiempo_200 = log(200/c0) / (-k);

% Gráfica de resultados
t_plot = linspace(0, 30, 100);
c_plot = c0 * exp(-k * t_plot);

figure;
plot(t, c, 'ro', 'LineWidth', 2);  % Puntos de datos originales
hold on;
plot(t_plot, c_plot, 'b-', 'LineWidth', 2);  % Curva ajustada
xlabel('Tiempo (h)');
ylabel('Concentración de E. coli (CFU/100 mL)');
title('Decaimiento de Concentración de E. coli');
grid on;

% Impresión de resultados
fprintf('a) Concentración inicial (t=0): %.2f CFU/100 mL\n', conc_inicial);
fprintf('b) Tiempo para alcanzar 200 CFU/100 mL: %.2f horas\n', tiempo_200);