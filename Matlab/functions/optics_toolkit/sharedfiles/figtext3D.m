% A function for writing text to 3D graphs in a simple way.
%--------------------------------------------------------------------------
% PROGRAM: figtext
% DATE: 4/15/03
% AUTHOR: Andri M. Gretarsson
%
% SYNTAX: [xcoord,ycoord,zcoord,h]=figtext3D(x,y,z,textstring <,fontsize>);
%     or                          h=figtext3D(x,y,z,textstring <,fontsize>);
%
%     arguments in <...> are optional
%
% Writes the text in the string textstring to the current figure
% at the location given by x,y.  The location is specified on a 
% 10x10 grid with x=0, y=0 corresponding to the lower left hand 
% corner of the figure.  The font size of the text can be optionally
% specified (in points) by supplying the argument fontsize.
% [xcoord,ycoord] returns the value of the axes coordinates at
% the position specified by x,y. The third output argument h, is 
% the handle to the text written to the figure.
%
% Last updated: 4/15/03 by AMG
%
%---------------------------------------------------------------------------
% SYNTAX: [xcoord,ycoord,zcoord,h]=figtext3D(x,y,z,textstring <,fontsize>);
%     or                         h=figtext3D(x,y,z,textstring <,fontsize>);
%---------------------------------------------------------------------------

function varargout=figtext3D(x,y,z,textstring,varargin);

xlim=get(gca,'XLim');
ylim=get(gca,'Ylim');
zlim=get(gca,'Zlim');
xlen=xlim(2)-xlim(1);
ylen=ylim(2)-ylim(1);
zlen=zlim(2)-zlim(1);
ndiv=10;

xscale=get(gca,'XScale');
yscale=get(gca,'YScale');
zscale=get(gca,'ZScale');

if xscale(1:3)=='log'
    xcoord=10^(log10(xlim(1))+x/ndiv*(log10(xlim(2))-log10(xlim(1))));
else 
    xcoord=xlim(1)+x/ndiv*xlen;
end
if yscale(1:3)=='log'
    ycoord=10^(log10(ylim(1))+y/ndiv*(log10(ylim(2))-log10(ylim(1))));
else
    ycoord=ylim(1)+y/ndiv*ylen;
end
if zscale(1:3)=='log'
    zcoord=10^(log10(zlim(1))+z/ndiv*(log10(zlim(2))-log10(zlim(1))));
else
    zcoord=zlim(1)+z/ndiv*zlen;
end

if nargin>=5
    h=text(xcoord,ycoord,zcoord,textstring,'FontSize',varargin{1});
else
    h=text(xcoord,ycoord,zcoord,textstring);
end

if nargout>1
    varargout{1}=xcoord;
    varargout{2}=ycoord;
    varargout{3}=zcoord;
    varargout{4}=h;
else
    varargout{1}=h;
end