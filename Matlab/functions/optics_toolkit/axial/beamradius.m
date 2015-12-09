% Returns the field radius of the beam at any point z along a Gaussian beam
%
% SYNTAX: [w,R,zR]=beamradius([w0,z0,lambda],z);
% 
% w0 = waist size
% z0 = position of waist
% lambda = wavelength
%
% w  = spot size (field radius) at z
% R  = curvature of phasefront at z
% zR = Raleigh length.
%
%-------------------------------------------------------------------
% SYNTAX: [w,R,zR]=beamradius([w0,z0,lambda],z);
%-------------------------------------------------------------------


function [w,R,zR]=beamradius(params,z);

w0=params(1);                           % beam (field) width at waist [meters]
z0=params(2);                           % waist position [meters]
lambda=params(3);
zR=pi*w0^2/lambda;                      % Raleigh length

w=w0.*sqrt(1+((z-z0)/zR).^2);           % beam width at z

if nargout>=2
    R=z.*(1+(zR./z).^2);                % beam phasefront curvature at z
end