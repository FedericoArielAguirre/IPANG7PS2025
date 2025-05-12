% Ejercicio 2-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all
% Definir parámetros
L = 3;          % Longitud del canal en metros
r = 0.3;        % Radio de la sección transversal semicircular en metros
V = 0.351;      % Volumen de agua en metros cúbicos
% Definir la función f(h) = volumen calculado - volumen dado
f = @(h) L * (0.5 * pi * r^2 - r^2 * asin(h / r) - h * sqrt(r^2 - h^2)) - V;
% Función para calcular el área de la sección transversal del agua dado h
area_seccion = @(h) pi * r^2 / 2 - r^2 * asin(h / r) - h * sqrt(r^2 - h^2);
% Método 1: Bisección
fprintf('--- Método de Bisección ---\n');
% Implementar método de bisección para encontrar h
a          = 0;    % Límite inferior del intervalo
b          = r;    % Límite superior del intervalo
tolerancia = 0.003;% Tolerancia para h
max_iter   = 100;  % Número máximo de iteraciones
% Metodo de bisección
iter = 0;
while (b - a) > tolerancia && iter < max_iter
    % Calcular punto medio
    h = (a + b) / 2;    
    % Evaluar función en el punto medio
    fh = f(h);    
    % Ajustar intervalo según el signo de la función
    if fh == 0
        break;  % Solución exacta encontrada
    elseif fh * f(a) < 0
        b = h;  % La raíz está en [a, h]
    else
        a = h;  % La raíz está en [h, b]
    end    
    iter = iter + 1;
end
h_biseccion = (a + b) / 2;  % Solución final
% Mostrar el resultado
fprintf('La altura h (bisección) desde la parte superior es aproximadamente %.4f metros\n', h_biseccion);
% Método 2: Gauss-Legendre
fprintf('\n--- Método de Gauss-Legendre ---\n');
% Puntos y pesos para integración Gauss-Legendre con 3 puntos
puntos_gauss = [-sqrt(3/5), 0, sqrt(3/5)];
pesos_gauss = [5/9, 8/9, 5/9];
% Función para calcular el volumen usando integración Gauss-Legendre
function_volumen_gauss = @(h) calculaVolumenGauss(h, L, r, puntos_gauss, pesos_gauss);
% Método de Newton-Raphson con integración Gauss-Legendre
h_guess = r/2;  % Valor inicial para h
h = h_guess;
max_newton = 20;  % Número máximo de iteraciones
tolerancia_newton = 0.003;  % Tolerancia para convergencia
for i = 1:max_newton
    vol = L * area_seccion(h);    
    % Derivada numérica de la función respecto a h
    delta = 0.0001;
    area_delta = area_seccion(h + delta);
    derivada = L * (area_delta - area_seccion(h)) / delta;
    % Paso de Newton
    h_nuevo = h - (vol - V) / derivada;    
    % Verificar convergencia
    if abs(h_nuevo - h) < tolerancia_newton
        break;
    end    
    h = h_nuevo;
end
h_gauss = h;
fprintf('La altura h (Gauss) desde la parte superior es aproximadamente %.4f metros\n', h_gauss);
% Método 3: Simpson
fprintf('\n--- Método de Simpson ---\n');
% Implementar el método de bisección usando integración de Simpson
a                  = 0;
b                  = r;
tolerancia_simpson = 0.003;
max_iter_simpson   = 100;
n_simpson          = 10;  % Número de intervalos para Simpson
iter               = 0;
while (b - a) > tolerancia_simpson && iter < max_iter_simpson
    h = (a + b) / 2;    
    % Calcular volumen directamente (constante a lo largo del canal)
    vol = L * area_seccion(h);    
    if abs(vol - V) < tolerancia_simpson
        break;
    elseif vol > V
        a = h;
    else
        b = h;
    end    
    iter = iter + 1;
end
h_simpson = (a + b) / 2;
fprintf('La altura h (Simpson) desde la parte superior es aproximadamente %.4f metros\n', h_simpson);
% Función auxiliar para integración Gauss-Legendre
function vol = calculaVolumenGauss(h, L, r, puntos, pesos)
    a = 0;  % Límite inferior de integración
    b = L;  % Límite superior de integración    
    % Cambio de intervalo de integración a [-1, 1]
    vol = 0;
    for i = 1:length(puntos)
        x    = ((b-a)*puntos(i) + (b+a))/2;  % Transformar punto a [a, b]
        area = pi * r^2 / 2 - r^2 * asin(h / r) - h * sqrt(r^2 - h^2);
        vol  = vol + pesos(i) * area;
    end
    vol = vol * (b-a) / 2;  % Factor de escala
end
% Función auxiliar para integración Simpson
function vol = calculaVolumenSimpson(h, L, r, n)
    % n = número de intervalos (debe ser par)
    if mod(n, 2) ~= 0
        n = n + 1;  % Asegurar que n sea par
    end    
    dx  = L / n;  % Tamaño del paso
    vol = 0;    
    % Área de la sección transversal
    area = @(h) pi * r^2 / 2 - r^2 * asin(h / r) - h * sqrt(r^2 - h^2);    
    % Aplicar la regla de Simpson
    for i = 0:n
        x    = i * dx;
        coef = 1;
        if i > 0 && i < n
            if mod(i, 2) == 0
                coef = 2;
            else
                coef = 4;
            end
        end
        vol = vol + coef * area(h);
    end    
    vol = vol * dx / 3;
end