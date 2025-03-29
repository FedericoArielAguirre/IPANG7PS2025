% Ejercicio 10-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos
W = [0.017, 0.025, 0.020, 0.020, 0.025, 0.087, 0.111, 0.085, 0.119, 0.233, ...
     0.174, 0.211, 0.171, 0.210,  0.783, 1.11, 0.999, 1.29, 1.32, 1.35, ...
     1.74, 3.02, 3.04, 4.09, 4.28, 4.29, 5.48, 5.45, 5.96, 4.68];

R = [0.154, 0.23, 0.181, 0.180, 0.234, 0.296, 0.357, 0.260, 0.299, 0.537, ...
     0.363, 0.366, 0.334, 0.428, 1.47, 0.531, 0.771, 0.87, 1.15, 2.48, ...
     2.23, 2.01, 3.59, 3.58, 3.28, 3.40, 4.15, 4.66, 2.40, 5.10];

% a) Ajuste logarítmico

% Filtramos valores válidos
valid_indices = (W > 0) & (R > 0); % Índices válidos
W_valid       = W(valid_indices);  % Volúmenes válidos
R_valid       = R(valid_indices);  % Alturas válidas
ln_R = log(R_valid);
ln_W = log(W_valid);
p    = polyfit(ln_W, ln_R, 1);
a    = p(1);
b    = exp(p(2));
fprintf('Ajuste logarítmico:\n');
fprintf('a = %.4f\n', a);
fprintf('b = %.4f\n', b);

% b) Calcular el error cuadrático
E = sum((R - b * W.^a).^2);
fprintf('Error cuadrático asociado: E = %.4f\n', E);

% c) Recalcular el ajuste con el término cuadrático
X      = [ln_W', ln_W'.^2];
p_quad = X \ ln_R';
a_quad = p_quad(1);
c      = p_quad(2);
b_quad = exp(p_quad(1));
fprintf('Ajuste cuadrático:\n');
fprintf('a = %.4f\n', a_quad);
fprintf('b = %.4f\n', b_quad);
fprintf('c = %.4f\n', c);


% d) Calcular el error cuadrático asociado al nuevo ajuste
E_quad = sum((R - b_quad * W.^(a_quad + c * (ln_W.^2))).^2);
fprintf('Error cuadrático asociado al nuevo ajuste: E_quad = %.4f\n', E_quad);
