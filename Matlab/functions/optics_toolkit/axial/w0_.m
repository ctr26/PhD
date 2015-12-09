%---------------------------------------------------------------
% Given the q-factor and wavelength of a beam, this function
% returns the size of the waist assuming free space 
% propagation. 
%
% SYNTAX: w0=L0_(q <,lambda>);   
%
% q      = q-factor of the beam at the position where R and w are to
%          be found. q can be a vector
% lambda = wavelength. Can be a vector or scalar.
%
% If both q and lambda are vectors, they must be the same size.
%
%---------------------------------------------------------------
% SYNTAX: w0=L0_(q <,lambda>); 
%---------------------------------------------------------------

function w0=L0_(q ,varargin); 

if nargin>=2, lambda=varargin{1}; else lambda=1064e-9; end

w0=sqrt(imag(q).*lambda/pi);
