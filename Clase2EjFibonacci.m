% Ejercicio Fibonacci - Clase 2

% Borramos la ventana de comandos y las variables previas
clc
clear

% Número de términos de la serie de Fibonacci que queremos calcular
n = input("Ingrese cuantos terminos desea calcular: \n");

% Inicializar el vector para almacenar los números de Fibonacci
fibonacci = zeros(1, n);

% Los dos primeros números de la serie de Fibonacci
fibonacci(1) = 1;
fibonacci(2) = 1;

% Calcular los siguientes números de Fibonacci usando un bucle for
for i = 3:n
    fibonacci(i) = fibonacci(i-1) + fibonacci(i-2);
end

% Mostrar los primeros 100 números de la serie de Fibonacci
disp(fibonacci);

% Graficar los números de Fibonacci
figure; % Crear una nueva figura
plot(1:n, fibonacci, 'o-', 'LineWidth', 2, 'MarkerSize', 5);
title('Serie de Fibonacci');
xlabel('Índice');
ylabel('Valor');
grid on; % Añadir una cuadrícula al gráfico