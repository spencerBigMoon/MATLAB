r = 5 * .3048;
p = 7 * .3048;
m = 13 * .3048;
R = r + p + m;
width = 18 * .3048;

theta = [-pi/2:0.01:pi/2];

plate_num = 8;

for i = 1:plate_num
    theta_hat = acos((r+p) / (r+p+m));
    mask = (theta > - theta_hat) & (theta < theta_hat);
    d(i).depth = (R*cos(theta + pi/4 * (i - 2)) - r - p);
    d(i).depth(d(i).depth < 0) = 0;
    
end

figure(1)
for i = 1:plate_num
    plot(theta, d(i).depth)
    drawnow;
    hold on
end

hold off
ylabel("Depth of Plate")
xlabel("Angle of Wheel")
legend(["1","2","3","4","5","6","7","8"])

totals = d(1).depth;
for i = 2:plate_num
    totals = totals + d(i).depth;
end

figure(2)
plot(theta, totals * width)
ylabel("Total Area of Plate in the water")
xlabel("Angle of Wheel")

