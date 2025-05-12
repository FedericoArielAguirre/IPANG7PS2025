% Ejercicio 9-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos de esfuerzo-tensión
epsilon = [153, 198, 270, 320, 355, 410, 460, 512, 562, 614, 664, 716, 766] * 1e-3;        % Convertir a m/m
sigma   = [87.8, 96.6, 176, 263, 350, 569, 830, 1227, 1623, 2105, 2677, 3378, 4257] * 1e3; % Convertir a N/m²

% Calcular la derivada dσ/dϵ
d_sigma           = diff(sigma);          % Diferencias de sigma
d_epsilon         = diff(epsilon);        % Diferencias de epsilon
d_sigma_d_epsilon = d_sigma ./ d_epsilon; % dσ/dϵ

% Crear vectores para dσ/dϵ y σ
sigma_mid = (sigma(1:end-1) + sigma(2:end)) / 2; % Puntos medios de sigma

% Graficar dσ/dϵ vs σ
figure;
scatter(sigma_mid, d_sigma_d_epsilon, 'filled');
xlabel('σ [N/m²]');
ylabel('dσ/dϵ [N/m²]');
title('dσ/dϵ vs σ');
grid on;

% Eliminar puntos cercanos a cero
threshold               = 1000;                  % Umbral para eliminar puntos cercanos a cero
valid_indices           = sigma_mid > threshold; % Índices válidos
sigma_valid             = sigma_mid(valid_indices);
d_sigma_d_epsilon_valid = d_sigma_d_epsilon(valid_indices);

% Realizar ajuste lineal
p  = polyfit(sigma_valid, d_sigma_d_epsilon_valid, 1); % p(1) = a, p(2) = E0
a  = p(1);
E0 = p(2);

% Mostrar resultados
fprintf('El valor estimado de E0 es: %.4f N/m²\n', E0);
fprintf('El valor estimado de a es: %.4f\n', a);

% Graficar esfuerzo vs tensión
figure;
hold on;
scatter(epsilon * 1e3, sigma * 1e-3, 'filled', 'b'); % Datos originales
xlabel('Tensión [10^{-3} m/m]');
ylabel('Esfuerzo [10^{3} N/m²]');
title('Esfuerzo vs Tensión');

% Curva analítica
epsilon_fit = linspace(min(epsilon), max(epsilon), 100);
sigma_fit = (E0 / a) * (exp(a * epsilon_fit) - 1); % Curva analítica
plot(epsilon_fit * 1e3, sigma_fit * 1e-3, 'r-', 'LineWidth', 2); % Curva ajustada

legend('Datos', 'Curva analítica');
grid on;
hold off;

% b)
% Datos de esfuerzo-tensión
epsilon = [153, 198, 270, 320, 355, 410, 460, 512, 562, 614, 664, 716, 766] * 1e-3; % Convertir a m/m
sigma  = [87.8, 96.6, 176, 263, 350, 569, 830, 1227, 1623, 2105, 2677, 3378, 4257] * 1e3; % Convertir a N/m²

% Seleccionar un punto medio (puede ser el punto central de los datos)
mid_index   = round(length(sigma) / 2);
sigma_bar   = sigma(mid_index);
epsilon_bar = epsilon(mid_index);

% Calcular E0/a
E0_a = sigma_bar / (exp(a * epsilon_bar) - 1); % E0/a

% Graficar esfuerzo vs tensión
figure;
hold on;
scatter(epsilon * 1e3, sigma * 1e-3, 'filled', 'b'); % Datos originales
xlabel('Tensión [10^{-3} m/m]');
ylabel('Esfuerzo [10^{3} N/m²]');
title('Esfuerzo vs Tensión');

% Curva analítica con el nuevo enfoque
epsilon_fit   = linspace(min(epsilon), max(epsilon), 100);
sigma_fit_new = (E0_a) * (exp(a * epsilon_fit) - 1);                 % Nueva curva analítica
plot(epsilon_fit * 1e3, sigma_fit_new * 1e-3, 'r-', 'LineWidth', 2); % Curva ajustada

legend('Datos', 'Nueva curva analítica');
grid on;
hold off;