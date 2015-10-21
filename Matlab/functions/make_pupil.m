function [p, x, rsq] = make_pupil(N,d)
%
% MAKE_PUPIL [p, x, rsq] = make_pupil(N,d)
%
%	r is the FFT cell size (in normalized pupil coordinates)
%  N is the number of points in the cell (should be power of 2)

r = d/2;
x = linspace(-r,r,N+1);
x = ones(N,1)*x(1:N);
xsq = x.*x;
rsq = xsq+xsq';
p = rsq<=1.0;
