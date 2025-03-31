% Ejercicio Polinomio Interpolante Lagrange - Clase 3

%clear % limpia la memoria

% Definimos los vectores
x = [0 2 5 10];
y = [10 22 165 1110];
n = length(x); % Asignamos la longitud del vector x a la variable n

xobj = input('Ingrese el valor para interpolar: \n'); % Permite la entrada de datos por teclado y lo 
resultado = 0; % inicializo la variable resultado como cero

% res     = \sum_{i=1}^{n} f(x_{i}) L_{n,i}(x_{i})
%         = f(x_{1}) L_{1,1}(x_{1})+f(x_{2})L_{1,2}(x_{2}) 	
% L_{n,i} = \prod^{n}_{j=1,i!=j} \frac{(x-x_(j))}{x_(i)-x_(j)}

for i = 1:1:n % Este bucle genera la productoria (varia de i de 1 a n)
  lag    = 1; % inicializo la variable lag como 1 (valor neutro de la multiplicación)
  for j  = 1:1:n % Este bucle genera la productoria (varia de j de 1 a n)
    if i~=j % si i es distinto de j
    lag  = lag*(xobj-x(j))/(x(i)-x(j)); % se agrega el factor a la productoria
    end
  end % cierra el bucle for sobre j
  resultado = resultado + lag*y(i);
end % cierra el bucle for sobre i

disp(resultado); % Muestra el resultado en pantalla
