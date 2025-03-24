% Ejercicio 9-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Datos de la tabla
tareas = [302, 325, 285, 339, 334, 322, 331, 279, 316, 347, ...
          343, 290, 326, 233, 254, 185, 304, 337, 339, 340, ...
          316, 351, 337, 344, 343, 334, 319, 337, 340, 337];
      
notas_finales = [45, 72, 54, 54, 79, 65, 99, 63, 65, 99, ...
                 83, 74, 76, 57, 45, 59, 62, 70, 67, 75, ...
                 45, 100, 53, 79, 83, 66, 70, 54, 51, 42];

% Ajuste polinómico
grado = 1; % Ajuste lineal
p = polyfit(tareas, notas_finales, grado);

% Mostrar los coeficientes del polinomio
fprintf('Coeficientes del polinomio ajustado:\n');
disp(p);

% Estimar la nota necesaria para obtener una nota final mínima de 60
nota_final_deseada_60 = 60;
nota_necesaria_60 = (nota_final_deseada_60 - p(2)) / p(1);

% Estimar la nota necesaria para obtener una nota final mínima de 90
nota_final_deseada_90 = 90;
nota_necesaria_90 = (nota_final_deseada_90 - p(2)) / p(1);

% Mostrar resultados
fprintf('Nota necesaria para obtener una nota final mínima de 60: %.2f\n', nota_necesaria_60);
fprintf('Nota necesaria para obtener una nota final mínima de 90: %.2f\n', nota_necesaria_90);

% Graficar los datos y el ajuste
figure;
scatter(tareas, notas_finales, 'filled', 'r', 'DisplayName', 'Datos Originales');
hold on;
x_fit = linspace(min(tareas), max(tareas), 100);
y_fit = polyval(p, x_fit);
plot(x_fit, y_fit, 'b-', 'DisplayName', 'Ajuste Polinómico');
xlabel('Tareas');
ylabel('Nota Final');
title('Ajuste Polinómico de Notas');
legend show;
grid on;
hold off;