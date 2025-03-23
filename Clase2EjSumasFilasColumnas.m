% Ejercicio Suma Fila y Columna - Clase 2

% Borramos la ventana de comandos y las variables previas
clc
clear

% Definimos la matriz
A=[1 2 3; 4 5 6; 7 8 9;10 11 12];

% Calculamos la suma de todos elementos de la matriz
 suma     = 0;

 % Opcion 1 con length
 columnas = length(A(:,1));
 filas    = length(A(1,:));

 % Opcion 2 con size

 %size devuelve un vector [a,b] con a=fila, b=columna
 m            =size(A);
 size_filas   =dim(1);
 size_columnas=dim(2);
 
 for i = 1:size(A,1)
     for j = 1:size(A,2)
     suma = suma + A(i,j); 
     end
 end
 fprintf('La suma de los elementos de la matriz es: %d \n',suma);