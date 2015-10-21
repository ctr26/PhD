%------------------------------------------------------------------------
% Draws a representation of a lens at the position and angle specified.
%
% SYNTAX: [handle,texthandle,pos,rotpos]
%              =lensplot(d <,z,x,y,theta,lambda,label,labelpos,suppress>);
%
% INPUT ARGUMENTS:
% d         = diameter of the lens. The lens radius of curvature is assumed 
%             to be essentially infinite (1e30).
%             d can also be passed as a 2-element vector d=[diameter,radius],
%             where the first element is the lens diameter and the second
%             is the radius of curvature of the lens surface. 
% z         = Position along beam axis at which to place lens. z is
%             measured relative to the point at which q is specified.
%             Default is 0.
% x,y       = position of the point at which q is specified, default=0,0.
% theta     = rotation of optic axis counterclockwise relative to x-axis,
%             defaul=0
% lambda    = wavelength, default=1064 nm
% label     = string with which to label the lens, default is ''.
% labelpos  = 0 to put label at bottom, 1 to put label at top, default 0
% suppress  = set to 1 to suppress plotting, default 0.
%
% OUTPUT ARGUMENTS:
% handle    = handle of the trace plotted
% texthandle= handle of the text label if supplied (otherwise -1)
% pos       = 2xn matrix. Second row is lens face height, first row is
%             the corresponding position along the optic axis, measured
%             from the point at which q is specified.
% rotpos    = 2xn matrix. x,y coordinates of the lens trace,
%             first row corresponds to x coord's, second row to y coord's.
%
% Last Modified: Dec. 10, 2003 by Andri M. Gretarsson.
%
%-------------------------------------------------------------------------
% SYNTAX: [handle,texthandle,pos,rotpos]
%              =beamplot(d <,z,x,y,theta,lambda,label,labelpos,suppress>);
%-------------------------------------------------------------------------

function [handle,texthandle,pos,rotpos]=beamplot(d,varargin)

if size(d,2)>1, Rlens=d(2); else Rlens=1e30; end
if nargin>=2, z=varargin{1}; else z=0; end
if nargin>=3, x=varargin{2}; else x=0; end
if nargin>=4, y=varargin{3}; else y=0; end
if nargin>=5, theta=varargin{4}*pi/180; else theta=0; end
if nargin>=6, lambda=varargin{5}; else lambda=1064e-9/0.0254; end
if nargin>=7, label=varargin{6}; else label=''; end
if nargin>=8, labelpos=varargin{7}; else labelpos=0; end
if nargin>=9 suppress=varargin{8}; else suppress=0; end

lensheight=d/2;
phimax=asin(lensheight/Rlens);
phi=[-phimax:phimax/100:phimax];
xrightside=Rlens*(cos(phimax)-cos(phi));
yrightside=Rlens*sin(phi);
xleftside=-Rlens*(cos(phimax)-cos(phi));
yleftside=yrightside;
rightside=[xrightside;yrightside];
leftside=[xleftside;yleftside];

rotmat=[[cos(theta), -sin(theta)];[sin(theta), cos(theta)]];
rotrightside=rotmat*rightside;
rotrightside(1,:)=rotrightside(1,:)+x;
rotrightside(2,:)=rotrightside(2,:)+y;
rotleftside=rotmat*leftside;
rotleftside(1,:)=rotleftside(1,:)+x;
rotleftside(2,:)=rotleftside(2,:)+y;

switch labelpos
case 2,
    augmentedlabel=['  ',label];;
    xtextpos=max(rotrightside(1,:));
    ytextpos=( min(rotrightside(2,:)) + max(rotrightside(2,:)) )/2;
case 0,
    augmentedlabel=strvcat(' ',label);
    xtextpos=max(rotrightside(1,:));
    ytextpos=min(rotrightside(2,:));
case 1,
    augmentedlabel=strvcat(label,' ');
    xtextpos=max(rotrightside(1,:));
    ytextpos=max(rotrightside(2,:));
end

if suppress~=1
    handle=plot(rotrightside(1,:),rotrightside(2,:),'k-',rotleftside(1,:),rotleftside(2,:),'k-');
    if ~isempty(label)
        texthandle=text(xtextpos,ytextpos,augmentedlabel);
    else
        texthandle=-1;
    end
end