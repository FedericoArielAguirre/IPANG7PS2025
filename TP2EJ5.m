% Ejercicio 5-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definir el rango de x
x = 0:0.1:30; % de 0 a 30 con pasos de 0.1

% Iniciar la variable f
f = zeros(size(x));

% Definir las diferentes secciones de la función
for i = 1:length(x)
    if x(i) < 5
        f(i) = 3 + (1/3) * x(i); % Pendiente 1
    elseif x(i) < 15
        f(i) = 5; % Curva 1 (plana)
    elseif x(i) < 20
        f(i) = 5 - (2/3) * (x(i) - 15); % Pendiente -2/3
    elseif x(i) < 25
        f(i) = 2 + (1/3) * (x(i) - 20); % Pendiente 1/3
    elseif x(i) < 30
        f(i) = 3; % Curva 3 (plana)
    else
        f(i) = 3 - (3/2) * (x(i) - 30); % Pendiente -3/2
    end
end

% Graficar la función
figure;
plot(x, f, 'b-', 'LineWidth', 2);
hold on;
grid on;
xlabel('x');
ylabel('f(x)');
title('Gráfica de f(x)');