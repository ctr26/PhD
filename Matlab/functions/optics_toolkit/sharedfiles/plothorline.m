%------------------------------------------------------------------------------
% PROGRAM NAME: Plot horizontal lines
% FILE: plotvertline.m
% AUTHOR: Andri M. Gretarsson
% DATE: 02/03/03
%
% SYNTAX: linehandle=plothorline(y,xmin,xmax <,marker,plotstyle>)
%
% Plots horizontal lines at the positions listed in the vector y. The vertical
% lines extend from xmin to xmax and are ploted with the markerstyle and
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
% If xmin=0 and xmax=0, then ymin and ymax are obtained from the current
% axes.
%
% LAST UPDATED: 03/13/03
%
%-------------------------------------------------------------------------------
% SYNTAX: linehandle=plothorline(y,xmin,xmax <,marker,plotstyle>)
%-------------------------------------------------------------------------------

function linehandle=plothorline(y,xmin,xmax,varargin);

if nargin>=4, marker=varargin{1}; else marker='b-'; end
if nargin>=5, 
    plotstyle=varargin{2}; 
else plotstyle='plot'; 
end
if xmin==0 & xmax==0
    range=get(gca,'XLim');
    xmin=range(1);
    xmax=range(2);
end

NextPlot_current=get(gca,'NextPlot');        % Get the original 'hold' state

if plotstyle(1)=='p'
    for i=1:length(y)
        if marker(1)==''''
            eval(['h=plot([xmin xmax],[y(i) y(i)],',marker,')']); hold on;
        else
            h=plot([xmin xmax],[y(i) y(i)],marker); hold on;
        end
    end
else
if plotstyle(1)=='l'
    for i=1:length(y)
        if marker(1)==''''
            eval(['h=loglog([xmin xmax],[y(i) y(i)],',marker,')']); hold on;
        else
            h=loglog([xmin xmax],[y(i) y(i)],marker); hold on;
        end
    end
else
if (length(plotstyle)==8 &plotstyle(8)=='x')
    for i=1:length(y)
        if marker(1)==''''
            eval(['h=semilogx([xmin xmax],[y(i) y(i)],',marker,')']); hold on;
        else
            h=semilogx([xmin xmax],[y(i) y(i)],marker); hold on;
        end
    end
else
if (length(plotstyle)==8 &plotstyle(8)=='y')
    for i=1:length(y)
        if marker(1)==''''
            eval(['h=semilogy([xmin xmax],[y(i) y(i)],',marker,')']); hold on;
        else
            h=semilogy([xmin xmax],[y(i) y(i)],marker); hold on;
        end
    end
end;end;end;end;

if NextPlot_current(1)=='r'                  % reset to the original 'hold' state
    set(gca,'NextPlot','replace')
else
    set(gca,'NextPlot','add');
end

linehandle=h;