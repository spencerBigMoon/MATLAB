function [X, Y] = get_TorqueAndPowerMeasurement(torque,start, stop, a1, a2, fig_num)

    t = [start:0.1:stop]';
    number_of_measurements = length(t);
    x = torque .* ones(number_of_measurements,1);
    x_tilde = 2 .* randn(number_of_measurements,1);
    
    paddle_harmonic = 1 .* (16 - x) ./ 10 .* sin(1 ./ 2 .* x .^ 2 .* t);
    
    x_total = x + paddle_harmonic;

    y_tilde = 2 .* randn(number_of_measurements,1);
    Y = a1 .* x_total + a2 .* x_total .^ 2 + y_tilde;

    x_total = x + x_tilde + paddle_harmonic;
    X = [x_total, x_total .^ 2];

    figure(fig_num)
    plot(t, x_total)
end