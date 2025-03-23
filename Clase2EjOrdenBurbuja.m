% Ejercicio Orden Burbuja - Clase 2 

% Borramos las variables y la ventana de comandos
clc
clear

% Ordenamiento de la burbuja (menor a mayor)

% Defino la matriz y las variables
numeros = [42 4 67 2 5 7 5 12 98 37];
n = length(numeros);
cambios  = 0;

% Inicializo el flag
ordenado = false;

% Bucle while para el ordenamiento
while ~ordenado
    ordenado = true; % Asumimos que está ordenado
    for i = 1:n-1
        if numeros(i) > numeros(i+1)
            % Intercambio
            temporal     = numeros(i);
            numeros(i)   = numeros(i+1);
            numeros(i+1) = temporal;
            ordenado     = false; % Se realizó un intercambio, no está ordenado
            cambios      = cambios+1;
        end
    end
end

disp('La matriz de numeros ordenados de menor a mayor es:');
disp(numeros);
disp('La cantidad de cambios ocurridos es: ');
disp(cambios);