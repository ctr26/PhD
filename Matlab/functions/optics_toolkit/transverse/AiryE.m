%---------------------------------------------------------------
% PROGRAM: AiryE
% AUTHOR:  Andri M. Gretarsson
% DATE:    8/7/03
%
%
% SYNTAX: E=AiryE([a,w0,L,lambda <,N>],r);
%              <,...> indicates optional argument
%
% Returns the Field of an Airy disk as a function of radius.  The waist
% of the beam is assumed to be at the aperture.
%
% a      = radius of aperture
% w0     = radius of Gaussian beam at aperture
% L      = propagation distance (axially) from aperture
% lambda = wavelength
% N      = order to which to carry the calculation
%
% Last updated: 8/7/03 by AMG
%
%---------------------------------------------------------------
%% SYNTAX: E=AiryE([a,w0,L,lambda <,N>],r);
%---------------------------------------------------------------

function E=AiryE(params,r)

a=params(1);
w0=params(2);
L=params(3);
lambda=params(4);
if length(params)>=5, Norders=params(5); else Norders=2; end
if Norders<1, Norders=1; end

%N=a^2/L/lambda;
%q0=i*pi*w0.^2/lambda;
%q=q0+L;
%E=q0/q .* exp(-i*pi*N*(r./a).^2) .* ( 1 - exp(-i*pi*N-a^2/w0^2) .* BesselJ(0,2*pi*N*r./a) );

k=2*pi/lambda;
F=(a/w0)^2/pi;
R=sqrt(r.^2+L^2);
eta=pi*F/a^2-i*k/2./R;
gamma=-k.*r./R;


Sum1=0; 
Sum2=0;
for m=0:Norders-1
    Sum1=Sum1+(-gamma/2/a./eta).^m .* BesselJ(m,a.*gamma);
    Sum2=Sum2+(gamma/2/a./eta).^m + Bessel(1-m,a*gamma);
end


A = -i*k*L/2./eta./R.^2 .* exp(-i*k.*R);
B = exp(-gamma.^2/4./eta)  -  exp(-eta*a^2) .* Sum1;
C = gamma/a./eta.*exp(-gamma.^2/4./eta)  -  2*exp(-eta*a^2) .* Sum2;

E= sqrt(2)/pi/w0 * A .* (B + (i*a*r./R.^2).*C);
















