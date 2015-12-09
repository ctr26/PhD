%------------------------------------------------------------------------------
% PROGRAM NAME: Plot vertical lines
% FILE: plotvertline.m
% AUTHOR: Andri M. Gretarsson
% DATE: 02/03/03
%
% SYNTAX: linehandle=plotvertline(x,ymin,ymax <,marker,plotstyle>)
%
% Plots vertical lines at the positions listed in the vector x. The vertical
% lines extend from ymin to ymax and are ploted with the markerstyle and
% color defined by marker if specified (same syntax as the marker in matlab's 
% built in function plot. Exits with hold set to off. If plotstyle is specified
% then the plotstyle will be linear-linear, lin-log, log-lin or log-log,
% depending on whether plotstyle is 'plot', 'semilogx', 'semilogy', or 'loglog'.
%
% If 'marker' is a string whose first character is an apostrophe ('),
% the marker string in interpreted literally as part of the command, as in:
% eval(['plot([xmin xmax],[y(i) y(i)],',marker,')']);
%
% If the first character of marker is not an apostrophe, the marker string is
% just inserted into the command as usual without using eval, namely:
% plot([xmin xmax],[y(i) y(i)],marker).
%
% Thus, for example:
% marker = '''b-'',''LineWidth'',2' results in the plot command
% plot(x,y,'b-','LineWidth',2) being evaluated.
%
% marker = 'b-' has the same effect as marker = '''b-''', namely
% plot(x,y,'b-'), in the first case directly via plot(x,y,'b-') and
% in the second case via eval(['plot(x,y,',marker,')']).
%
% If ymin=0 and ymax=0, then ymin and ymax are obtained from the current
% axes, and the function draws a line from the bottom to the top of the 
% current graph. 
%
% LAST UPDATED: 03/13/03
%
%-------------------------------------------------------------------------------
% SYNTAX: linehandle=plotvertline(y,xmin,xmax <,marker,plotstyle>)
%-------------------------------------------------------------------------------

function linehandle=plotvertline(x,ymin,ymax,varargin);

if nargin>=4, marker=varargin{1}; else marker='b-'; end
if nargin>=5, 
    plotstyle=varargin{2}; 
else plotstyle='plot'; 
end
if ymin==0 & ymax==0
    range=get(gca,'YLim');
    ymin=range(1);
    ymax=range(2);
end

NextPlot_current=get(gca,'NextPlot');        % Get the original 'hold' state

if plotstyle(1)=='p'
    for i=1:length(x)
        if marker(1)==''''
            eval(['h=plot([x(i) x(i)],[ymin ymax],',marker,')']); hold on;
        else
            h=plot([x(i) x(i)],[ymin ymax],marker); hold on;
        end
    end
else
if plotstyle(1)=='l'
    for i=1:length(x)
        if marker(1)==''''
            eval(['h=loglog([x(i) x(i)],[ymin ymax],',marker,')']); hold on;
        else
            h=loglog([x(i) x(i)],[ymin ymax],marker); hold on;
        end
    end
else
if (length(plotstyle)==8 &plotstyle(8)=='x')
    for i=1:length(x)
        if marker(1)==''''
            eval(['h=semilogx([x(i) x(i)],[ymin ymax],',marker,')']); hold on;
        else
            h=semilogx([x(i) x(i)],[ymin ymax],marker); hold on;
        end
    end
else
if (length(plotstyle)==8 &plotstyle(8)=='y')
    for i=1:length(x)
        if marker(1)==''''
            eval(['h=semilogy([x(i) x(i)],[ymin ymax],',marker,')']); hold on;
        else
            h=semilogy([x(i) x(i)],[ymin ymax],marker); hold on;
        end
    end
end;end;end;end;

if NextPlot_current(1)=='r'                  % reset to the original 'hold' state
    set(gca,'NextPlot','replace')
else
    set(gca,'NextPlot','add');
end

linehandle=h;