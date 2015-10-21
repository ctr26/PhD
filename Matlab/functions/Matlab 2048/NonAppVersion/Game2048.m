classdef Game2048 < handle
    % Game2048  App for the 2048 game
    
    % Copyright 2014 The MathWorks, Inc.
    % Jiro Doke

    properties (SetAccess = protected)
        hFig    % Handle of main UI        
    end
    
    properties (Access = protected)
        Game    % TwentyFortyEight game object
        Blocks  % Array of GameBlock objects
                               
        hHistoryAxes    % Handle of the plot showing score history
        hCurrentScoreLine   % Handle of current score plot
        
        hAllScoresTable     % Handle of table showing all scores
        
        hScore  % Handle of text object displaying current score
        hMoves  % Handle of text object displaying current move number
        
        Animation = true    % Flag indicating whether to animate
        HistoryDisplay = false      % Flag indicating whether to display history
                
        iconData    % Icon CDATA for toolbar
        
        hToolbarButtons
        
        lhMoved
        lhGameOver
        lhGameWon
    end
    
    properties (Access = protected, Constant)
        xPts = repmat(0.5:3.5, 4, 1)    % X coordinates of blocks
        yPts = repmat((3.5:-1:0.5)', 1, 4)  % Y coordinates of blocks
    end
    
    properties (Access = protected, Dependent)
        ScreenSize  % Screen size ([width height])
    end
    
    methods
        function obj = Game2048
            % Construct game object
            obj.Game = TwentyFortyEight(true);
                         
            % Add event listeners 
            obj.lhMoved = event.listener(obj.Game, 'Moved', @obj.updateBlocks);
            obj.lhGameOver = event.listener(obj.Game, 'GameOver', @obj.GameOver);
            obj.lhGameWon = event.listener(obj.Game, 'YouWin', @obj.GameWon);
                        
            % Construct main UI
            obj.hFig = figure(...
                'NumberTitle', 'off', ...
                'Name', '2048 MATLAB', ...
                'HandleVisibility', 'off', ...
                'Toolbar', 'none', ...
                'Menu', 'none', ...
                'Color', 'white', ...
                'Units', 'Pixels', ...
                'Position', [obj.ScreenSize/2-[210, 240], 420, 480], ...
                'Visible', 'off', ...
                'BusyAction', 'cancel', ...
                'Interruptible', 'off', ...
                'Resize', 'off', ...
                'DockControl', 'off', ...
                'DeleteFcn', @obj.figDelFcn, ...
                'WindowKeyPressFcn', @obj.KeyPressFcn);
            
            % Construct toolbar
            obj.iconData = load(fullfile(fileparts(mfilename), 'iconData'));
            hToolbar = uitoolbar(...
                'Parent', obj.hFig);
            obj.hToolbarButtons(1) = uipushtool(...
                'Parent', hToolbar, ...
                'CData', obj.iconData.new, ...
                'TooltipString', 'New game', ...
                'ClickedCallback', @obj.newGame);
            obj.hToolbarButtons(2) = uitoggletool(...
                'Parent', hToolbar, ...
                'CData', obj.iconData.animOn, ...
                'Separator', 'on', ...
                'TooltipString', 'Animation: ON', ...
                'State', 'on', ...
                'ClickedCallback', @obj.toggleAnimation);
            obj.hToolbarButtons(3) = uitoggletool(...
                'Parent', hToolbar, ...
                'CData', obj.iconData.eightball, ...
                'Separator', 'on', ...
                'State', 'off', ...
                'TooltipString', 'Run AI...', ...
                'ClickedCallback', @obj.runAI);
            obj.hToolbarButtons(4) = uitoggletool(...
                'Parent', hToolbar, ...
                'CData', obj.iconData.curves, ...
                'Separator', 'on', ...
                'TooltipString', 'Show history', ...
                'State', 'off', ...
                'ClickedCallback', @obj.toggleHistory);
            obj.hToolbarButtons(5) = uipushtool(...
                'Parent', hToolbar, ...
                'CData', obj.iconData.page_white, ...
                'TooltipString', 'Clear all scores...', ...
                'ClickedCallback', @obj.clearScores);
            obj.hToolbarButtons(6) = uipushtool(...
                'Parent', hToolbar, ...
                'CData', obj.iconData.lightbulb, ...
                'Separator', 'on', ...
                'TooltipString', 'About...', ...
                'ClickedCallback', @aboutGame);
            
            % Construct main axes
            hAx = axes(...
                'Parent', obj.hFig, ...
                'Units', 'Pixels', ...
                'Position', [10 10 400 400], ...
                'Color', [187 173 160]/255, ...
                'XLim', [0 4], ...
                'YLim', [0 4], ...
                'XTick', [], ...
                'YTick', [], ...
                'XColor', [187 173 160]/255, ...
                'YColor', [187 173 160]/255, ...
                'Box', 'on', ...
                'XTickLabel', [], ...
                'YTickLabel', [], ...
                'PlotBoxAspectRatio', [1 1 1]);
            
            obj.hScore = uicontrol(...
                'Parent', obj.hFig, ...
                'Units', 'Pixels', ...
                'Position', [10 420 200 50], ...
                'Style', 'Text', ...
                'FontUnits', 'Pixels', ...
                'FontSize', 14, ...
                'HorizontalAlignment', 'left', ...
                'BackgroundColor', get(obj.hFig, 'Color'), ...
                'String', sprintf('Score: 0\nBest: %d', obj.Game.HighScore));
            obj.hMoves = uicontrol(...
                'Parent', obj.hFig, ...
                'Units', 'Pixels', ...
                'Position', [300 420 120 50], ...
                'Style', 'Text', ...
                'FontUnits', 'Pixels', ...
                'FontSize', 14, ...
                'HorizontalAlignment', 'left', ...
                'BackgroundColor', get(obj.hFig, 'Color'), ...
                'String', sprintf('Moves: %d', obj.Game.NumMoves));
            
            % Background blocks
            GameBlock(obj.xPts(:), obj.yPts(:), ...
                repmat({''}, 16, 1), .9, .9, hAx);
            
            % Game blocks
            obj.Blocks = GameBlock(obj.xPts(:), obj.yPts(:), ...
                repmat({''}, 16, 1), .9, .9, hAx);
            
            % Construct score history panel
            hPanel = uipanel(...
                'Parent', obj.hFig, ...
                'Units', 'Pixels', ...
                'Position', [430 0 400 480]);
            obj.hAllScoresTable = uitable(hPanel, ...
                'Units', 'Pixels', ...
                'Position', [80 280 300 180], ...
                'ColumnName', {'Score', 'Moves', 'Highest block'}, ...
                'ColumnWidth', {50 50, 140});
            obj.hHistoryAxes = axes(...
                'Parent', hPanel, ...
                'Units', 'Pixels', ...
                'Position', [80 50 300 190]);
            updateAllScoresData(obj)

            updateBlocks(obj)
            
            set(obj.hFig, 'Visible', 'on');
        end
        
        function runAI(obj, varargin)
            % runAI  Run an AI algorithm to solve the puzzle
            
            if strcmp(get(varargin{1}, 'State'), 'off')
                return
            end
            
            % Select a function from the current folder. To make it simple,
            % I only allow running an AI algorithm
            [fn, pn] = uigetfile('*.m', 'Select an AI function', 'MultiSelect', 'off');
            if isnumeric(fn)
                return
            end
            
            % CD to the path so that the function is visible
            cd(pn)
            
            % Create function handle
            [~, n] = fileparts(fn);
            AIfcn = str2func(n);
            
            % Turn off GameWon/GameOver listener temporarily, since I check
            % manually. Also disable other toolbar buttons
            obj.lhGameWon.Enabled = false;
            obj.lhGameOver.Enabled = false;
            set(obj.hToolbarButtons([1 2 4 5 6]), 'Enable', 'off');
            
            obj.Game.AIMode = true;
            
            % Initialize
            Game2048AIPlayer()
            while strcmp(get(varargin{1}, 'State'), 'on')
                try
                    Game2048AIPlayer(obj.Game, AIfcn);
                catch ME
                    uiwait(errordlg(ME.message, 'Error', 'modal'));
                    break
                end
                if isGameWon(obj.Game) || isGameOver(obj.Game)
                    break
                end
                drawnow
            end
            
            set(varargin{1}, 'State', 'off')
            set(obj.hToolbarButtons([1 2 4 5 6]), 'Enable', 'on');

            if isGameWon(obj.Game)
                GameWon(obj)
            elseif isGameOver(obj.Game)
                GameOver(obj)
            end

            if isvalid(obj.Game)
                obj.Game.AIMode = false;
            end

            obj.lhGameWon.Enabled = true;
            obj.lhGameOver.Enabled = true;
        end
        
        function val = get.ScreenSize(~)
            set(0, 'Units', 'Pixels')
            sc = get(0, 'ScreenSize');
            val = sc(3:4);
        end
        
        function updateAllScoresData(obj)
            % updateAllScoresData  Refresh score history table and plot
            
            set(obj.hScore, 'String', ...
                sprintf('Score: %d\nBest: %d', max(obj.Game.Scores), obj.Game.HighScore));
            
            if isempty(obj.Game.AllScores)
                data = {};
            else
                %data = table2cell(obj.Game.AllScores(:,[1 3 4]));
                data = [obj.Game.AllScores.FinalScore; obj.Game.AllScores.Moves; obj.Game.AllScores.HighBlock]';
            end
            set(obj.hAllScoresTable, 'Data', data);
            
            cla(obj.hHistoryAxes);
            if ~isempty(obj.Game.AllScores)
                % Plot the trajectories of previous scores
                % hp = cellfun(@(x) line(1:length(x),x,'Parent',obj.hHistoryAxes), flipud(obj.Game.AllScores.Scores));
                hp = cellfun(@(x) line(1:length(x),x,'Parent',obj.hHistoryAxes), fliplr({obj.Game.AllScores.Scores}));
                set(hp(1:end-1), 'Color', [.7 .7 .7]);
            end
            
            % Plot current score line
            if obj.Game.NumMoves == 0
                obj.hCurrentScoreLine = line(nan, nan, ...
                    'Color', [1 0 0], ...
                    'Parent', obj.hHistoryAxes);
            else
                obj.hCurrentScoreLine = line(1:obj.Game.NumMoves, obj.Game.Scores(~isnan(obj.Game.Scores)), ...
                    'Color', [1 0 0], ...
                    'Parent', obj.hHistoryAxes);
                xlim(obj.hHistoryAxes, [max(0,obj.Game.NumMoves-25), obj.Game.NumMoves+25])
            end
            
            % Add legend
            if isempty(obj.Game.AllScores)
                title(obj.hHistoryAxes, 'Current game');
            else
                title(obj.hHistoryAxes, 'Best game (blue), Current game (red)');
            end
            set(obj.hHistoryAxes, 'Box', 'on');
            xlabel(obj.hHistoryAxes, 'Moves');
            ylabel(obj.hHistoryAxes, 'Score');
        end
        
        function toggleHistory(obj, varargin)
            % toggleHistory  Toggle the display of score history
            
            obj.HistoryDisplay = ~obj.HistoryDisplay;
            
            if obj.HistoryDisplay
                figWidth = 830;
                set(varargin{1}, ...
                    'State', 'on', ...
                    'TooltipString', 'Hide history')
                
                % Turn on panel visibility
                set(ancestor(obj.hAllScoresTable, 'uipanel'), 'Visible', 'on')
            else
                figWidth = 420;
                set(varargin{1}, ...
                    'State', 'off', ...
                    'TooltipString', 'Show history')
                
                % Turn off panel visibility
                set(ancestor(obj.hAllScoresTable, 'uipanel'), 'Visible', 'off')
            end
            
            % Change figure size
            curPos = get(obj.hFig, 'Position');
            if curPos(1)+figWidth < obj.ScreenSize(1)
                set(obj.hFig, 'Position', [curPos(1:2), figWidth 480]);
            else
                set(obj.hFig, 'Position', [obj.ScreenSize(1)-figWidth, curPos(2), figWidth, 480]);
            end

        end
        
        function KeyPressFcn(obj, ~, edata)
            % KeyPressFcn  Callback to handle key presses
            
            if any(strcmp(edata.Key, ...
                    {'escape', 'uparrow', 'downarrow', 'rightarrow', 'leftarrow'}))
                switch edata.Key
                    case 'uparrow'
                        move(obj.Game, 'up');
                    case 'downarrow'
                        move(obj.Game, 'down');
                    case 'rightarrow'
                        move(obj.Game, 'right');
                    case 'leftarrow'
                        move(obj.Game, 'left');
                    case 'escape'
                        delete(obj.hFig)
                    otherwise
                        return
                end
            end
        end
        
        function figDelFcn(obj, varargin)
            % figDelFcn  Callback when figure is deleted
            
            % Delete the game object - this performs clean up actions
            delete(obj.Game)
        end
        
        function newGame(obj, varargin)
            % newGame  Callback when the "New Game" toolbar button is pressed
            
            if nargin > 1
                btn = questdlg('Abandon current game?', 'New Game', 'Yes', 'No', 'Yes');
                switch btn
                    case 'No'
                        return
                end
            end
            
            % Reset game object
            reset(obj.Game)
            
            % Update the score history
            updateAllScoresData(obj)
            
            % Update the block visualization
            updateBlocks(obj)
        end
        
        function GameWon(obj, varargin)
            % GameWon  Callback when the "YouWin" event is triggered
            
            btn = questdlg({'You won! Congratulations!', '', 'Continue playing?'}, 'You Won', 'Continue playing', 'Play new game', 'Quit', 'Continue playing');
            switch btn
                case 'Continue playing'
                    obj.Game.StopNumber = inf;
                case 'Play new game'
                    newGame(obj)
                case 'Quit'
                    delete(obj.hFig)
            end
        end
        
        function GameOver(obj, varargin)
            % GameOver  Callback when the "GameOver" event is triggered
            
            btn = questdlg({'No more moves', '', 'Play again?'}, 'Game Over', 'Play new game', 'Quit', 'Play new game');
            switch btn
                case 'Play new game'
                    newGame(obj)
                case 'Quit'
                    delete(obj.hFig)
            end
        end
        
        function updateBlocks(obj, varargin)
            % updateBlocks  Update the block positions
            
            if ishandle(obj.hFig)
                blocksMoving = obj.Game.Movement ~= reshape(1:16,4,4);
                if nnz(blocksMoving) > 0 && obj.Animation
                    xFrom = obj.xPts(:);
                    yFrom = obj.yPts(:);
                    xTo = obj.xPts(obj.Game.Movement(:));
                    yTo = obj.yPts(obj.Game.Movement(:));
                    
                    % Bring blocks (patches) to the top so that the
                    % animation displays correctly
                    bringToTop(obj.Blocks(blocksMoving));
                    
                    % Animate 15 frames for transition
                    frms = 15;
                    for id = 1:frms
                        set(obj.Blocks, [xFrom+id/frms*(xTo-xFrom), yFrom+id/frms*(yTo-yFrom)], []);
                        drawnow expose
                        %pause(0.01);
                    end    
                end
                
                % Display the final block positions
                txt = cellfun(@num2str, num2cell(obj.Game.Board), 'UniformOutput', false);
                txt(strcmp(txt, 'NaN')) = {''};
                set(obj.Blocks, [obj.xPts(:), obj.yPts(:)], txt);
                updateColors(obj.Blocks);
                
                set(obj.hScore, 'String', sprintf('Score: %d\nBest: %d', max(obj.Game.Scores), obj.Game.HighScore));
                set(obj.hMoves, 'String', sprintf('Moves: %d', obj.Game.NumMoves));
                
                if obj.HistoryDisplay
                    if obj.Game.NumMoves == 0
                        set(obj.hCurrentScoreLine, 'XData', nan, 'YData', nan)
                        xlim(obj.hHistoryAxes, 'auto')
                    else
                        set(obj.hCurrentScoreLine, 'XData', 1:obj.Game.NumMoves, 'YData', obj.Game.Scores(~isnan(obj.Game.Scores)));
                        xlim(obj.hHistoryAxes, [max(0,obj.Game.NumMoves-25), obj.Game.NumMoves+25])
                    end
                end
            end
        end
                
        function clearScores(obj, varargin)
            % clearScores  Clear all previous scores
            
            btn = questdlg('Clear all scores?', 'Clear Scores', 'Yes', 'No', 'Yes');
            if strcmp(btn, 'No')
                return;
            end
            clearScores(obj.Game);
            updateAllScoresData(obj)
        end
        
        function toggleAnimation(obj, varargin)
            % toggleAnimation  Turn on/off animation of blocks
            
            obj.Animation = ~obj.Animation;
            if obj.Animation
                set(varargin{1}, ...
                    'TooltipString', 'Animation: ON', ...
                    'CData', obj.iconData.animOn);
            else
                set(varargin{1}, ...
                    'TooltipString', 'Animation: OFF', ...
                    'CData', obj.iconData.animOff);
            end
        end
    end
    
end

function aboutGame(varargin)
uiwait(msgbox({'2048 - MATLAB Edition', ...
    'By Jiro Doke', ...
    'Copyright 2014 The MathWorks, Inc.', '', ...
    'Based on a game by Gabriele Cirulli.', ...
    'Toolbar icons from http://www.famfamfam.com/lab/icons/silk/', '', ...
    ['How to play: Use arrow keys to move the tiles. ', ...
    'When two tiles with the same number touch, they merge into one.']}, ...
    'About', 'Help', 'modal'));
end
