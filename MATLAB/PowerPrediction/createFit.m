function [fitresult, gof] = createFit(Accelerated_Speed_knots, Net_Power_KW)
%CREATEFIT(ACCELERATED_SPEED_KNOTS,NET_POWER_KW)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input: Accelerated_Speed_knots
%      Y Output: Net_Power_KW
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-Oct-2022 09:40:56


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( Accelerated_Speed_knots, Net_Power_KW );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' )

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'Net_Power_KW vs. Accelerated_Speed_knots', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'Accelerated_Speed_knots', 'Interpreter', 'none' );
ylabel( 'Net_Power_KW', 'Interpreter', 'none' );
grid on


