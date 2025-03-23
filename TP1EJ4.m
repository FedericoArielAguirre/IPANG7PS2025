% Ejercicio 4-TP1 

% Borramos las variables previas y la ventana de comandos
clc
clear

% Parámetros
F_promedio           = 10;     % Fuerza promedio en N
F_error              = 1;      % Error en la fuerza en N
m                    = 160;    % Masa de la barra en kg
pulsos_por_segundo   = 500;    % Pulsos por segundo
movimiento_por_pulso = 0.1e-3; % Movimiento por pulso en m

% Cálculo de la aceleración
a_promedio  = F_promedio / m;    % Aceleración promedio
a_error     = F_error / m;       % Error en la aceleración

% Cálculo de la velocidad máxima
v_max = pulsos_por_segundo * movimiento_por_pulso; % Velocidad máxima en m/s

% Cálculo del error en la velocidad
t       = 1;                            % Tiempo en segundos (puede ser ajustado)
error_v = a_promedio * t + a_error * t; % Error total en la velocidad

% Cálculo de la posición
x0      = 0;                               % Posición inicial
x       = x0 + 0 + 0.5 * a_promedio * t^2; % Posición final
error_x = 0.5 * a_error * t^2;             % Error en la posición

% Resultados
fprintf('Aceleración promedio: %.4f m/s^2\n', a_promedio);
fprintf('Error en la aceleración: %.4f m/s^2\n', a_error);
fprintf('Velocidad máxima: %.4f m/s\n', v_max);
fprintf('Error en la velocidad: %.4f m/s\n', error_v);
fprintf('Posición final: %.4f m\n', x);
fprintf('Error en la posición: %.4f m\n', error_x);

% Análisis de los misfires
misfires_percentage = 0.05; % 5% de misfires
effective_pulsos    = pulsos_por_segundo * (1 - misfires_percentage);
v_max_misfires      = effective_pulsos * movimiento_por_pulso; % Nueva velocidad máxima
fprintf('Velocidad máxima con misfires: %.4f m/s\n', v_max_misfires);

% Cálculo del tiempo para alcanzar la velocidad máxima
t_aceleracion = v_max / a_promedio; % Tiempo para alcanzar la velocidad máxima
fprintf('Tiempo para alcanzar la velocidad máxima: %.4f s\n', t_aceleracion);

% Repetir el análisis con 1000 pulsos por segundo
pulsos_por_segundo_1000 = 1000; % Pulsos por segundo
v_max_1000              = pulsos_por_segundo_1000 * movimiento_por_pulso; % Velocidad máxima en m/s
t_aceleracion_1000      = v_max_1000 / a_promedio; % Tiempo para alcanzar la velocidad máxima

% Resultados
fprintf('Velocidad máxima con 1000 pulsos: %.4f m/s\n', v_max_1000);
fprintf('Tiempo para alcanzar la velocidad máxima con 1000 pulsos: %.4f s\n', t_aceleracion_1000);