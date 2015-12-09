%---------------------------------------------------------------
% Returns the beam width given the q factor and wavelength 
% of a Gaussian beam.
%
% SYNTAX: w=w_(q <,lambda>);   
%
% q      = q-factor of the beam at the position where R and w are to
%          be found. q can be a vector
% lambda = wavelength. Can be a vector or scalar.
%
% If both q and lambda are vectors, they must be the same size.
%
%---------------------------------------------------------------
% SYNTAX: w=w_(q <,lambda>);
%---------------------------------------------------------------

function wout=w_(q,varargin)

if nargin>=2, lambda=varargin{1}; else lambda=1064e-9/0.0254; end

wout=sqrt(lambda/pi .* imag(q).*(1+real(q).^2./imag(q).^2));

