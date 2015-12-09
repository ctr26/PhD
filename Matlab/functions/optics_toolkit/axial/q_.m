%---------------------------------------------------------------
% Returns the q-factor of a Gaussian beam given the spot size,
% phasefront radius of curvature and wavelength.
%
% SYNTAX: qfactor=q_(w,R <,lambda>);
%
% w      = 1/e Field radius 
% R      = Radius of curvature of phasefront
% lambda = wavelength
%
% Any one of w, R and lambda may be a vectors or scalars.
% If more than one of w, R and lambda is a vector, all 
% vectors supplied must be the same size.
%
%---------------------------------------------------------------
% SYNTAX: qfactor=q_(w,R <,lambda>);
%---------------------------------------------------------------

function qfactor=q_(w,R,varargin)

if nargin>=3, lambda=varargin{1}; else lambda=1064e-9/0.0254; end

qfactor=pi*w.^2.*R./(pi*w.^2-i.*R.*lambda);