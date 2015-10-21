% Puts a scale marker ("scale bar") on a plot at position (x,y).  The length of the
% marker is set by markerlength.  The string textlabel usually contains the
% "real life" length the marker is supposed to represent.  The final optional
% argument is the orientation.  It should be 'h' for horizontal (default) or 'v'
% for vertical.

function [h,th]=scalemarker(x,y,markerlength,textlabel,varargin);


if nargin>=5, orientation=varargin{1}; else orientation='h'; end

xlimits=get(gca,'XLim');
ylimits=get(gca,'YLim');
xrange=abs(diff(xlimits));
yrange=abs(diff(ylimits));

if orientation=='h'
    x1=x-markerlength/2;
    x2=x+markerlength/2;
    y1=y-yrange/90;
    y2=y+yrange/90;
    h=plot([x1 x2],[y y],'k-',[x1 x1],[y1 y2],'k-',[x2 x2],[y1 y2],'k-');
    th=text(x1,y2+yrange/75,[' ',textlabel]);
else
    x1=x-xrange/120;
    x2=x+xrange/120;
    y1=y-markerlength/2;
    y2=y+markerlength/2;
    h=plot([x x],[y1 y2],'k-',[x1 x2],[y1 y1],'k-',[x1 x2],[y2 y2],'k-');
    th=text(x2,y1,strvcat(textlabel,' ',' '));
end

