% Primer Parcial 05-04-25
% Limpiamos el espacio de trabajo
clc
clear all
close all
% Definimos las variables
m                = 2700;   % masa en kg
velocidad_limite = 10;     % velocidad límite en m/s
delta_tiempo     = 0.1;    % en seg
% Condiciones iniciales
h_inicial = 45000;  % en m
v_inicial = -5000;  % en m/s (negativo porque y positivo es hacia arriba)
% Preasignación de memoria para las variables
% Estimamos el número máximo de iteraciones 
max_iter    = 10000;
h           = zeros(1, max_iter);
velocidad   = zeros(1, max_iter);
aceleracion = zeros(1, max_iter);
F           = zeros(1, max_iter);
tiempo      = zeros(1, max_iter);
% Inicialización de variables
h(1)           = h_inicial;
velocidad(1)   = v_inicial;
tiempo(1)      = 0;
F(1)           = h(1)/45000*1.49171e6;   % fuerza en N
aceleracion(1) = F(1)/m;                 % aceleración en m/s²
% Sistema de referencias
%  ↑               
%  |                 
%  | ↑ v_{i} + (positivo hacia arriba)
%  |
%  |-------
%  |  Luna |
%  |--------------------------→
% Ecuaciones del movimiento:
% \sum F_{e} = \frac{d(mv)}{dt} = m * a
% v_{f} = v_{i} + a * \Delta t
% \Delta e = v_{i} * \Delta t + \frac{1}{2} * a * \Delta t^{2}
% Simulación del descenso
i = 1;
while h(i) > 0 && i < max_iter
    % Actualizar posición usando la ecuación \Delta e = v_{i} * \Delta t + \frac{1}{2} * a * \Delta t^{2}
    h(i+1)         = h(i) + velocidad(i)*delta_tiempo + 0.5*aceleracion(i)*delta_tiempo^2;
    % Actualizar velocidad usando la ecuación v_{f} = v_{i} + a * \Delta t
    velocidad(i+1) = velocidad(i) + aceleracion(i)*delta_tiempo;
    % Calcular el empuje neto en función de la altura actual
    F(i+1)         = h(i+1)/45000*1.49171e6;
    % Calcular aceleración usando la ecuación \sum F_{e} = m * a
    aceleracion(i+1) = F(i+1)/m;
    % Actualizar tiempo
    tiempo(i+1)    = tiempo(i) + delta_tiempo;
    % Si la altura es negativa, ajustar a cero
    if h(i+1) < 0
        h(i+1)          = 0;
        % Calcular el tiempo exacto en que h = 0 usando interpolación lineal
        fraccion_tiempo = h(i)/(h(i) - h(i+1));
        tiempo_ajustado = delta_tiempo * fraccion_tiempo;
        % Recalcular la velocidad final en el instante exacto del impacto
        velocidad_final = velocidad(i) + aceleracion(i)*tiempo_ajustado;
        % Actualizar valores finales
        velocidad(i+1)  = velocidad_final;
        tiempo(i+1)     = tiempo(i) + tiempo_ajustado;
        break;
    end
    % Incrementar contador
    i = i + 1;
end
% Recortar arrays al tamaño utilizado
num_pasos   = i+1;
h           = h(1:num_pasos);
velocidad   = velocidad(1:num_pasos);
aceleracion = aceleracion(1:num_pasos);
F           = F(1:num_pasos);
tiempo      = tiempo(1:num_pasos);
% Evaluación de las tres condiciones específicas
fprintf('La altura final es %f\n', h(end));
if h(end) == 0 && abs(velocidad(end)) > velocidad_limite
    condicion   = 1; % Aluniza y golpea muy fuerte
    mensaje     = ['CONDICIÓN 1: Alunizaje fallido. Velocidad de impacto: ', num2str(abs(velocidad(end))), ' m/s'];
    fprintf('La velocidad de alunizaje es %1.2f, superior a 10 m/s, por lo que el alunizaje es fallido\n', abs(velocidad(end)));
elseif h(end) == 0 && abs(velocidad(end)) <= velocidad_limite
    condicion   = 2; % Aluniza y pegue por debajo de la velocidad límite
    mensaje     = ['CONDICIÓN 2: Alunizaje exitoso. Velocidad de impacto: ', num2str(abs(velocidad(end))), ' m/s'];
    fprintf('La velocidad de alunizaje es %1.2f, menor o igual a 10 m/s, por lo que el alunizaje es exitoso\n', abs(velocidad(end)));
elseif h(end) > 0
    condicion   = 3; % No toque y no llegue
    mensaje     = 'CONDICIÓN 3: La nave no llegó a la superficie lunar.';
    fprintf('La nave no llega a tocar la superficie\n');
end
disp(mensaje);
% Gráficas
figure(1);
subplot(4,1,1);
plot(tiempo, h, 'b-');
title('Altitud vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Altitud (m)');
grid on;
subplot(4,1,2);
plot(tiempo, velocidad, 'r-');
title('Velocidad vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Velocidad (m/s)');
grid on;
yline(velocidad_limite, 'k--', 'Velocidad límite', 'LineWidth', 1.5);
yline(-velocidad_limite, 'k--', 'LineWidth', 1.5);
subplot(4,1,3);
plot(tiempo(1:end-1), aceleracion(1:end-1), 'g-');
title('Aceleración vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Aceleración (m/s²)');
grid on;
subplot(4,1,4);
plot(tiempo(1:end-1), F(1:end-1), 'm-');
title('Empuje vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Empuje (N)');
grid on;
% Ajuste polinomial
figure(2);
plot(tiempo, h, 'b-');
title('Altitud vs Tiempo con ajuste polinomial');
xlabel('Tiempo (s)');
ylabel('Altitud (m)');
grid on;
% Se usa un polinomio de orden 6 para el ajuste
coef    = polyfit(tiempo, h, 6);
t_denso = linspace(0, tiempo(end), 1000);
h_denso = polyval(coef, t_denso);
hold on;
plot(t_denso, h_denso, 'g-');
legend('Datos simulados', 'Ajuste polinomial');
% Análisis de error
% Si el radioaltímetro tiene un error relativo del 0.1%,
% calculamos cómo afecta a la velocidad final
m                = 2700;                               % masa de la nave en kg
h2(1)            = 45000;                              % h(1) es la primera altura que se registra.
t2(1)            = 0;                                  % tiempo en segundos. t(1) es el tiempo inicial
dt               = 0.1;                                % Intervalo de tiempo en segundos
velocidad2(1)    = -5000;                              % Velocidad de la nave en m/seg. Negativa por la eleccion del
F2(1)            = h2(1) * 0.999 / 45000 * 1.49171e+6; % fuerza en N.
aceleracion_2(1) = F2(1) / m ;                         % aceleracion en m/seg^2
k                = 1;                                  % inicializo el valor de k
while h2(end) > 0
  h2(k+1)            = h2(k) + velocidad2(k) * dt + 1/2 * aceleracion_2(k) * dt^2 ; % calculo la altura siguiente
  % considerando que la velocidad y la aceleracion son constantes en el intervalo
  velocidad2(k+1)    = velocidad2(k) + aceleracion_2(k) * dt;
  F2(k+1)            = h2(k+1)*0.999 / 45000 * 1.49171e+6;
  aceleracion_2(k+1) = F2(k+1) / m ;
  t2(k+1)            = t2(k) + dt;
  k                  = k + 1;
  % El calculo tiene que terminar si h(k) se hace cero
end
if h2(end) < 0
  h2(end) = 0;
end
fprintf('La altura final con error en la medicion de la altura es %.3f m\n', h2(end));
if (h2(end) == 0) && (abs(velocidad2(end)) <= 10)
  fprintf('La velocidad de alunizaje con error en la medicion de la altura es %1.2f m/s, menor o igual a 10 m/s, por lo que el alunizaje es exitoso\n', abs(velocidad2(end)))
elseif (h2(end) == 0) && (abs(velocidad2(end)) > 10)
  fprintf('La velocidad de alunizaje con error en la medicion de la altura es %1.2f m/s, superior a 10 m/s, por lo que el alunizaje es fallido\n', abs(velocidad2(end)))
else
  fprintf('La nave no llega a tocar la superficie\n')
end
