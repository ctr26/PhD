%---------------------------------------------------------------
% PROGRAM: AiryI
% AUTHOR:  Andri M. Gretarsson
% DATE:    8/7/03
%
%
% SYNTAX: I=AiryI([a,w0,L,lambda <,N>],r);
%               <,...> indicates optional argument
%
% Returns the intensity of an Airy disk as a function of radius
%
% a      = radius of aperture
% w0     = radius of Gaussian beam at aperture
% L      = propagation distance (axially) from aperture
% lambda = wavelength
% N      = order to which to carry the calculation
% Last updated: 8/7/03 by AMG
%
%---------------------------------------------------------------
%% SYNTAX: I=AiryI([a,w0,L,lambda <,N>],r);
%---------------------------------------------------------------

function I=AiryI(params,r);

I=AiryE(params,r).*conj(AiryE(params,r));