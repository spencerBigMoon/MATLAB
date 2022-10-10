data = readtable("Predictor_Data/point5.csv");


speeds = table2array(data(:,"Speed_M_S_"));
durations = table2array(data(:,"SecondsInPeriod"));
plot_length = length(speeds);

[powers, net_power_kw, capped_speed] = calc_new_integral(speeds, durations, plot_length);

total_power = sum(powers) * .001
max_amb_spd_ms = max(capped_speed)
max_amb_spd_knot = max(capped_speed) * 1.94384
max_acc_spd_ms = max_amb_spd_ms * 1.57
max_acc_spd_knot = max_amb_spd_knot * 1.57


figure(2)

plot(1:plot_length,powers(1:plot_length))
ylim([0,80]);
ylabel("KW Hours")
xlabel("Sample #")

