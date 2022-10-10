function [net_power_kw_h, net_power_kw, capped_speed, accel_speed] = calc_new_integral(spd, times, plot_length)
    NUM_PLATES = 1; % PREV 2
    % PRE_WET_WHEEL_DEPTH = 7.75
    PRE_WET_WHEEL_DEPTH = 2.3622; % METERS I THINK This needs to be updated to 60% I think
    PLATE_DEPTH = 13 * .3048;
    PLATE_WIDTH = 18 * .3048;
    % PLATE_DEPTH = 13
    WET_AREA = NUM_PLATES * PLATE_DEPTH * PLATE_WIDTH;
    CENTER_OF_WET_PLT = PRE_WET_WHEEL_DEPTH + (.5 * PLATE_DEPTH); % Radius to center
    NUM_GENERATOR = 1;
    
    DRAG_COEF = 1.35;
    % WATER_DENSITY = 1.99658928
    WATER_DENSITY = 1029;
    % LTS_GEAR_RATIO = 44.7594752137763 # LARGE TO SMALL
    LTS_GEAR_RATIO = 51.48;
    ASSUM_MID_WET_PLT_SPD = 1./3;
    WATER_ACC_FACTOR = 1.57;
    ELECTRIC_EFFICIENCY = .80;
    FTLB_TO_NT_METERS = .73756;
    
    KNOTS_TO_FTSC = 1.68781;
    FTLB_SC_TO_KW = .00135581795;
    MIN_KW = 0;
    GENERATOR_OVERDRIVE_FACTOR = 3.36;
    GENERATOR_KW = 125;
    PER_GENERATOR_OVERDRIVE = 420;
    TOTAL_OVERDRIVE_KW = NUM_GENERATOR .* PER_GENERATOR_OVERDRIVE; % WHY
    MAX_NET_KW = 400;
    GENERATOR_MAX_TORQUE = 14381;
    GEN_NO_OD_MAX_KW = GENERATOR_KW .* NUM_GENERATOR;
    RATED_RPM = 268;
    FRICTION_LOSS = 7.521676199;
    RATED_TORQUE = 14949;
    RATED_VOLTS = 572;
    AMPS_LOSS = 8.000064987;
    
    accel_speed = spd .* WATER_ACC_FACTOR;
    d = 1.9;
    W = 18 * .3048;
    rho = 1029;
    R = 13 * .3048;
    
    % mid
    mid_wet_plt_spd_ms = accel_speed .* ASSUM_MID_WET_PLT_SPD;
    adj_plt_spd = mid_wet_plt_spd_ms;
%     wtr_vel_at_mid_ms = accel_spd - adj_plt_spd; % = 2/3 * accel_spd %%%%%%%%%% CONCERN
%     mid_plt_force_n = .5 .* DRAG_COEF .* WATER_DENSITY .* WET_AREA .* (wtr_vel_at_mid_ms .^ 2); % CONCERN
%     mid_plt_press_nsqm = mid_plt_force_n ./ WET_AREA;
%     mid_plt_pwr_kw = mid_plt_force_n .* adj_plt_spd ./ 1000;
%     
%     % TIP
%     tip_spd_ms = (PRE_WET_WHEEL_DEPTH + PLATE_DEPTH) ./ CENTER_OF_WET_PLT .* adj_plt_spd;
%     tip_wat_vel_ms = accel_spd - tip_spd_ms;
%     tip_force_n = .5 .* DRAG_COEF .* WATER_DENSITY .* WET_AREA .* (tip_wat_vel_ms .^ 2);
%     tip_press_nsqm = tip_force_n ./ WET_AREA;
%     tip_pwr_kw = tip_force_n .* tip_spd_ms ./ 1000;
%     
%     % TOP
%     top_spd_ms = (PRE_WET_WHEEL_DEPTH ./ CENTER_OF_WET_PLT) .* adj_plt_spd;
%     top_wtr_vel_ms = accel_spd - top_spd_ms;
%     top_force_n = .5 .* DRAG_COEF .* WATER_DENSITY .* WET_AREA .* (top_wtr_vel_ms .^ 2);
%     top_press_nsqm = top_force_n ./ WET_AREA;
%     top_power_kw = top_force_n .* top_spd_ms ./ 1000;
    
    % RPMs
    wheel_rpm = (adj_plt_spd ./ ((PRE_WET_WHEEL_DEPTH + (.5 .* PLATE_DEPTH)) .* 2 .* pi)) .* 60;
    generator_shaft_rpm = wheel_rpm .* LTS_GEAR_RATIO;
    
    % FORCE
%     tip_center_avg_force_n = (tip_force_n + mid_plt_force_n) ./ 2;
%     top_center_avg_force_n = (top_force_n + mid_plt_force_n) ./ 2;
%     new_force_n = (tip_force_n + top_force_n + mid_plt_force_n) ./ 3;
%     
    % Pressure
%     tip_center_avg_press = (tip_press_nsqm + mid_plt_press_nsqm) ./ 2;
%     top_center_avg_press = (top_press_nsqm + mid_plt_press_nsqm) ./ 2;
%     new_pressure = (tip_press_nsqm + top_press_nsqm + mid_plt_press_nsqm) ./ 3;
    
    % Power
%     tip_center_avg_power = (tip_pwr_kw + mid_plt_pwr_kw) ./ 2;
%     top_center_avg_power = (top_power_kw + mid_plt_pwr_kw) ./ 2;
%     new_power = (tip_center_avg_power + top_center_avg_power) ./ 2;

    wheel_rpm = (1./3.*accel_speed ./ ((PRE_WET_WHEEL_DEPTH + (.5 .* PLATE_DEPTH)) .* 2 .* pi)) .* 60;
    
    
    omega_d = wheel_rpm * 6; % Degrees per second
    omega_r = omega_d * pi / 180; % Radians per second
    
    R = PLATE_DEPTH + PRE_WET_WHEEL_DEPTH;
    my_power1 = 1 ./ 2000 .* d .* rho .* W .* omega_r .* ((accel_speed .^ 2) ./ 2 .* (R .^ 2) - 2 ./ 3 .* omega_r .* accel_speed .* (R .^ 3) + omega_r .^ 2 ./ 4 .* (R .^ 4))
    R = PRE_WET_WHEEL_DEPTH
    my_power2 = 1 ./ 2000 .* d .* rho .* W .* omega_r .* ((accel_speed .^ 2) ./ 2 .* (R .^ 2) - 2 ./ 3 .* omega_r .* accel_speed .* (R .^ 3) + omega_r .^ 2 ./ 4 .* (R .^ 4))
    
    new_power = my_power1 - my_power2

%     new_power = (tip_pwr_kw + top_power_kw + mid_plt_pwr_kw) ./ 3;
    new_power_per_generator = new_power ./ NUM_GENERATOR;
    per_generator_torque = new_power_per_generator .* 9538.887 ./ generator_shaft_rpm; % why this number?
    generator_loss = ((generator_shaft_rpm ./ RATED_RPM .* FRICTION_LOSS) + (per_generator_torque ./ RATED_TORQUE .* AMPS_LOSS)) .* NUM_GENERATOR;
    generator_efficiency = (new_power_per_generator - generator_loss) ./ new_power_per_generator; % What portion of power generated is lost
    electrical_power_kw = new_power - generator_loss;
    electrical_power_kw_per_generator = electrical_power_kw ./ NUM_GENERATOR;
    generator_voltage = generator_shaft_rpm ./ RATED_RPM .* RATED_VOLTS;
    
    uncapped_speed_idx = electrical_power_kw < PER_GENERATOR_OVERDRIVE;
    capped_speed = spd(uncapped_speed_idx);

    electrical_power_kw(electrical_power_kw > PER_GENERATOR_OVERDRIVE) = PER_GENERATOR_OVERDRIVE;
    electrical_power_kw(electrical_power_kw < 0) = 0;
    net_power_kw = electrical_power_kw .* ELECTRIC_EFFICIENCY;

    figure(1)
    plot(1:plot_length, net_power_kw(1:plot_length))
    ylim([0,430]);
    ylabel("Net KW")
    xlabel("Sample #")

    net_power_kw_s = net_power_kw .* times;
    net_power_kw_h = net_power_kw_s .* 1 ./ 60 .* 1 ./ 60;

    R = PLATE_DEPTH + PRE_WET_WHEEL_DEPTH;
    my_force1 = 0.5 .* d .* rho .* W .* ((accel_speed .^ 2) .* R - accel_speed .* omega_r .* R .^ 2 + omega_r .^ 2 ./ 3 .* R .^ 3)
    R = PRE_WET_WHEEL_DEPTH
    my_force2 = 0.5 .* d .* rho .* W .* ((accel_speed .^ 2) .* R - accel_speed .* omega_r .* R .^ 2 + omega_r .^ 2 ./ 3 .* R .^ 3)

    new_force = my_force1 - my_force2


end