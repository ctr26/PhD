%---------------------------------------------------------------
% PROGRAM: figtext
% DATE: 4/15/03
% AUTHOR: Andri M. Gretarsson
%
% SYNTAX: [xcoord,ycoord,h]=figtext(x,y,textstring <,fontsize>);
%     or                  h=figtext3D(x,y,textstring <,fontsize>);
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
%----------------------------------------------------------------
% SYNTAX: [xcoord,ycoord,h]=figtext(x,y,textstring <,fontsize>);
%     or                  h=figtext(x,y,textstring <,fontsize>);
%----------------------------------------------------------------

function varargout=figtext(x,y,textstring,varargin);

xlim=get(gca,'XLim');
ylim=get(gca,'Ylim');
xlen=xlim(2)-xlim(1);
ylen=ylim(2)-ylim(1);
ndiv=10;

xscale=get(gca,'XScale');
yscale=get(gca,'YScale');

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

if nargin>=4
    h=text(xcoord,ycoord,textstring,'FontSize',varargin{1});
else
    h=text(xcoord,ycoord,textstring);
end

if nargout>1
    varargout{1}=xcoord;
    varargout{2}=ycoord;
    varargout{4}=h;
else
    varargout{1}=h;
end