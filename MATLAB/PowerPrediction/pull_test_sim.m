close all;
speeds = [0:0.25:5.5]; % in knots
speeds_ms = speeds * 0.514;
durations = ones(1,length(speeds_ms)) * 600;
plot_length = length(speeds);

[powers, net_power_kw, capped_speed, accel_speed] = calc_new_integral(speeds_ms, durations, plot_length);

total_power = sum(powers,'omitnan') .* .001
max_amb_spd_ms = max(capped_speed)
max_amb_spd_knot = max(capped_speed) * 1.94384
max_acc_spd_ms = max_amb_spd_ms * 1.57
max_acc_spd_knot = max_amb_spd_knot * 1.57


figure(2)

plot(1:plot_length,powers(1:plot_length))
ylim([0,80]);
ylabel("KW Hours")
xlabel("Sample #")

Ambient_Speed_knots = speeds';
Accelerated_Speed_knots = accel_speed' / 0.514;
Net_Power_KWH = powers';
Net_Power_KW = net_power_kw';
Actual_Power_KW = ones(1,length(speeds))' * -1;

output = table(Ambient_Speed_knots,Accelerated_Speed_knots,Net_Power_KWH,Net_Power_KW,Actual_Power_KW);

writetable(output, 'Pull_Testing_Sim.xlsx')

createFit(Accelerated_Speed_knots,Net_Power_KW)
