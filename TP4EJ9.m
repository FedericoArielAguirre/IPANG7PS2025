% Ejercicio 9-TP4
% Borramos las variables previas y la ventana de comandos
clc; clear; close all

% Constantes
A = sym('A'); % Dosis inicial (A)
t = sym('t'); % Variable de tiempo
% Función de concentración
c = A * t * exp(-t/3); % c(t) = A * t * e^(-t/3)

% a) Encontrar la dosis necesaria para la concentración máxima segura (1 mg/ml)
target_concentration = 1; % mg/ml
% Tiempo en el que la concentración alcanza su máximo (derivada = 0)
c_derivative = diff(c, t);
max_time = solve(c_derivative == 0, t); % Esto da t = 3

% Sustituir t = max_time en c para obtener la concentración máxima
c_at_max = subs(c, t, max_time); % c_at_max = A * 3 * exp(-1)
% Resolver para A cuando c_at_max = 1
A_solution = solve(c_at_max == target_concentration, A); % A = 1 / (3 * exp(-1))
% Convertir A_solution a un valor numérico
A_value = double(A_solution); % Aproximadamente 0.9061

% Mostrar resultados para la parte a
disp('--- Parte a ---');
disp(['Cantidad necesaria para alcanzar la concentración segura máxima: ', char(A_solution)]);
disp(['El máximo ocurre a t = ', char(max_time)]);

% b) Nueva dosis para asegurar que la concentración descienda a 0.25 mg/ml
second_dose_time = 0; % Se inicializa en 0 para iniciar el conteo de tiempo
c_new            = A_value * exp(-second_dose_time/3); % Concentración inicial, usando A_value

while c_new > 0.25
    second_dose_time = second_dose_time + 0.1; % Incrementar el tiempo en horas
    c_new = A_value * exp(-second_dose_time/3); % Actualizar concentración
end
second_dose_time_rounded = round(second_dose_time * 60); % Redondear al minuto más cercano

% Mostrar resultados para la parte b
disp('--- Parte b ---');
disp(['La nueva dosis debería administrarse después de ', num2str(second_dose_time_rounded), ' minutos.']);

% c) Considerando que el 75% de la dosis inyectada inicialmente
initial_dose_factor = 0.75; % Factor del 75% de la dosis inicial
initial_dose_amount = A_value * initial_dose_factor; % 75% de la dosis inicial

% Tiempo para la tercera dosis (1 hora después de la segunda dosis, inicialmente)
c_third_dose_time = second_dose_time + 1; % Tiempo en horas desde el inicio
third_dose_time_in_minutes = second_dose_time_rounded + 60; % Tiempo inicial para la tercera dosis en minutos

% Bucle para encontrar el tiempo cuando la concentración total cae por debajo de 0.25
while A_value * exp(-c_third_dose_time/3) + initial_dose_amount * exp(-c_third_dose_time/3) > 0.25
    c_third_dose_time = c_third_dose_time + 0.1;
end
third_dose_time_rounded = round(c_third_dose_time * 60); % Redondear al minuto más cercano

% Mostrar resultados para la parte c
disp('--- Parte c ---');
disp(['Debería administrarse la tercera inyección en ', num2str(third_dose_time_rounded), ' minutos.']);