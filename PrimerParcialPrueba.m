% Primer Parcial 05-04-25

% Limpiamos el espacio de trabajo
clc
clear
close all

% Definimos las variables
m                = 2700;   % masa en kg
velocidad_limite = 10;     % velocidad límite en m/s
delta_tiempo     = 0.1;    % en seg

% Condiciones iniciales
h_inicial = 45000;  % en m
v_inicial = 5000;   % en m/s

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

% Sistema de referencias
%  ↑               ↑ \sum F  + 
%  |                ---nave---
%  |                 --------
%  |                 ↓ v_{i} -
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
    % Calcular el empuje neto en función de la altura actual
    F(i)           = h(i)/45000*1.49171e6;
    
    % Calcular aceleración usando la ecuación \sum F_{e} = m * a
    aceleracion(i) = F(i)/m;
    
    % Actualizar tiempo
    tiempo(i+1)    = tiempo(i) + delta_tiempo;
    
    % Actualizar velocidad usando la ecuación v_{f} = v_{i} + a * \Delta t
    % Nota: signo negativo porque el movimiento es hacia abajo
    velocidad(i+1) = velocidad(i) - aceleracion(i)*delta_tiempo;
    
    % Actualizar posición usando la ecuación \Delta e = v_{i} * \Delta t + \frac{1}{2} * a * \Delta t^{2}
    h(i+1)         = h(i) - velocidad(i)*delta_tiempo - 0.5*aceleracion(i)*delta_tiempo^2;
    
    % Si la altura es negativa, hacer un ajuste para calcular el punto exacto de impacto
    if h(i+1) < 0
        % Calcular el tiempo exacto en que h = 0 usando interpolación lineal
        fraccion_tiempo = h(i)/(h(i) - h(i+1));
        tiempo_ajustado = delta_tiempo * fraccion_tiempo;
        
        % Recalcular la velocidad final en el instante exacto del impacto
        velocidad_final = velocidad(i) - aceleracion(i)*tiempo_ajustado;
        
        % Actualizar valores finales
        h(i+1)          = 0;
        velocidad(i+1)  = velocidad_final;
        tiempo(i+1)     = tiempo(i) + tiempo_ajustado;
    end
    
    % Incrementar contador
    i = i + 1;
end

% Recortar arrays al tamaño utilizado
num_pasos   = i;
h           = h(1:num_pasos);
velocidad   = velocidad(1:num_pasos);
aceleracion = aceleracion(1:num_pasos-1); % Una menos porque no calculamos aceleración para el último punto
F           = F(1:num_pasos-1);
tiempo      = tiempo(1:num_pasos);

% Evaluación de las tres condiciones específicas
if h(end) == 0 && abs(velocidad(end)) > velocidad_limite
    condicion   = 1; % Aluniza y golpea muy fuerte
    mensaje     = ['CONDICIÓN 1: Alunizaje fallido. Velocidad de impacto: ', num2str(abs(velocidad(end))), ' m/s'];
elseif h(end) == 0 && abs(velocidad(end)) <= velocidad_limite
    condicion   = 2; % Aluniza y pegue por debajo de la velocidad límite
    mensaje     = ['CONDICIÓN 2: Alunizaje exitoso. Velocidad de impacto: ', num2str(abs(velocidad(end))), ' m/s'];
elseif h(end) > 0
    condicion   = 3; % No toque y no llegue
    mensaje     = 'CONDICIÓN 3: La nave no llegó a la superficie lunar.';
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
plot(tiempo(1:end-1), velocidad(1:end-1), 'r-');
title('Velocidad vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Velocidad (m/s)');
grid on;
yline(velocidad_limite, 'k--', 'Velocidad límite', 'LineWidth', 1.5);
yline(-velocidad_limite, 'k--', 'LineWidth', 1.5);

subplot(4,1,3);
plot(tiempo(1:end-1), aceleracion, 'g-');
title('Aceleración vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Aceleración (m/s²)');
grid on;

subplot(4,1,4);
plot(tiempo(1:end-1), F, 'm-');
title('Empuje vs Tiempo');
xlabel('Tiempo (s)');
ylabel('Empuje (N)');
grid on;

% Mensaje de resultado en el título
sgtitle(['Simulación de alunizaje - ' mensaje], 'FontWeight', 'bold');

% Análisis de error
% Si el radioaltímetro tiene un error relativo del 0.1%,
% calculamos cómo afecta a la velocidad final

% Preasignación para los casos con error
h_error_pos     = zeros(1, max_iter);
vel_error_pos   = zeros(1, max_iter);
h_error_neg     = zeros(1, max_iter);
vel_error_neg   = zeros(1, max_iter);

% Simulación con error positivo (+0.1%)
h_error_pos(1)   = h_inicial * 1.001;
vel_error_pos(1) = v_inicial;
i_pos            = 1;

while h_error_pos(i_pos) > 0 && i_pos < max_iter
    F_error_pos            = h_error_pos(i_pos)/45000*1.49171e6;
    accel_error_pos        = F_error_pos/m;
    
    vel_error_pos(i_pos+1) = vel_error_pos(i_pos) - accel_error_pos*delta_tiempo;
    h_error_pos(i_pos+1)   = h_error_pos(i_pos) - vel_error_pos(i_pos)*delta_tiempo - 0.5*accel_error_pos*delta_tiempo^2;
    
    if h_error_pos(i_pos+1) < 0
        fraccion_tiempo        = h_error_pos(i_pos)/(h_error_pos(i_pos) - h_error_pos(i_pos+1));
        vel_final_pos          = vel_error_pos(i_pos) - accel_error_pos*delta_tiempo*fraccion_tiempo;
        h_error_pos(i_pos+1)   = 0;
        vel_error_pos(i_pos+1) = vel_final_pos;
    end
    
    i_pos = i_pos + 1;
end

% Simulación con error negativo (-0.1%)
h_error_neg(1)   = h_inicial * 0.999;
vel_error_neg(1) = v_inicial;
i_neg            = 1;

while h_error_neg(i_neg) > 0 && i_neg < max_iter
    F_error_neg            = h_error_neg(i_neg)/45000*1.49171e6;
    accel_error_neg        = F_error_neg/m;
    
    vel_error_neg(i_neg+1) = vel_error_neg(i_neg) - accel_error_neg*delta_tiempo;
    h_error_neg(i_neg+1)   = h_error_neg(i_neg) - vel_error_neg(i_neg)*delta_tiempo - 0.5*accel_error_neg*delta_tiempo^2;
    
    if h_error_neg(i_neg+1) < 0
        fraccion_tiempo        = h_error_neg(i_neg)/(h_error_neg(i_neg) - h_error_neg(i_neg+1));
        vel_final_neg          = vel_error_neg(i_neg) - accel_error_neg*delta_tiempo*fraccion_tiempo;
        h_error_neg(i_neg+1)   = 0;
        vel_error_neg(i_neg+1) = vel_final_neg;
    end
    
    i_neg = i_neg + 1;
end

% Recortar arrays
vel_error_pos = vel_error_pos(1:i_pos);
vel_error_neg = vel_error_neg(1:i_neg);

% Calcular error absoluto en la velocidad de impacto
error_abs_vel_pos = abs(vel_error_pos(end) - velocidad(end));
error_abs_vel_neg = abs(vel_error_neg(end) - velocidad(end));
error_abs_vel     = max(error_abs_vel_pos, error_abs_vel_neg);

disp(['Error absoluto en la velocidad de impacto: ', num2str(error_abs_vel), ' m/s']);

% Diagrama de flujo para análisis de error
figure(2);
bar([abs(velocidad(end)), abs(vel_error_pos(end)), abs(vel_error_neg(end))]);
xticklabels({'Velocidad nominal', 'Error +0.1%', 'Error -0.1%'});
title('Efecto del error del radioaltímetro en la velocidad de impacto');
ylabel('Velocidad de impacto (m/s)');
yline(velocidad_limite, 'r--', 'Velocidad límite', 'LineWidth', 1.5);
grid on;

% Diagrama de flujo para el cálculo del error absoluto
figure(3);
plot([-0.1, 0, 0.1], [abs(vel_error_neg(end)), abs(velocidad(end)), abs(vel_error_pos(end))], 'o-', 'LineWidth', 2);
xlabel('Error relativo en la altitud inicial (%)');
ylabel('Velocidad de impacto (m/s)');
title('Cota de error absoluto en velocidad de impacto');
grid on;