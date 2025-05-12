% Define the differential equation
f = @(t, y) -y + t + 1;

% Initial condition
y0 = 1;

% Time interval
t0 = 0;
tf = 5;

% Initial step size
h = 0.1;

% Maximum error tolerance
tol = 1e-4;

% Initialize vectors to store results
t = t0;
y = y0;
h_values = h;

% Euler's method with adaptive step size
while t(end) < tf
    % Perform one step with step size h
    y1_h = y(end) + h * f(t(end), y(end));
    
    % Perform two steps with step size h/2
    h_half = h / 2;
    y1_half = y(end) + h_half * f(t(end), y(end));
    y2_half = y1_half + h_half * f(t(end) + h_half, y1_half);
    
    % Estimate the error
    error = abs(y2_half - y1_h) / 3;
    
    % Check if the error is within the tolerance
    if error < tol
        % Accept the step
        t = [t, t(end) + h];
        y = [y, y2_half];
        
        % Increase the step size for the next step
        h = min(2 * h, 0.1*(tf-t(end)));
        
    else
        % Reduce the step size
        h = h / 2;
    end
    h_values = [h_values, h];
end

% Display the results
disp(['t = ', num2str(t)]);
disp(['y = ', num2str(y)]);

% Plot the solution
plot(t, y);
xlabel('t');
ylabel('y(t)');
title('Solution of dy/dt = -y + t + 1 using Euler s Method');
grid on;