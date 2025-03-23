% Ejercicio 1-TP1

% Borramos las variables previas y la ventana de comandos
clc
clear

% Definimos las variables
pos_inicial = 100;
pos_final = 5000;
condicion = true;
delta = 0.01;
i = 1; 
pos_barra = pos_inicial;

% Bucle que 
while condicion 
    pos_barra = pos_inicial + i*delta;
    i = i + 1;
    if pos_barra >= pos_final
        condicion = false;
    end 
end

% Mostramos los resultados
disp(i);
disp(pos_barra);

%



%% Diagrama de flujo
% [Start]
%     |
%     v
% [Initialize Variables]
%     |
%     v
% [condicion == true?] -- No --> [End]
%     |
%    Yes
%     |
%     v
% [Calculate pos_barra = pos_inicial + i * delta]
%     |
%     v
% [Increment i = i + 1]
%     |
%     v
% [pos_barra >= pos_final?] -- No --> [While Loop]
%     | 
%    Yes
%     |
%     v
% [Set condicion = false]
%     |
%     v
% [Display i and pos_barra]
%     |
%     v
% [End]
%\

