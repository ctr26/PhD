%---------------------------------------------------------------
% Given the q-factor and wavelength of a beam, this function
% returns the position and size of the waist assuming free space 
% propagation. 
%
% SYNTAX: [L <,w0>]=L_(q <,lambda>);   
%            <...> indicates optional arguments
%
% q      = q-factor of the beam at the position where R and w are to
%          be found. q can be a vector
% lambda = wavelength. Can be a vector or scalar.
%
% If both q and lambda are vectors, they must be the same size.
%
%---------------------------------------------------------------
% SYNTAX: [L <,w0>]=L_(q <,lambda>);
%---------------------------------------------------------------

function [L,w0]=L_(q,varargin); 

if nargin>=2, lambda=varargin{1}; else lambda=1064e-9/0.0254; end

w0=sqrt(imag(q).*lambda/pi);
L=-real(q).*ones(size(w0));