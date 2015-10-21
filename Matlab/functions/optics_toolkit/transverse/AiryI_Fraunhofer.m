%---------------------------------------------------------------
% PROGRAM: AiryI_Fraunhofer
% AUTHOR:  Andri M. Gretarsson
% DATE:    1/30/06
%
%
% SYNTAX: I=AiryI([a,L,lambda],r);
%               <,...> indicates optional argument
%
% Returns the intensity of an Airy disk as a function of radius
% in the Fraunhofer (small aperture) and paraxial (small angle)
% limits.
%
% a      = radius of aperture
% L      = propagation distance (axially) from aperture
% lambda = wavelength
%
% Last updated: 1/30/06 by AMG
%---------------------------------------------------------------
%% SYNTAX: I=AiryI_Fraunhofer([a,L,lambda],r);
%---------------------------------------------------------------

function I=AiryI(params,r);

a=params(1);
L=params(2);
lambda=params(3);
k=2*pi/lambda;

r=(r==0)*lambda/1000+r;  %Gives the limit of Bessel(1,r)/r as r->0  (can't evaluate BesselJ(1,0)/0).
I=(2*BesselJ(1,k*a*r/L)./(k*a*r./L)).^2;

%I is normalized to the intensity in the center.