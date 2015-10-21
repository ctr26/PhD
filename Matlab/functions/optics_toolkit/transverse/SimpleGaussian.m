%---------------------------------------------------------------
% Field of the TEM00 Gaussian mode as a function of distance
% from waist and axial distance.  (See e.g. Orazio Svelto, 
% Principles of Lasers, 4th ed. page 152, Eqn's 4.715a-4.717c)
%
% SYNTAX: [E,w,R,phi,zR]=SimpleGaussian([w0,lambda],z,r);
%
% INPUT ARGUMENTS:
% w0     = Gaussian field radius at waist
% z      = axial distance from waist
% lambda = wavelength
%
% z      = distance from waist (Nx1 vector)
% r      = distance from beam axis (Nx1 vector)
%
% OUTPUT ARGUMENTS:
% E      = complex electric field normalized to the field 
%          amplitude at the center of the waist
% w      = width of the beam (radius at which the field amplitude
%          falls to 1/e of it's value on the beam axis
% R      = Radius of curvature of phasefront
% phi    = Guoy phase
% zR     = Raleigh range
%
%---------------------------------------------------------------
% SYNTAX: [E,w,R,phi,zR]=SimpleGaussian([w0,lambda],z,r);
%---------------------------------------------------------------

function [E,w,R,phi,zR]=SimpleGaussian(params,z,r);

w0=params(1);               %Beam field width at waist
lambda=params(2);           %Wavelength

higherorder=0;
if length(params)>=3,
    l=params(3);
    m=params(4);
    higherorder=1;
end

E=zeros(length(z),length(r));
w=zeros(length(z),1);
R=zeros(length(z),1);
phi=zeros(length(z),1);

if higherorder==0
    for s=1:length(z)
        [E(s,:),w(s),R(s),phi(s),zR]=SimpleGaussian_rdep([w0,z(s),lambda],r);
    end
else
    for s=1:length(z)
        [E(s,:),w(s),R(s),phi(s),zR]=SimpleGaussian_rdep([w0,z(s),lambda,0,l,m],r);
    end
end