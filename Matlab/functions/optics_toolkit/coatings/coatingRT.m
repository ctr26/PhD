% Coating reflectivity and transmittivity.
%--------------------------------------------------------------------------
% Returns the reflectivity (fractional reflected power) and transmittivity
% (fractional transmitted power) of a periodic, multilayer dielectric
% coating as a function of the coating parameters and input beam properties
% (incident wavelength, polarization, angle of incidence, etc.)
%
% To use coatingRT.m, the function multidiel.m by Orfanidis must be in your 
% matlab path. The function multidiel.m is available on the mathworks website
% in the package ewa.zip from Orfanidis:
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4456
%
% AUTHOR: Andri M. Gretarsson, 6/2007. 
% LAST UPDATED: 6/2007 by AMG
% NOTE: This documentation is still incomplete.  Apologies.
%
% SYNTAX: [R,T,anginc] = coatingRT(nH,nL,N,la,la0,pol,...
%             <nreflecs,Lfront,nb,anginc,LH,LL>)
%
% INPUT VARIABLES
% ---------------
% nH        = index of refraction of the high-index coating layers (e.g. Ta2O5)
% nL        = index of refraction of the high-index coating layers (e.g. SiO2)
% N         = number of coating layers
% la        = incident wavelength ("lambda") in nm. This is the wavelength of the
%             light that is actually hitting the coating.  Note: Units are
%             nanometers.
% la0       = center wavelength ("lambda-zero") in nm.  This is the wavelength of
%             light in terms of which the layer thicknesses are specified. For
%             a high-reflective coating with quarter-wave layers, the center
%             wavelength is also the wavelength of maximum reflectivity. (Hence
%             the term "center wavelength.") Note: Units are nanometers.
% pol       = polarization of the incident light, should be 'te' for
%             s-polarization or 'tm' for p-polarization. ('te' stands for
%             "transverse-electric." In other words, the electric field is
%             transverse to the plane of incidence.)
% nreflecs  = This should usually be 0.  Setting this to a higher number
%             causes the function to add in that number of _secondary_
%             reflections from the back surface of the sample (assumed to be
%             uncoated).
% Lprotect  = Thickness (in terms of la0) of any protective coating layer laid down
%             on top of the coating.  Usually, the topmost periodic layer
%             is a low index layer (usually SiO2).  However, the topmost layer is 
%             laid down as a 1/2 wavelength thick layer rather than a 1/4 
%             wavelength layer like the others (for an HR coating). 
%             This is accounted for in this code by setting Lprotect to 1/4,
%             and nprotect=nL.  In other words the 1/2 wavelength topmost 
%             layer is constructed as two 1/4 wavelength layers (the periodic
%             layer and the protective layer) each with the same index of 
%             refraction. And these are indeed the default values for Lprotect
%             and nprotect.  Default: Lprotect=1/4.
% nprotect  = Index of refraction of any additional coating layer laid down
%             to protect the periodic coating.  Default: nprotect=nL.
% nb        = Index of refraction of the substrate.  Default: nb=1.46 (silica).
% anginc    = 1xN vector of incidence angles in radians. Default is 500
%             evenly spaced angles between zero and pi/2.
% LH        = Thickness in terms of la0 of the high index layers if not 1/4.
%             Default: LH=1/4.
% LL        = Thickness in terms of la0 of the low index layers if not 1/4.
%             Default:  LL=1/4.

% OUTPUT VARIABLES
% ----------------
% R, T      = Reflectivity and Transmissivity (fractional reflected or 
%             transmitted _power_).  R and T are vectors of size(anginc).
% anginc    = Same as the vector anginc. (Returned for the use of users
%             taking advantage of the default value of anginc.)
%
%--------------------------------------------------------------------------
% SYNTAX: [R,T,anginc] = coatingRT(nH,nL,N,la,la0,pol,...
%             <nreflecs,Lfront,nb,anginc,LH,LL>)
%--------------------------------------------------------------------------


function [R,T,anginc] = coatingRT(nH,nL,N,la,la0,pol,varargin)

m=6; n=1;
if nargin>=m+n, nreflecs=varargin{n}; else nreflecs=0; end; n=n+1;
if nargin>=m+n, Lprotect=varargin{n}; else Lprotect=1/4; end; n=n+1;
if nargin>=m+n, nprotect=varargin{n}; else nprotect=nL; end; n=n+1;
if nargin>=m+n, nb=varargin{n}; else nb=1.46; end; n=n+1;
if nargin>=m+n, anginc=varargin{n}; else anginc=linspace(0,90,500)*pi/180; end; n=n+1;
if nargin>=m+n, LH=varargin{n}; else LH=1/4; end; n=n+1;    % optical thicknesses in units of la0,
if nargin>=m+n, LL=varargin{n}; else LL=1/4; end; n=n+1;    % where la0 is the design wavelength in units of nm

na = 1;         % refractive index of medium outside the sample (usually air or vacuum);

coating=repmat([nL,nH], 1, N);
L_in = (coating==nL)*LL + (coating==nH)*LH; % lengths of the layers in order as seen entering sample
if Lprotect~=0;
    L_in=[Lprotect,L_in];
    coating=[nprotect,coating];
end
L_out= reverse(L_in); % lengths of the layers in order as seen exiting sample
n_in = [na,coating,nb]; % indices for the layers in order as seen entering sample
n_out = reverse(n_in); % indices for the layers in order as seen exiting sample

angincg=asin(na*sin(anginc)/nb);    %Snell's law
r_in=zeros(size(anginc));
r_out=zeros(size(anginc));
R_in=zeros(size(anginc));
R_out=zeros(size(anginc));
R_g=zeros(size(anginc));
R=zeros(size(anginc));
[tempo1 tempo2]=fresnel(nb,na,angincg*180/pi);
temp1=tempo1.*conj(tempo1);
temp2=tempo2.*conj(tempo2);

r_in=multidiel(n_in,L_in,la/la0,anginc*180/pi,pol);
r_out=multidiel(n_out,L_out,la/la0,angincg*180/pi,pol);    
R_in=(r_in.*conj(r_in));
R_out=(r_out.*conj(r_out));
if strcmp(pol,'te'), R_g=temp1; else R_g=temp2; end
k=R_out*R_g;
% next line is sum from 0 to nreflecs internally reflecting light beams
% NOTE: nreflecs = 2 is equivalent the having 3 beams in total reflected
% from the sample (primary reflection + 2 secondary reflections).
R=R_in + ( 1-R_out )*( 1-R_in ) * R_g * (1-k^nreflecs)/( 1-k );

T=1-R;

if nargout==0
    plot(anginc,R);
    xlabel('Angle (degrees)');
    ylabel('Reflectance');
end