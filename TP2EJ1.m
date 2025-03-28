% Ejercicio 1-TP2 

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% a) Construir el polinomio interpolante sin usar vander
% Definimos los datos
meses = [1, 2, 3, 4, 6, 7, 9, 12]; % Representación de los meses
pesos = [95, 95.5, 97.2, 97, 97.6, 98, 101, 103.3]; % Pesos correspondientes

% Construimos manualmente la matriz de Vandermonde
n = length(meses);
V = zeros(n, n); % Matriz inicializada con ceros
for i = 1:n
    for j = 1:n
        V(i, j) = meses(i)^(j-1);
    end
end

% Calculamos los coeficientes del polinomio interpolante
coeficientes_vandermonde = V \ pesos'; % Resolvemos el sistema V * coef = pesos

% Mostramos los coeficientes
disp('Coeficientes del polinomio interpolante (Matriz construida manualmente):');
disp(coeficientes_vandermonde);

% Llamamos a la función para obtener los coeficientes de Newton
coeficientes_newton = polinomioNewton(meses, pesos);
disp('Coeficientes del polinomio interpolante (Newton):');
disp(coeficientes_newton);

% b) Función para construir el polinomio interpolante de Newton
function coeficientes = polinomioNewton(x, y)
    n = length(x);
    % Inicializamos la tabla de diferencias divididas
    diferencias = zeros(n, n);
    diferencias(:, 1) = y'; % Primera columna con los valores de y

    % Calculamos las diferencias divididas
    for j = 2:n
        for i = 1:n-j+1
            diferencias(i, j) = (diferencias(i+1, j-1) - diferencias(i, j-1)) / (x(i+j-1) - x(i));
        end
    end

    % Los coeficientes del polinomio de Newton son la primera fila de diferencias
    coeficientes = diferencias(1, 1:n);
end


% c) ¿Qué diferencias hay entre ambos polinomios interpolantes?
% Los polinomios interpolantes de Vandermonde y de Newton son equivalentes
% en el sentido de que ambos interpolan los mismos puntos. Sin embargo,
% la forma en que se construyen es diferente. El polinomio de Vandermonde
% se obtiene directamente a partir de la matriz de Vandermonde, mientras
% que el polinomio de Newton se construye a partir de diferencias divididas,
% lo que puede ser más eficiente si se añaden más puntos, ya que no es necesario
% recalcular todo el polinomio.

% d) ¿Qué habría que hacer para reconstruir el polinomio de Newton si se agrega un punto el conjunto de datos?
% Si se agrega un nuevo punto, solo se necesita calcular la nueva diferencia
% dividida para ese punto y actualizar la tabla de diferencias. No es necesario
% recalcular todo el polinomio desde cero.

% ¿Y si se cambia de abscisa?
% Si se cambia la abscisa de un punto existente, se debe recalcular la tabla
% de diferencias divididas desde el punto que se ha modificado hacia adelante,
% ya que esto afectará a las diferencias divididas de los puntos posteriores.