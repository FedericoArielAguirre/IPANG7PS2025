% Ejercicio 5-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definir los puntos de datos
X = [0, 0.5, 1, 1.5, 2];    % Puntos en el eje X
Y = [0, 0.25, 1, 2.25, 4];  % Valores de la función en esos puntos (por ejemplo, f(x) = x^2)

% Elegir el número de puntos de Gauss a utilizar
n_puntos = 3; % Puede ser 2, 3, 4, 5 o 6

% Llamar a la función para calcular la integral
resultado = gauss_integration_general(X, Y, n_puntos);

% Mostrar el resultado
if isnan(resultado)
    fprintf('No se pudo calcular la integral.\n');
else
    fprintf('La integral del conjunto de datos utilizando el método de Gauss es: %.4f\n', resultado);
end

function resultado = gauss_integration_general(X, Y, n_puntos)
    % Función que integra un conjunto de datos (X, Y) utilizando el método de Gauss.
    % X: vector de puntos en el eje X.
    % Y: vector de valores de la función en esos puntos.
    % n_puntos: número de puntos de Gauss a utilizar para la integración.

    % Paso 1: Verificar que la longitud de X e Y sea la misma
    if length(X) ~= length(Y)
        error('Los vectores X e Y deben tener la misma longitud.');
    end

    % Inicializar el resultado de la integral
    resultado = 0;

    % Paso 2: Subdividir el conjunto de puntos en subintervalos
    n = length(X);
    if mod(n, n_puntos) ~= 0
        % Si no es múltiplo, ajustar el número de puntos
        warning('El número de puntos no es múltiplo de la cantidad de puntos de Gauss. Se ajustará el número de puntos.');
        n = floor(n / n_puntos) * n_puntos; % Ajustar a múltiplo más cercano
    end

    % Calcular la integral en cada subintervalo
    for i = 1:n_puntos:n
        % Definir los límites del subintervalo
        lim_inf = X(i);
        lim_sup = X(min(i + n_puntos - 1, n)); % Asegurarse de no exceder el tamaño de X

        % Llamar a la función de integración de Gauss
        integral_subintervalo = gauss_integration(@(x) interp1(X, Y, x, 'linear', 'extrap'), lim_inf, lim_sup, n_puntos);
        
        % Manejar posibles errores
        if isnan(integral_subintervalo)
            fprintf('Error al calcular la integral en el subintervalo [%f, %f].\n', lim_inf, lim_sup);
            resultado = NaN;
            return;
        end
        
        % Sumar la integral del subintervalo al resultado total
        resultado = resultado + integral_subintervalo;
    end

    % Paso 6: Comparación con el método de trapecios
    resultado_trapecios   = integral_trapecios(X, Y, n);
    diferencia_porcentual = abs((resultado - resultado_trapecios) / resultado_trapecios) * 100;
    
    fprintf('Diferencia porcentual entre Gauss y Trapecios: %.4f%%\n', diferencia_porcentual);
end

function resultado = gauss_integration(funcion, lim_inf, lim_sup, n_puntos)
    % Función que calcula la integral de 'funcion' en el intervalo [lim_inf, lim_sup]
    % utilizando el método de integración de Gauss con n_puntos.
    
    % Definir los pesos y las posiciones de los puntos de Gauss
    switch n_puntos
        case 2
            w = [1, 1]; % Pesos
            z = [0.5773502, -0.5773502]; % Raíces
        case 3
            w = [0.5555555555555556, 0.8888888888888888, 0.5555555555555556]; % Pesos
            z = [0.7745966692414834, 0, -0.7745966692414834]; % Raíces
        case 4
            w = [0.3478548451374539, 0.6521451548625461, 0.6521451548625461, 0.3478548451374539]; % Pesos
            z = [0.8611363115940526, 0.3399810435848563, -0.3399810435848563, -0.8611363115940526]; % Raíces
        case 5
            w = [0.2369268850561891, 0.4786286704993665, 0.5688888888888889, 0.4786286704993665, 0.2369268850561891]; % Pesos
            z = [0.9061798459386639, 0.5384693101056831, 0, -0.5384693101056831, -0.9061798459386639]; % Raíces
        case 6
            w = [0.1713244923791703, 0.3607615730481386, 0.4679139345726910, 0.4679139345726910, 0.3607615730481386, 0.1713244923791703]; % Pesos
            z = [0.9324695142031521, 0.6612093864662645, 0.2386191860831969, -0.2386191860831969, -0.6612093864662645, -0.9324695142031521]; % Raíces
        otherwise
            error('Número de puntos no válido. Debe ser entre 2 y 6.');
    end
    
    % Cambiar el intervalo [lim_inf, lim_sup] a [-1, 1]
    % y calcular la integral
    resultado = 0;
    for i = 1:n_puntos
        % Transformar las raíces de Gauss al intervalo [lim_inf, lim_sup]
        x_i       = 0.5 * (lim_sup - lim_inf) * z(i) + 0.5 * (lim_sup + lim_inf);
        resultado = resultado + w(i) * funcion(x_i);
    end
    resultado = resultado * 0.5 * (lim_sup - lim_inf); % Escalar el resultado al intervalo original
end

function resultado = integral_trapecios(X, Y, n)
    % Función que calcula la integral utilizando el método de trapecios
    resultado = 0;
    for i = 1:n-1
        h         = X(i+1) - X(i);
        resultado = resultado + (Y(i) + Y(i+1)) * h / 2;
    end
end 
% ### Explicación de la Función de Integración Generalizada
% 
% 1. **Verificación de Longitudes**: Se asegura que los vectores 
% `X` e `Y` tengan la misma longitud, lanzando un error si no es así.
% 
% 2. **Inicialización del Resultado**: Se inicializa la variable
% `resultado` que almacenará el valor total de la integral.
% 
% 3. **Subdivisión de Puntos**: Se verifica si el número de puntos
% es múltiplo del número de puntos de Gauss especificado. 
% Si no lo es, se ajusta el número de puntos a un múltiplo más cercano.
% 
% 4. **Cálculo de Integrales en Subintervalos**: Se itera sobre los
% puntos en pasos del número de puntos de Gauss, definiendo límites
% para cada subintervalo y llamando a la función `gauss_integration`
% para calcular la integral en ese intervalo.
% 
% 5. **Manejo de Errores**: Si la función de integración devuelve `NaN`
% , se imprime un mensaje de error y se devuelve `NaN` como resultado.
% 
% 6. **Suma de Integrales**: Se acumulan los resultados de cada 
% subintervalo en la variable `resultado`.
% 
% 7. **Comparación con Trapecios**: Se calcula la integral usando
% el método de trapecios y se determina la diferencia porcentual entre
% los resultados de ambos métodos, mostrando esta diferencia en la consola.
% 
% ### Consideraciones Adicionales
% 
% - Asegúrate de que la función `gauss_integration` y `integral_trapecios`
% estén correctamente definidas y accesibles en el mismo espacio de trabajo.
% - La función está diseñada para ser flexible y puede adaptarse a 
% diferentes conjuntos de datos y números de puntos de Gauss, lo que la 
% hace útil para una amplia gama de aplicaciones en análisis numérico.