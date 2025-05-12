% r = suma(4,7);
% disp(r);
% function a = suma(x,y)
% a=2;
% end

clc; clear; close all;



[resultado] = suma(num_1,num_2);

function [resultado]=suma(num_1,num_2)
resultado=0;
num_1 = input("Ingrese el primer valor: \n");
num_2 = input("Ingrese el segundo valor: \n");
resultado=num_1+num_2;
fprintf("El resultado de la suma de los núneros ingresados es: %d \n",resultado);
end

function resultado = funcion_de_funcion(funcion,x_eval, potencia)
resultado = (funcion(x_eval.^potencia));
end
%Ejercicio de suma