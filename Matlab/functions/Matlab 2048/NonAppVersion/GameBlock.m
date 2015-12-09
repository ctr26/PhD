classdef GameBlock < handle
    % GameBlock  Class for drawing the game block
        
    % Copyright 2014 The MathWorks, Inc.
    % Jiro Doke

    properties (SetAccess = protected)
        Position
        Txt
        Width
        Height
    end
    
    properties (Dependent)
        RectanglePosition
    end
    
    properties (Access = protected)
        hBox
        hText
    end
    
    methods
        function obj = GameBlock(x, y, txt, wd, ht, hAx)
            
            if nargin == 0
                return;
            end
            
            error(nargchk(5,6,nargin,'struct')) %#ok<NCHKN>
            
            if nargin == 5
                hAx = gca;
            end
            
            validateattributes(x, {'numeric'}, {'vector'}, mfilename, 'X');
            validateattributes(y, {'numeric'}, {'vector', 'size', size(x)}, mfilename, 'Y');
            validateattributes(txt, {'cell'}, {'vector', 'size', size(x)}, mfilename, 'TXT');
            validateattributes(wd, {'numeric'}, {'scalar', 'positive'}, mfilename, 'WD');
            validateattributes(ht, {'numeric'}, {'scalar', 'positive'}, mfilename, 'HT');
            validateattributes(hAx, {'numeric','matlab.graphics.axis.Axes'}, {'scalar'}, mfilename, 'HAX');
            
            if ~ishandle(hAx)
                error('HAX must be a valid handle to an axes');
            end
            
            obj(length(x)) = GameBlock;
            
            for id = 1:length(x)
                obj(id).Position = [x(id), y(id)];
                obj(id).Width = wd;
                obj(id).Height = ht;
                obj(id).Txt = txt{id};
                obj(id).hBox = rectangle(...
                    'Parent', hAx, ...
                    'Position', obj(id).RectanglePosition, ...
                    'Curvature', [.1 .1], ...
                    'EdgeColor', 'none', ...
                    'FaceColor', [205 192 180]/255);
                obj(id).hText = text(x(id), y(id), txt{id}, ...
                    'Parent', hAx, ...
                    'VerticalAlignment', 'middle', ...
                    'HorizontalAlignment', 'center', ...
                    'FontName', 'Calibri', ...
                    'FontWeight', 'bold', ...
                    'FontUnits', 'Pixels', ...
                    'FontSize', 48);
            end
            
            updateColors(obj)
            
        end
        
        function val = get.RectanglePosition(obj)
            val = [obj.Position-[obj.Width/2, obj.Height/2], obj.Width, obj.Height];
        end
        
        function updateColors(obj)
            txt = get([obj.hText], 'String');
            bgcolors = repmat([237 194 46]/255, length(obj), 1);
            fgcolors = repmat([249 246 242]/255, length(obj), 1);
            fontsize = 28*ones(length(obj),1);
            fontsizeTable = [48 48 36 32 28 24];
            ii = strcmp('', txt);
            bgcolors(ii, :) = repmat([205 192 180]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(1);
            ii = strcmp('2', txt);
            bgcolors(ii, :) = repmat([238 228 218]/255, nnz(ii), 1);
            fgcolors(ii, :) = repmat([119 110 101]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(1);
            ii = strcmp('4', txt);
            bgcolors(ii, :) = repmat([237 224 200]/255, nnz(ii), 1);
            fgcolors(ii, :) = repmat([119 110 101]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(1);
            ii = strcmp('8', txt);
            bgcolors(ii, :) = repmat([242 178 121]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(1);
            ii = strcmp('16', txt);
            bgcolors(ii, :) = repmat([245 151 100]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(2);
            ii = strcmp('32', txt);
            bgcolors(ii, :) = repmat([246 124 95]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(2);
            ii = strcmp('64', txt);
            bgcolors(ii, :) = repmat([246 94 59]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(2);
            ii = strcmp('128', txt);
            bgcolors(ii, :) = repmat([237 207 114]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(3);
            ii = strcmp('256', txt);
            bgcolors(ii, :) = repmat([237 204 97]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(3);
            ii = strcmp('512', txt);
            bgcolors(ii, :) = repmat([237 200 80]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(3);
            ii = strcmp('1024', txt);
            bgcolors(ii, :) = repmat([237 197 63]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(4);
            ii = ismember(txt, {'2048', '4096', '8192'});
            bgcolors(ii, :) = repmat([237 194 46]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(4);
            ii = ismember(txt, {'16384', '32768', '65536'});
            bgcolors(ii, :) = repmat([237 194 46]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(5);
            ii = ismember(txt, {'131072', '262144', '524288'});
            bgcolors(ii, :) = repmat([237 194 46]/255, nnz(ii), 1);
            fontsize(ii) = fontsizeTable(6);
                                    
            set([obj.hBox], {'FaceColor'}, num2cell(bgcolors,2));
            set([obj.hText], {'Color','FontSize'}, ...
                [num2cell(fgcolors,2), num2cell(fontsize)]);
            
        end
        
        function set(obj, pos, txt)
            if ~isempty(pos) && ~isempty(txt)
                set([obj.hBox], {'Position'}, ...
                    num2cell([pos'-[[obj.Width]/2; [obj.Height]/2]; [obj.Width]; [obj.Height]]',2))
                set([obj.hText], {'String', 'Position'}, ...
                   [txt(:), num2cell([pos, zeros(size(pos,1),1)],2)])
            elseif isempty(pos) && ~isempty(txt)
                set([obj.hText], {'String'}, txt(:))
            elseif ~isempty(pos) && isempty(txt)
                set([obj.hBox], {'Position'}, ...
                    num2cell([pos'-[[obj.Width]/2; [obj.Height]/2]; [obj.Width]; [obj.Height]]',2))
                set([obj.hText], {'Position'}, ...
                   num2cell([pos, zeros(size(pos,1),1)],2))
            else
                error('Either POS or TXT must be non-empty');
            end
        end
        
        function bringToTop(obj)
            uistack([obj.hBox], 'top');
            uistack([obj.hText], 'top');
        end
    end
end