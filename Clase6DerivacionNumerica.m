% Clase 6 Derivación Numérica
clc; clear; close all;
x   = 0:0.05:6;
y   = sin(x);
plot(x, y, 'ro');

% Determinar si son espaciados 
tol  = 0.01; 
flag = 0;
n    = length(x);
h    = x(2)-x(1);
for i=2:n-1
e    = abs(((x(i+1) - x(i)) - h) / h);
    if e > tol
        flag = 1; % si no son equiespaciados, flag se torna 1
        break;
    end
end
% 2) Calcular la derivada primera
% 2.1) Para el primer dato, derivada progresiva
derivada(1) = (y(2) - y(1))/(x(2) - x(1));
% 2.2) Para el último dato, derivada regresiva
derivada(n) = (y(n) - y(n-1))/(x(n) - x(n-1));
% 2.3) Para todos los puntos intermedios, la aproximacion a la derivada centrada
for i = 2:n-1
    derivada(i)= (y(i+1) - y(i-1))/(x(i+1) - x(i-1));
end
% 3) Calcular la derivada segunda
% 3.1) Para el primer dato, derivada progresiva
d2(1)=(derivada(2) - derivada(1))/(x(2) - x(1));
% 3.2) Para el último dato, derivada regresiva
d2(n)=(derivada(n) - derivada(n-1))/(x(n) - x(n-1));
% 3.3) Para los puntos del medio
% 3.3.1) si los puntos son equiespaciados(flag=0)
if flag == 0
    for i = 2:n-1
    d2(i) = (y(i-1) - 2*y(i) + y(i+1)) / (x(i) - x(i-1)^2);
    end
else
    for i=2:n-1
    d2(i)=(derivada(i+1)-derivada(i-1))/(x(i+1) - x(i-1));
    end
end
d1_real = cos(x);
d2_real = -sin(x);
errord1 = derivada - d1_real;
errord2 = d2 - d2_real;

figure(2);
plot(x,errord1);

figure(3); 
plot(x,errord2);

