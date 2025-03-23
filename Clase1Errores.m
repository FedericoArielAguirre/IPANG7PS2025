% Ejercicio error absoluto - relativo - porcentaje

% Borramos la ventana de comandos y las variables previas
clc
clear

% Definimos los valores de las variables
A_a = 22;
b_a = 7;

A_b = 333;
b_b = 106;

A_c = 355;
b_c = 113;

tol = 1e-6; % Definimos el valor de la tolerancia
max_iter = 100; % Definimos el valor de las iteraciones

for i = 1:3
    switch i
        case 1
            A = A_a;
            b = b_a;
        case 2
            A = A_b;
            b = b_b;
        case 3
            A = A_c;
            b = b_c;
    end
    x_aproximado = A / b; 
    % error absoluto exacto menos aproximado
    error_absoluto = pi - x_aproximado;
    % error relativo (exacto - aproximado) / exacto
    error_relativo = (pi - x_aproximado) / pi;
    % error porcentual 100 * (exacto - aproximado) / exacto
    error_porcentual = 100 * error_relativo;
    
    % Cota de error
    cota_error_absoluto = tol; % Cota basada en la tolerancia
    cota_error_relativo = tol / pi; % Cota relativa basada en la tolerancia
    cota_error_porcentual = 100 * cota_error_relativo; % Cota porcentual

    % mostramos los resultados
    fprintf('Caso %d:\n', i);
    fprintf('Error absoluto: %.10f\n', error_absoluto);
    fprintf('Cota de error absoluto: %.10f\n', cota_error_absoluto);
    fprintf('Error relativo: %.10f\n', error_relativo);
    fprintf('Cota de error relativo: %.10f\n', cota_error_relativo);
    fprintf('Error porcentual: %.10f%%\n', error_porcentual);
    fprintf('Cota de error porcentual: %.10f%%\n\n', cota_error_porcentual);
end