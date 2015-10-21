%----------------------------------------------------------------------------------------------
% PROGRAM: overlap
% AUTHOR:  Andri M. Gretarsson
% DATE:    7/10/04
%
% SYNTAX: coeff=overlap(z1,z2,domain <,metric,accuracy>)
%           <...> indicates optional arguments
%
% Calculates the overlap integral of the two functions specified.
%
% INPUT ARGUMENTS:
% ----------------
% z1        = The values of the first function.  Can be a 1D vector or a 2D matrix
% z2        = The values of the second function. z1 and z2 must be the same size.
% domain    = the domain values at which z1 and z2 are specified.  If z1 and z2 are 1D
%             then domain is a nx2 matrix specifying one x,y pair for each value in z1
%             and z2. If z1 and z2 are 2D then domain is a nxmx2 array where
%             domain(:,:,1) and domain(:,:,2) are the x and y meshes corresponding
%             to the values in z1 and z2. These meshes are often generated using meshgrid.m.
% metric    = value, vector or matrix by which to multiply the elemental line or area dl or dS.
%             For example, in 2D polar coordinates the elemental area is dS=r*dr*dtheta so 
%             metric should be specified as r.
% accuracy  = round results to the nearest increment of accuracy.  For example, if
%             accuracy=0.3, then coeff 1.54 would be rounded to 1.5 while coeff=1.56 would be 
%             rounded to 1.8.
%
% OUTPUT ARGUMENTS:
% -----------------
% coeff     = the numerical result of the overlap integral.
%
% EXAMPLE 1 (cartesian):
%       [x,y]=meshgrid([0:0.01:2*pi],[0:0.01:2*pi]);
%       clear domain; domain(:,:,1)=x; domain(:,:,2)=y;
%       z1=sin(x+y); z2=sin(x+y);
%       coeff=overlap(z1,z2,domain,1,0.0001)       
%       z1=sin(x+y); z2=cos(x+y);
%       coeff=overlap(z1,z2,domain,1,0.0001)
%
% EXAMPLE 2 (polar):
%       [r,theta]=meshgrid([0.01:0.01:1],[0:0.5:360]*pi/180);
%       clear domain; domain(:,:,1)=r; domain(:,:,2)=theta;
%       z1=r;   z2=theta;
%       subplot(1,3,1); [x,y]=pol2cart(theta,r); h=pcolor(x,y,z1); set(h,'EdgeColor','none'); axis square;
%       subplot(1,3,2); [x,y]=pol2cart(theta,r); h=pcolor(x,y,z2); set(h,'EdgeColor','none'); axis square;
%       subplot(1,3,3); [x,y]=pol2cart(theta,r); h=pcolor(x,y,z1.*z2); set(h,'EdgeColor','none'); axis square;
%       coeff=overlap(z1,z2,domain,r,0.0001)  
%
% Last updated: July 18, 2004 by AMG
%----------------------------------------------------------------------------------------------
%% SYNTAX: coeff=overlap(z1,z2,domain <,metric,accuracy>)
%----------------------------------------------------------------------------------------------
function coeff=overlap(z1,z2,domain,varargin)

if nargin>=4;
    metric=varargin{1};
    if size(metric)==size(z1)
        metric=metric(2:end,2:end);
    end
else
    metric=1;
end
if nargin>=5; accuracy=varargin{2}; else accuracy=0; end
if size(z1)~=size(z2), error('z1 and z2 must have same size'); end

if min(size(z1))==1 & min(size(domain))==1              % 1D plot along axis
    dl=metric.*(domain(2:end)-domain(1:end-1));
    coeff=sum(z1(2:end).*z2(2:end).*dl)/2;
end
if min(size(z1))==1 & size(domain,2)==2                 % 1D plot along arbitrary axis
    dl=metric.*sqrt((domain(2:end,1)-domain(1:end-1,1)).^2 + (domain(2:end,2)-domain(1:end-1,2)).^2);
    coeff=sum(z1(2:end).*z2(2:end).*dl)/2;
end
if  min(size(z1))>= 2                                   % 2D plot over xy plane
    coord1=domain(:,:,1); coord2=domain(:,:,2);
    dcoord1=diff(coord1,1,2); dcoord1=dcoord1(2:end,:);
    dcoord2=diff(coord2,1,1); dcoord2=dcoord2(:,2:end);
    dS = metric.*dcoord1.*dcoord2;
    coeff=sum(sum(z1(2:end,2:end).*z2(2:end,2:end).*dS));
end

if accuracy~=0
    coeff=round(coeff/accuracy)*accuracy;
end