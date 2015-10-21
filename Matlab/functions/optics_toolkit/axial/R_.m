%---------------------------------------------------------------
% Returns the phasefront radius of curvature and the beam width
% given the q factor of a Gaussian beam and the wavelength.
%
% SYNTAX: [R <,w>]=R_(q <,lambda>);   
%            <...> indicates optional arguments
%
% q      = q-factor of the beam at the position where R and w are to
%          be found. q can be a vector
% lambda = wavelength. Can be a vector or scalar.
%
% If both q and lambda are vectors, they must be the same size.
% If w is requested as an output, lambda must be supplied.
%
%---------------------------------------------------------------
% SYNTAX: [R <,w>]=R_(q,<,lambda>);
%---------------------------------------------------------------

function [Rout,wout]=R_(q,varargin)

if nargin>=2, lambda=varargin{1}; else lambda=1064e-9/0.0254; end

wout=sqrt(lambda/pi .* imag(q).*(1+real(q).^2./imag(q).^2));
Rout=real(q).*(1+imag(q).^2./real(q).^2).*ones(size(wout));