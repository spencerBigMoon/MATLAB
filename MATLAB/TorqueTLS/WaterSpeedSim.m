end_point = 20;

a1 = 20;
a2 = -1.5;
b1 = 10;
b2 = 1;

count = 1
for i = 0:end_point
    for j = 0:end_point
        X(count) = i;
        Y(count) = j;
        Z_flat(count) = a1 * i + a2 * i  ^ 2 + b1 * j + b2 * i * j;
        Z(i + 1,j + 1) = a1 * i + a2 * i  ^ 2 + b1 * j + b2 * i * j;
        count = count + 1;
    end
end

figure(1)
mesh(0:end_point, 0:end_point, Z)

[U, S, V] = svd([X' X' .^ 2 Y' X'.*Y' Z_flat']);

a_tls = -V(1:4, 5) / V(5, 5)

step = .2;
a = 0;
water_speed = 1;
for i = 1:10
    a = a + step .* (a_tls(1) + 2 .* a_tls(2) .* a + b2 *water_speed)
end