% Propagates the q-factor of a Gaussian beam through a cavity. 
% The function returns the q-factors of the reflected beam, the transmitted 
% beam and the cavity beam at the first mirror. Also returns the reflected, 
% transmitted and intracavity field amplitudes.
%
% AUTHOR: Andri M. Gretarsson, 2003.
% LAST MODIFIED: 2007 by AMG.
%
% SYNTAX: [qrefl,qtrans,qcav,prefl,ptrans,pcav]=...
%         cav(qin,l,m,lambda,L,R1,R2,r1,r2,l1,l2,n_iter <,n>);
%
% INPUT VARIABLES
% ---------------
% R1,R2     = Radii of curvature of the end mirrors.  Positive if mirror is 
%             concave as seen from inside the cavity, negative otherwise. 
%             (Sides facing outwards are assumed to be flat.) R1 corresponds
%             to the input mirror and R2 to the end mirror.
%
%           FIGURE:
%           
%           Input beam   Input mirror     End Mirror    Transmitted beam
%           -----------------|(==============)|- - - - - - - - - - - 
%                                Cavity beam
%
%           Note: Reflected beam is in same location as the Input beam but 
%           travels in the opposite direction (away from the cavity).
%     
% L         = Cavity length
% l,m       = TEM_lm Gaussian mode incidnet on the cavity.
% lambda    = wavelength
% qin       = q of the incoming beam immediately before the input optic 
%             outward facing side (assumed flat).
% r1        = Reflectoin coefficient (fraction of field _amplitude_ reflected) of input mirror.
% r2        = Reflection coefficient of end mirror.
% l1        = Loss coefficient for a single pass through the input mirror.
%             (Fraction of field _amplitude_ lost.)
% l2        = Loss coefficient for a single pass through the end mirror.
%             (Fraction of field _amplitude_ lost.)
% n_iter    = Number of iterations (cavity traversals) to calculate.
% n         = Optional: 1x3 vector of cavity medium index of refraction
%             and mirror substrate indices of refraction. 
%             Default is n=[1.46,1,1].
% Lmirr     = Optional: 1x2 vector of mirror thicknesses (on the optic
%             axis). First value corresponds to the input mirror, second to
%             the end mirror. Default: Lmirr=[0,0].
%
% NOTES:  In the current version, antireflective coatings on the outside
% faces (flat faces) of the mirrors are assumed to be perfect.  This could
% be improved in future versions.  In the current version, this can be
% partially accounted for by assigning appropriate values for l1 and l2
% that take this into account.  Also, the reflectivity and transmissivity
% of the coatings are assumed to be the same for light incident from
% either the substrate side or cavity side of the coating.  Clearly, this
% could be improved also.
%
%--------------------------------------------------------------------------
% SYNTAX: [qrefl,qtrans,qcav,prefl,ptrans,pcav]=...
%         cav(qin,l,m,lambda,L,R1,R2,r1,r2,l1,l2,n_iter <,n>);
%--------------------------------------------------------------------------


function [qrefl,qtrans,qcav,prefl,ptrans,pcav]=cav(qin,l,m,lambda,L,R1,R2,r1,r2,l1,l2,n_iter,varargin);

if nargin>=13, n=varargin{1}; else n=[1.46,1,1]; end
if nargin>=14, Lmirr=varargin{2}; else Lmirr=[0,0]; end
nsubs=n(1);
ncav=n(2);
noutside=n(3);
L1=Lmirr(1);
L2=Lmirr(2);

% Variable initialization
t1 = sqrt(1-r1^2-l1^2);
t2 = sqrt(1-r2^2-l2^2);
qrefl = zeros(n_iter,1); qcav = zeros(n_iter,1); qtrans = zeros(n_iter,1);
prefl = zeros(n_iter,1); pcav = zeros(n_iter,1); ptrans = zeros(n_iter,1);

% Note the poor notation for field amplitudes throughout:  prefl, pcav,
% etc.  The letter p does NOT mean power in this case!

% Commonly used quantitites
freeL  = free(L,ncav);
freeL1 = free(L1,nsubs);
freeL2 = free(L2,nsubs);
mirrR1 = mirr(R1);
mirrR2 = mirr(R2);
tripphase=exp(i*2*pi*(ncav*L/lambda-floor(ncav*L/lambda)));

% Prompt reflection
qrefl(1) = prop(qin,fdie(nsubs,noutside)*freeL1*mirr(-R1)*freeL1*fdie(noutside,nsubs),[l,m]);
prefl(1) = -r1;

% First trip transmission through end mirror
qinside = prop(qin,sdie(-R1,nsubs,ncav)*freeL1*fdie(noutside,nsubs));
[qtrans(1),ptrans(1)] = prop(qinside,fdie(nsubs,noutside)*freeL2*sdie(R1,ncav,nsubs)*freeL,[l,m]);
ptrans(1) = t1*t2*ptrans(1)*tripphase;

% Cavity field as it approaches input mirror after first round trip.
[qcav(1),pcav(1)] = prop(qinside,freeL*mirrR2*freeL,[l,m]);
pcav(1) = t1*r2*pcav(1)*tripphase^2;

for s = 2:n_iter
    
    qrefl(s) = prop(qcav(s-1),fdie(nsubs,noutside)*freeL1*sdie(R1,ncav,nsubs));
    prefl(s) = pcav(s-1)*t1;
    
    [qtrans(s),pout] = prop(qcav(s-1),...
        fdie(nsubs,noutside)*freeL2*sdie(R1,ncav,nsubs)*freeL*mirrR1,[l,m]);
    ptrans(s) = pcav(s-1)*pout*r1*t2.*tripphase;
    
    [qcav(s),pback] = prop(qcav(s-1),freeL*mirrR2*freeL*mirrR1,[l,m]);
    pcav(s) = pcav(s-1)*pout*pback*r1*r2.*tripphase^2; 
end

