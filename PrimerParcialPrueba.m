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
% Estimamos el número máximo de iteraciones (conservador)
max_iter    = 100000;
h           = zeros(1, max_iter);
velocidad   = zeros(1, max_iter);
aceleracion = zeros(1, max_iter);
F           = zeros(1, max_iter);
tiempo      = zeros(1, max_iter);

% Inicialización de variables
h(1)         = h_inicial;
velocidad(1) = v_inicial;
tiempo(1)    = 0;
F(1)         = h(1)/45000*1.49171e6;     % fuerza en N
aceleracion(1) = F(1)/m;                 % aceleración en m/s²

% Sistema de referencias
%  ↑               
%  |                
%  |                 
%  | ↑ v_{i} + (positivo hacia arriba)
%  |
%  |-------
%  |  Luna |
%  |--------------------------→
%
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
        h(i+1) = 0;
        
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

% Mensaje de resultado en el título
sgtitle(['Simulación de alunizaje - ' mensaje], 'FontWeight', 'bold');

% Ajuste polinomial
figure(2);
plot(tiempo, h, 'b-');
title('Altitud vs Tiempo con ajuste polinomial');
xlabel('Tiempo (s)');
ylabel('Altitud (m)');
grid on;

% Se usa un polinomio de orden 6 para el ajuste
coef = polyfit(tiempo, h, 6);
t_denso = linspace(0, tiempo(end), 1000);
h_denso = polyval(coef, t_denso);

hold on;
plot(t_denso, h_denso, 'g-');
legend('Datos simulados', 'Ajuste polinomial');

% Análisis de error
% Si el radioaltímetro tiene un error relativo del 0.1%,
% calculamos cómo afecta a la velocidad final

% Preasignación para los casos con error
h_error_neg     = zeros(1, max_iter);
vel_error_neg   = zeros(1, max_iter);
F_error_neg     = zeros(1, max_iter);
a_error_neg     = zeros(1, max_iter);
tiempo_error    = zeros(1, max_iter);

% Simulación con error negativo (-0.1%)
h_error_neg(1)   = h_inicial;
vel_error_neg(1) = v_inicial;
tiempo_error(1)  = 0;
F_error_neg(1)   = h_error_neg(1) * 0.999 / 45000 * 1.49171e6;  % Fuerza con error -0.1%
a_error_neg(1)   = F_error_neg(1)/m;

i_neg = 1;

while h_error_neg(i_neg) > 0 && i_neg < max_iter
    % Actualizar posición con error
    h_error_neg(i_neg+1) = h_error_neg(i_neg) + vel_error_neg(i_neg)*delta_tiempo + 0.5*a_error_neg(i_neg)*delta_tiempo^2;
    
    % Actualizar velocidad con error
    vel_error_neg(i_neg+1) = vel_error_neg(i_neg) + a_error_neg(i_neg)*delta_tiempo;
    
    % Calcular la fuerza con error de -0.1% en la medición de altura
    F_error_neg(i_neg+1) = h_error_neg(i_neg+1) * 0.999 / 45000 * 1.49171e6;
    
    % Calcular aceleración con error
    a_error_neg(i_neg+1) = F_error_neg(i_neg+1)/m;
    
    % Actualizar tiempo
    tiempo_error(i_neg+1) = tiempo_error(i_neg) + delta_tiempo;
    
    % Si la altura es negativa, ajustar a cero
    if h_error_neg(i_neg+1) < 0
        h_error_neg(i_neg+1) = 0;
        
        % Calcular el tiempo exacto en que h = 0 usando interpolación lineal
        fraccion_tiempo = h_error_neg(i_neg)/(h_error_neg(i_neg) - h_error_neg(i_neg+1));
        tiempo_ajustado = delta_tiempo * fraccion_tiempo;
        
        % Recalcular la velocidad final en el instante exacto del impacto
        vel_final_neg = vel_error_neg(i_neg) + a_error_neg(i_neg)*tiempo_ajustado;
        
        % Actualizar valores finales
        vel_error_neg(i_neg+1) = vel_final_neg;
        tiempo_error(i_neg+1) = tiempo_error(i_neg) + tiempo_ajustado;
        
        break;
    end
    
    i_neg = i_neg + 1;
end

% Recortar arrays de la simulación con error
num_pasos_error = i_neg+1;
h_error_neg     = h_error_neg(1:num_pasos_error);
vel_error_neg   = vel_error_neg(1:num_pasos_error);
a_error_neg     = a_error_neg(1:num_pasos_error);
F_error_neg     = F_error_neg(1:num_pasos_error);
tiempo_error    = tiempo_error(1:num_pasos_error);

% Mostrar resultados con error
fprintf('La altura final con error en la medición de la altura es %f\n', h_error_neg(end));

if h_error_neg(end) == 0 && abs(vel_error_neg(end)) > velocidad_limite
    mensaje_error = ['Alunizaje fallido con error. Velocidad de impacto: ', num2str(abs(vel_error_neg(end))), ' m/s'];
    fprintf('La velocidad de alunizaje con error en la medicion de la altura es %1.2f, superior a 10 m/s, por lo que el alunizaje es fallido\n', abs(vel_error_neg(end)));
elseif h_error_neg(end) == 0 && abs(vel_error_neg(end)) <= velocidad_limite
    mensaje_error = ['Alunizaje exitoso con error. Velocidad de impacto: ', num2str(abs(vel_error_neg(end))), ' m/s'];
    fprintf('La velocidad de alunizaje con error en la medicion de la altura es %1.2f, menor o igual a 10 m/s, por lo que el alunizaje es exitoso\n', abs(vel_error_neg(end)));
else
    mensaje_error = 'La nave con error no llegó a la superficie lunar.';
    fprintf('La nave no llega a tocar la superficie\n');
end

% Calcular error absoluto en la velocidad de impacto
error_abs_vel = abs(vel_error_neg(end) - velocidad(end));
disp(['Error absoluto en la velocidad de impacto: ', num2str(error_abs_vel), ' m/s']);

% Diagrama de barras para comparar velocidades de impacto
figure(3);
bar([abs(velocidad(end)), abs(vel_error_neg(end))]);
xticklabels({'Velocidad nominal', 'Error -0.1%'});
title('Efecto del error del radioaltímetro en la velocidad de impacto');
ylabel('Velocidad de impacto (m/s)');
yline(velocidad_limite, 'r--', 'Velocidad límite', 'LineWidth', 1.5);
grid on;

% Comparación gráfica de los resultados
figure(4);
subplot(2,1,1);
plot(tiempo, h, 'b-', tiempo_error, h_error_neg, 'r--');
title('Comparación de altitud con y sin error');
xlabel('Tiempo (s)');
ylabel('Altitud (m)');
legend('Sin error', 'Con error -0.1%');
grid on;

subplot(2,1,2);
plot(tiempo, abs(velocidad), 'b-', tiempo_error, abs(vel_error_neg), 'r--');
title('Comparación de velocidad con y sin error');
xlabel('Tiempo (s)');
ylabel('Velocidad absoluta (m/s)');
legend('Sin error', 'Con error -0.1%');
grid on;
yline(velocidad_limite, 'k--', 'Velocidad límite', 'LineWidth', 1.5);
