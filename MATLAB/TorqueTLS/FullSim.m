% Create a neighborhood of sample data for function
a1 = 50;
a2 = -3;

start_torque = 3;
end_torque = 13;

output_power = zeros(end_torque - start_torque, 1);
input_torque = zeros(end_torque - start_torque, 1);

for i = start_torque:end_torque
    [X, Y] = get_TorqueAndPowerMeasurement(i, 0, 10 , 50, -3, 1);
    
    filtered_Y = lowpass(Y, .08);
    filtered_X = lowpass(X(:,1), .08);
    
    figure(2)
    plot(filtered_Y)
    
    figure(3)
    plot(filtered_X)
    
    
    output_power(i + 1) = median(filtered_Y);
    input_torque(i + 1) = median(filtered_X);
end




X_torque = [input_torque, input_torque .^ 2];

[U, S, V] = svd([X_torque output_power])

a_tls = -V(1:2, 3) / V(3, 3)

figure(4)
plot(input_torque, output_power)
hold on
plot(start_torque:end_torque, a_tls(1) .* (start_torque:end_torque) + a_tls(2) .* (start_torque:end_torque) .^ 2)


step = .2;
a = 0;
for i = 1:10
    a = a + step .* (a1 + 2 .* a2 .* a)
end




