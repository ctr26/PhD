% Accepts the q factor of a Gaussian beam and plots the 1/e^2 intensity envelope.
% 
% SYNTAX: [handle,xend,yend]=beamplot(q,z,<,x,y,theta,n,lambda,...
%                                         attitudes,plotsuppress>);
%
% INPUT ARGUMENTS:
% q         = Gaussian beam complex radius of curvature "q".
%             If q is a vector, a beam is plotted for each element.
% z         = vector along beam axis over which to plot the envelope
% x,y       = position of the point at which q is specified, default=0,0.
% theta     = rotation of optic axis counterclockwise relative to x-axis,
%             defaul=0
% lambda    = wavelength, default=1064 nm or 4.189e-5 inches
% plotsuppress  = set to 1 to suppress plotting, default 0.
%
% OUTPUT ARGUMENTS:
% handle    = handle of the trace plotted
% xend,yend = position of the end of the optic axis over which the beam
%             was plotted.
%
% Last Modified: June 23, 2004 by Andri M. Gretarsson.
%
%--------------------------------------------------------------------------------
% SYNTAX: [handle,xend,yend]=beamplot(q,z,<,x,y,theta,n,lambda,plotsuppress>);
%--------------------------------------------------------------------------------

function [handle,xend,yend,pos,rotpos]=beamplot(q,z,varargin)

if nargin>=3, x=varargin{1}; else x=0; end
if nargin>=4, y=varargin{2}; else y=0; end
if nargin>=5, theta=varargin{3}*pi/180; else theta=0; end
if nargin>=6, n=varargin{4}; else n=1; end
if nargin>=7, lambda=varargin{5}; else lambda=1064e-9/0.0254; end
if nargin>=9, plotsuppress=varargin{7}; else plotsuppress=0; end

if size(z,1)>size(z,2)
    z=transpose(z);
end
if size(q,1)<size(q,2)
    q=transpose(q);
end
lambda=lambda/n;
[L,w0]=L_(q,lambda);

w_upper=zeros(length(L),length(z)); w_lower=w_upper; xend=zeros(length(L)); yend=xend;
handle=zeros(2,length(L)); plotcolors=colormap;

for s=1:length(L)
    w_upper=w0(s)*sqrt(1+(lambda*(z-L(s))/pi/w0(s)^2).^2);
    w_lower=w_upper;

    upperenv=[z;w_upper];
    lowerenv=[z;-w_lower];
    rotmat=[[cos(theta), -sin(theta)];[sin(theta), cos(theta)]];
    rotupperenv=rotmat*upperenv;
    rotupperenv(1,:)=rotupperenv(1,:)+x;
    rotupperenv(2,:)=rotupperenv(2,:)+y;
    rotlowerenv=rotmat*lowerenv;
    rotlowerenv(1,:)=rotlowerenv(1,:)+x;
    rotlowerenv(2,:)=rotlowerenv(2,:)+y;

    xend=max(z)*cos(theta)+x;
    yend=max(z)*sin(theta)+y;

    if plotsuppress~=1
        if s==1,
            orighold=get(gca,'nextplot');
            handle(:,s)=plot(rotupperenv(1,:),rotupperenv(2,:),'b-',rotlowerenv(1,:),rotlowerenv(2,:),'b-');
            set(handle(:,s),'color',plotcolors(mod(s,end)+1,:));
        else
            set(gca,'nextplot','add');
            handle(:,s)=plot(rotupperenv(1,:),rotupperenv(2,:),'b-',rotlowerenv(1,:),rotlowerenv(2,:),'b-');
            set(handle(:,s),'color',plotcolors(mod(s,end)+1,:));            
        end
        if s==length(L)
            set(gca,'nextplot',orighold);
        end
    end
end