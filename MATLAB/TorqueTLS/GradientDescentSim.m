% Create a neighborhood of sample data for function
clear all;
a1 = 50;
a2 = -3;


neighborhood = [2:.05:16]';
number_measurements = length(neighborhood);

x = neighborhood;

y_tilde = randn(number_measurements,1);
Y = a1 .* x + a2 .* x .^ 2 + y_tilde;

x = neighborhood + randn(number_measurements,1);
X = [x, x .^ 2];

[U, S, V] = svd([X Y])

a_tls = -V(1:2, 3) / V(3, 3)

figure(1)
plot(X(:,1), Y, '.')
hold on
plot(neighborhood, a_tls(1).*(neighborhood) + a_tls(2) .* (neighborhood) .^ 2)
hold off

step = .2;
a = 0;
for i = 1:10
    a = a + step .* (a1 + 2 .* a2 .* a)
end




