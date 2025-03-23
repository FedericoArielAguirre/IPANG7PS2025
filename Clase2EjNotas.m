% Ejercicio Notas - Clase 2

% Borramos la ventana de comandos y las variables previas
clc
clear

% Definimos las variables
nota = input('Ingrese su nota: \n');

% Verificamos el rango de la nota
if nota >= 5.5 && nota <= 10
    disp('Felicitaciones! Promocionaste Introducción a la programación y Análisis Numérico.');
elseif nota >= 4 && nota < 5.5
    disp('Tenés que rendir el examen final de la materia.');
elseif nota >= 0 && nota < 4
    disp('Tenés que recursar la materia.');
else
    disp('Nota no válida. Por favor, ingrese una nota entre 0 y 10.');
end