% Ejercicio Hora - Clase 2

% Borramos la ventana de comandos y las variables previas
clc
clear

% Definimos la variable
hora = (input('Qué hora es? \n'));
hora_limite = 13;
if hora > hora_limite
    disp('Terminá la clase')
    else 
    disp('Hacé tiempo');
end 
