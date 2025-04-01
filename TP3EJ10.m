% Ejercicio 10-TP3

% Borramos las variables previas y la ventana de comandos
clc
clear
close all

% Definir las funciones integrandos
f1 = @(x) x.^2.*log(x);             % x^2*ln(x)
f2 = @(x) x.^2.*exp(-x);            % x^2*e^(-x)
f3 = @(x) 2./(x.^2-4);              % 2/(x^2-4)
f4 = @(x) x.^2.*sin(x);             % x^2*sin(x)
f5 = @(x) exp(3*x).*sin(2*x);       % e^(3x)*sin(2x)
f6 = @(x) 2*x./(x.^2-4);            % 2x/(x^2-4)
f7 = @(x) 2*x./sqrt(x.^2-4);        % 2x/sqrt(x^2-4)
f8 = @(x) cos(x).^2;                % cos^2(x)

% Límites de integración
a1 = 1;    b1 = 1.5;    % Para f1
a2 = 0;    b2 = 1;      % Para f2
a3 = 0;    b3 = 0.35;   % Para f3
a4 = 0;    b4 = pi/4;   % Para f4
a5 = 0;    b5 = pi/4;   % Para f5
a6 = 1;    b6 = 1.6;    % Para f6
a7 = 3;    b7 = 3.5;    % Para f7
a8 = 0;    b8 = pi/4;   % Para f8

e = exp(1); %valor de exp 

% Valores exactos (calculados analíticamente)
exact1 = ((9*log(3/2))/8)-(19/72);
exact2 = (-5/e)+2;
exact3 = 1/2*log(33/47);
exact4 = (-(pi^2*sqrt(2))/32)+((pi*sqrt(2))/(4))+sqrt(2)-2;
exact5 = (3*e^((3*pi)/4)+2)/(13);
exact6 = log(12/25);
exact7 = (sqrt(33)/2)-sqrt(5);
exact8 = (2+pi)/8;

% Vector de valores exactos
exactValues = [exact1, exact2, exact3, exact4, exact5, exact6, exact7, exact8];

% Arreglos para funciones y límites
funcs    = {f1, f2, f3, f4, f5, f6, f7, f8};
a_limits = [a1, a2, a3, a4, a5, a6, a7, a8];
b_limits = [b1, b2, b3, b4, b5, b6, b7, b8];

% Inicializar arrays para almacenar resultados
results = zeros(4, 8);  % Para n = 2, 3, 4, 5 y 8 integrales
errors  = zeros(4, 8);  % Para errores relativos

% Calcular las integrales utilizando cuadratura gaussiana para n = 2, 3, 4, 5
for idx = 1:8
    for n_idx = 1:4
        n = n_idx + 1; % n = 2, 3, 4, 5
        
        % Usar los puntos de Gauss-Legendre predefinidos para cada n
        switch n
            case 2
                % Puntos y pesos para n=2
                x = [-0.5773502691896257; 0.5773502691896257];
                w = [1.0000000000000000; 1.0000000000000000];
            case 3
                % Puntos y pesos para n=3
                x = [-0.7745966692414834; 0.0000000000000000; 0.7745966692414834];
                w = [0.5555555555555556; 0.8888888888888888; 0.5555555555555556];
            case 4
                % Puntos y pesos para n=4
                x = [-0.8611363115940526; -0.3399810435848563; 0.3399810435848563; 0.8611363115940526];
                w = [0.3478548451374538; 0.6521451548625461; 0.6521451548625461; 0.3478548451374538];
            case 5
                % Puntos y pesos para n=5
                x = [-0.9061798459386640; -0.5384693101056831; 0.0000000000000000; 0.5384693101056831; 0.9061798459386640];
                w = [0.2369268850561891; 0.4786286704993665; 0.5688888888888889; 0.4786286704993665; 0.2369268850561891];
        end
        
        % Transformar nodos del intervalo [-1,1] al intervalo [a,b]
        a             = a_limits(idx);
        b             = b_limits(idx);
        x_transformed = ((b-a)/2)*x + (a+b)/2;
        
        % Evaluar la función en los nodos transformados
        func     = funcs{idx};
        f_values = func(x_transformed);
        
        % Calcular la integral usando la fórmula de cuadratura
        results(n_idx, idx) = ((b-a)/2) * sum(w .* f_values);
        
        % Calcular el error relativo
        errors(n_idx, idx) = abs((results(n_idx, idx) - exactValues(idx)) / exactValues(idx)) * 100;
    end
end

% Mostrar resultados
integrales = {'∫x²ln(x)dx', '∫x²e^(-x)dx', '∫2/(x²-4)dx', '∫x²sin(x)dx', ...
             '∫e^(3x)sin(2x)dx', '∫2x/(x²-4)dx', '∫2x/√(x²-4)dx', '∫cos²(x)dx'};
         
disp('Resultados de Integración con Cuadratura Gaussiana:');
disp('-----------------------------------------------------------------------');
for i = 1:8
    fprintf('Integral %d: %s desde [%.2f, %.2f]\n', i, integrales{i}, a_limits(i), b_limits(i));
    fprintf('  Valor exacto: %.10f\n', exactValues(i));
    for n = 2:5
        fprintf('  n = %d: %.10f (Error relativo: %.8f%%)\n', n, results(n-1, i), errors(n-1, i));
    end
    disp('-----------------------------------------------------------------------');
end

% Plot de convergencia (error vs. n)
figure;
for i = 1:8
    subplot(2, 4, i);
    semilogy(2:5, errors(:, i), 'o-', 'LineWidth', 2);
    title(['Integral ' num2str(i)]);
    xlabel('n (número de puntos)');
    ylabel('Error relativo (%)');
    grid on;
end
sgtitle('Convergencia de Cuadratura Gaussiana');

% Comparar con integral de MATLAB para verificación adicional
fprintf('\nComparación con integral de MATLAB:\n');
fprintf('-----------------------------------------------------------------------\n');
for i = 1:8
    func          = funcs{i};
    matlab_result = integral(func, a_limits(i), b_limits(i));
    matlab_error  = abs((matlab_result - exactValues(i)) / exactValues(i)) * 100;
    fprintf('Integral %d: MATLAB = %.10f (Error: %.8f%%)\n', i, matlab_result, matlab_error);
end
fprintf('-----------------------------------------------------------------------\n');
