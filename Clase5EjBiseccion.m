% Ejercicio Bisección - Clase 5

% Borramos las variables previas y la ventana de comandos
clc
clear

% Defino la funcion y sus variables: 
f    = @(x) sin(x).*x.^2;                        % funcion del enunciado
a    = input('Ingrese el límite izquierdo: \n'); % comienzo intervalo
b    = input('Ingrese el límite derecho: \n');   % cierre intervalo
tol1 = input('Ingrese la tolerancia 1: \n');     % tolerancia 1
tol2 = input('Ingrese la tolerancia 2: \n');     % tolerancia 2

% Llamo a la funcion bisección
[raiz, iteraciones, error1, error2] = biseccion_metodo(f, a, b, tol1, tol2);% llamamos funcion y le paso los parametros
fprintf('La raíz encontrada es: %f\n', raiz);                               % imprime raiz
fprintf('Número de iteraciones: %d\n', iteraciones);                        % imprime interaciones
fprintf('El error 1 es: %f\n', error1);                                     % imprime error 1
fprintf('El error 2 es: %f\n', error2);                                     % imprime error 2
% Graficar la funcion y el resultado esperado
figure;                                                             % Crear una nueva figura
fplot(f, [a, b]);                                                   % Graficar la función en el intervalo [a, b]
hold on;                                                            % Mantener la gráfica actual
plot(raiz, f(raiz), 'ro', 'MarkerSize', 10, 'DisplayName', 'Raíz'); % Marcar la raíz en rojo
xlabel('x'); ylabel('f(x)');                                        % Etiquetas de los ejes                                                     % Etiqueta del eje y
title('Gráfica de la función y la raíz encontrada');                % Título de la gráfica
legend('Location', 'southwest', 'FontSize', 10);                    % Mostrar leyenda
grid on;                                                            % Activar la cuadrícula
hold off;                                                           % Liberar la gráfica

% (b - a)/2 > tol1 || (abs(f(a)) > tol2 && abs(f(b)) > tol2)

function [raiz, iteraciones, error1, error2] = biseccion_metodo(f, a, b, tol1, tol2)
    % Verificar que f(a) y f(b) tengan signos opuestos
    if f(a) * f(b) > 0
        error('No hay raíz o raíces pares');
    end
    iteraciones = 0;        % Inicializo contador iteraciones
    error1      = tol1 + 1; % Inicializo error 1
    error2      = tol2 + 1; % Inicializo error 2
    while error1 > tol1 || error2 > tol2 
        iteraciones = iteraciones + 1;
        c           = (a + b)/2;
        if f(c) == 0
            break;
        elseif f(a) * f(c) < 0
            b = c;
        else
            a = c;
        end
        error1 = abs(b - a);
        error2 = abs(f(c));
    end
    raiz       = (a + b)/2;  
end