% Fit y = 4x - 7x^2
length = 100;
a1 = 10;
a2 = -1.5;
x_scale = 10;


x = x_scale * rand(length,1);
x_tilde = randn(length,1);
y = a1 .* (x + x_tilde) + a2 .* (x + x_tilde) .^ 2;
y_tilde = randn(length,1);

X = [x + x_tilde, (x + x_tilde) .^ 2];
Y = y + y_tilde;

[U, S, V] = svd([X Y])

a_tls = -V(1:2, 3) / V(3, 3)

figure(1)
plot(X(:,1), Y, '.')
hold on
plot(1:.2:x_scale, a1.*(1:.2:x_scale) + a2 .* (1:.2:x_scale) .^ 2)
hold off