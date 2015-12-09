%---------------------------------------------------------------
% Field of the TEMnm Gaussian mode as a function of radial
% distance from beam axis.
%
% SYNTAX: E=SimpleGaussian_rdep([w0,z,lambda,n,m],r);
%
% INPUT ARGUMENTS:
% w0     = Gaussian field radius at waist
% z      = distance from beam axis
% lambda = wavelength
%
% r      = distance from beam axis (Nx1 vector)
% n      = horizontal mode number
% m      = vertical mode number
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
% SYNTAX: E=SimpleGaussian_rdep([w0,z,lambda,twoD,n,m],x,y);
%---------------------------------------------------------------

function [E,w,R,phi,zR]=SimpleGaussian_rdep(params,x,varargin);

if abs(params(2))<=1e-99, params(2)=1e-99; end
                            %Prevents divide by zero error at waist
                            
if nargin>=3
    y=varargin{1};
else
    y=zeros(size(x));
end
higherorder=0;

w0=params(1);               %Beam field width at waist
z=params(2);                %Distance from beam axis
if length(params)>=4
    twoD=params(4);
else
    twoD=0;
end
if length(params)>=5        %Will be calculating higher order mode
    l=params(5);
    m=params(6);
    higherorder=1;
end

    
lambda=params(3);           %Wavelength
k=2*pi/lambda;              %Wavenumber
zR=pi*w0^2/lambda;          %Raleigh range

w=w0*sqrt(1+(z/zR)^2);      %Beam (field) width
R=z*(1+(zR/z)^2);           %Radius of curvature
phi=atan(z/zR);             %Guoy phase

if twoD~=1
    if higherorder~=1
        E = (w0/w) * exp(-(x.^2+y.^2)/w^2) .* exp(-i*k*(x.^2+y.^2)/2/R) * exp( i*phi);
    else
        E = (w0/w) * hermitepoly(l,sqrt(2)*x/w) .* hermitepoly(m,sqrt(2)*y/w)...
           .*exp(-(x.^2+y.^2)/w^2) .* exp(-i*k*(x.^2+y.^2)/2/R) * exp(i*(1+l+m)*phi);
    end
else
    E=zeros(length(y),length(x));
    if higherorder~=1
        for s=1:length(y)
            E(s,:) = (w0/w) * exp(-(x.^2+y(s).^2)/w^2) .* exp(-i*k*(x.^2+y(s).^2)/2/R) * exp( i*phi);
        end
    else
        for s=1:length(y)
            E(s,:) = (w0/w) * hermitepoly(l,sqrt(2)*x/w) .* hermitepoly(m,sqrt(2)*y(s)/w)...
                .*exp(-(x.^2+y(s).^2)/w^2) .* exp(-i*k*(x.^2+y(s).^2)/2/R) * exp(i*(1+l+m)*phi);
        end
    end
end
