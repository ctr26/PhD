
clear all
load PreTube.mat
load PostTube.mat

[xData, yData] = prepareCurveData( AfterTube(:,1),AfterTube(:,2));

% Set up fittype and options.
ft = fittype( 'y0+(p0/2)*erf(sqrt(2)*(x-x0)/w0)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 -Inf 0 -Inf];
opts.StartPoint = [0.8002804688888 10 0.9572 0.0357];

% Fit model to data.
[Afterfitresult, gof] = fit( xData, yData, ft, opts);

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'Y vs. X', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel X
ylabel Y
grid on

%%


[xData, yData] = prepareCurveData( PreTube(:,1),PreTube(:,2));

% Set up fittype and options.
ft = fittype( 'y0+(p0/2)*erf(sqrt(2)*(x-x0)/w0)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 -Inf 0 -Inf];
opts.StartPoint = [0.8002804688888 10 0.9572 0.0357];

% Fit model to data.
[Prefitresult, gof] = fit( xData, yData, ft, opts);

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult, xData, yData );
legend( h, 'Y vs. X', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
xlabel X
ylabel Y
grid on

%%

print x0
Afterfitresult.xo