classdef TwentyFortyEight < handle
    % TwentyFortyEight  Game class
    %   This class defines the 2048 game board and is the engine of the
    %   game. You can use this as a command line game, but this is used
    %   primarily by Game2048 which is the app version of it.
    %
    %   The original game was created by created by Gabriele Cirulli. 
    %
    % Examples:
    %   t = TwentyFortyEight()
    %   move(t, 'down')
    %   move(t, 'left')
    %   move(t, 'right')
    %   move(t, 'left')
    %   t
        
    % Copyright 2014 The MathWorks, Inc.
    % Jiro Doke

    properties
        Board = nan(4,4)
        Scores = [0, nan(1,1000)]
        NumMoves = 0
        Movement = reshape(1:16,4,4)
        StopNumber = 2048
        
        HighScore
        
        AIMode = false
    end
    
    properties (Dependent)
        HighestBlock
        AllScores
    end
    
    properties (Constant)
        NewBlockValue = [2 4]
        NewBlockValueProbability = [9 1]
    end
    
    events
        Moved
        GameOver
        YouWin
    end
    
    methods
        function obj = TwentyFortyEight(load_old)
            if nargin == 0
                load_old = false;
            end
            validateattributes(load_old, {'logical'}, {'scalar'}, mfilename, 'LOAD_OLD')
            
            if load_old
                oldgame = getpref('Game2048_v3', 'CurrentGame', []);
                if ~isempty(oldgame) && isfield(oldgame, 'Scores')
                    obj.Board = oldgame.Board;
                    obj.Scores = oldgame.Scores;
                    obj.NumMoves = oldgame.NumMoves;
                    obj.StopNumber = oldgame.StopNumber;
                else
                    addNewBlock(obj)
                end
            else
                addNewBlock(obj)
            end
            
            ac = obj.AllScores;
            if isempty(ac)
                obj.HighScore = 0;
            else
                obj.HighScore = ac(1).FinalScore;
                %                 obj.HighScore = ac.FinalScore(1);
            end
        end
        
        function val = get.HighestBlock(obj)
            val = max(max(obj.Board));
        end
        
        function val = get.AllScores(~)
            val = getpref('Game2048_v3', 'AllScores', []);
        end
        
        function delete(obj)
            
            if isGameOver(obj)
                updateAllScores(obj)
                setpref('Game2048_v3', 'CurrentGame', []);
            else
                if isGameWon(obj)
                    updateAllScores(obj)
                end
                cur.Board = obj.Board;
                cur.Scores = obj.Scores(~isnan(obj.Scores));
                cur.NumMoves = obj.NumMoves;
                cur.StopNumber = obj.StopNumber;
                setpref('Game2048_v3', 'CurrentGame', cur);
            end
        end
        
        function reset(obj)
            obj.Board = nan(4,4);
            obj.Movement = reshape(1:16,4,4);
            addNewBlock(obj)
            obj.Scores = [0, nan(1,1000)];
            obj.NumMoves = 0;
            obj.StopNumber = 2048;
            if ~obj.AIMode
                if isempty(obj.AllScores)
                    obj.HighScore = 0;
                else
                    obj.HighScore = obj.AllScores(1).FinalScore;
                    %                     obj.HighScore = obj.AllScores.FinalScore(1);
                end
            end
        end
        
        function tf = isGameOver(obj)
            if nnz(isnan(obj.Board)) == 0 && ...
                    nnz(diff(obj.Board,1,1) == 0) == 0 && ...
                    nnz(diff(obj.Board,1,2) == 0) == 0
                if nargout
                    tf = true;
                else
                    updateAllScores(obj)
                    notify(obj, 'GameOver')
                end
            else
                if nargout
                    tf = false;
                end
            end
        end
        
        function tf = isGameWon(obj)
            if nnz(obj.Board == obj.StopNumber) > 0
                if nargout
                    tf = true;
                else
                    updateAllScores(obj)
                    notify(obj, 'YouWin')
                end
            else
                if nargout
                    tf = false;
                end
            end
        end
        
        function move(obj, direction)
            error(nargchk(2,2,nargin,'struct')) %#ok<NCHKN>
            
            movement = reshape(1:16,4,4);
            orig_movement = movement;
            emptyID = isnan(obj.Board);
            switch lower(direction)
                case 'up'
                    m = obj.Board;
                    %movement = movement;
                case 'down'
                    m = flipud(obj.Board);
                    movement = flipud(movement);
                case 'right'
                    m = flipud(obj.Board');
                    movement = flipud(movement');
                case 'left'
                    m = obj.Board';
                    movement = movement';
                otherwise
                    error('Invalid DIRECTION. Expected one of the following:\n\n''up'', ''down'', ''right'', ''left''');
            end
            thisScore = 0;
            for ii = 1:4
                x = nan(4,1);
                y = movement(:,ii);
                idx = ~isnan(m(:,ii));
                x(1:nnz(idx)) = m(idx,ii);
                y(idx) = movement(1:nnz(idx),ii);
                sameID = diff(x) == 0;
                if any(sameID)
                    if isequal(sameID, [true;true;true]) || ...
                            isequal(sameID, [true;false;true])
                        x = [x(1)+x(2); x(3)+x(4); nan; nan];
                        [a,b] = ismember(y, movement([2 3 4],ii));
                        c = movement([1 2 2],ii);
                        y(a) = c(b(a));
                        thisScore = thisScore + x(1) + x(2);
                    elseif isequal(sameID, [true;true;false]) || ...
                            isequal(sameID, [true;false;false])
                        x = [x(1)+x(2); x(3); x(4); nan];
                        [a,b] = ismember(y, movement([2 3 4],ii));
                        c = movement([1 2 3],ii);
                        y(a) = c(b(a));
                        thisScore = thisScore + x(1);
                    elseif isequal(sameID, [false;true;true]) || ...
                            isequal(sameID, [false;true;false])
                        x = [x(1); x(2)+x(3); x(4); nan];
                        [a,b] = ismember(y, movement([3 4],ii));
                        c = movement([2 3],ii);
                        y(a) = c(b(a));
                        thisScore = thisScore + x(2);
                    elseif isequal(sameID, [false;false;true])
                        x = [x(1); x(2); x(3)+x(4); nan];
                        [a,b] = ismember(y, movement(4,ii));
                        c = movement(3,ii);
                        y(a) = c(b(a));
                        thisScore = thisScore + x(3);
                    else
                        error('Should not be here')
                    end
                end
                m(:,ii) = x;
                movement(:,ii) = y;
            end
            switch direction
                case 'up'
                    %movement = movement;
                case 'down'
                    m = flipud(m);
                    movement = flipud(movement);
                case 'right'
                    m = flipud(m)';
                    movement = flipud(movement)';
                case 'left'
                    m = m';
                    movement = movement';
            end
            
            if max(obj.Scores)+thisScore > obj.HighScore
                obj.HighScore = max(obj.Scores)+thisScore;
            end
            
            %if ~isequaln(obj.Board, m)
            if ~isequalwithequalnans(obj.Board, m)
                obj.NumMoves = obj.NumMoves + 1;
                if obj.NumMoves > length(obj.Scores)
                    obj.Scores = [obj.Scores, nan(1,1000)];
                end
                obj.Scores(obj.NumMoves) = max(obj.Scores) + thisScore;
                obj.Board = m;
                movement(emptyID) = orig_movement(emptyID);
                obj.Movement = movement;
                addNewBlock(obj);
                
                notify(obj, 'Moved');
                
                isGameWon(obj)
                isGameOver(obj)
            else
                obj.Movement = reshape(1:16,4,4);
            end
        end
        
        function clearScores(obj)
            obj.HighScore = 0;
            setpref('Game2048_v3', 'AllScores', []);
        end
        
        function disp(obj)
            fprintf('Score: %d\n', max(obj.Scores));
            fprintf('Move: %d\n\n', obj.NumMoves);
            disp(obj.Board)
        end
    end
    
    methods (Access = protected)
        function updateAllScores(obj)
            % Don't store score if AIMode
            if obj.AIMode
                return
            end
            
            if isempty(obj.AllScores)
                ac = struct('FinalScore', max(obj.Scores), ...
                    'Scores', obj.Scores(~isnan(obj.Scores)), ...
                    'Moves', obj.NumMoves, ...
                    'HighBlock', obj.HighestBlock);
            else
                ac = obj.AllScores;
                ac(end+1) = struct('FinalScore', max(obj.Scores), ...
                    'Scores', obj.Scores(~isnan(obj.Scores)), ...
                    'Moves', obj.NumMoves, ...
                    'HighBlock', obj.HighestBlock);
            end
            
            %             if isempty(obj.AllScores)
            %                 ac = table(max(obj.Scores), {obj.Scores(~isnan(obj.Scores))}, obj.NumMoves, obj.HighestBlock, ...
            %                     'VariableNames', {'FinalScore', 'Scores', 'Moves', 'HighBlock'});
            %             else
            %                 ac = obj.AllScores;
            %                 ac(end+1,:) = table(max(obj.Scores), {obj.Scores(~isnan(obj.Scores))}, obj.NumMoves, obj.HighestBlock, ...
            %                     'VariableNames', {'FinalScore', 'Scores', 'Moves', 'HighBlock'});
            %             end
            
            % Remove unique entries and sort by score (descending) then by
            % number of moves (ascending)
            %             [~,ii] = unique(ac(:,[1 3 4]));
            %             ac = sortrows(ac(ii,:), [-1 3]);
            [~,ii] = unique([ac.FinalScore; ac.Moves; ac.HighBlock]', 'rows');
            ac = ac(ii);
            [~,ii2] = sortrows([ac.FinalScore; ac.Moves; ac.HighBlock]', [-1 -3 2]);
            ac = ac(ii2);
            
            % Remove score of zero
            if ~isempty(ac)
                ac([ac.FinalScore] == 0) = [];
            end
            if length(ac) > 15
                ac = ac(1:15);
            end
            
            setpref('Game2048_v3', 'AllScores', ac);
        end
        
        function addNewBlock(obj)
            nanID = find(isnan(obj.Board));
            num = randi(numel(nanID),1);
            
            probList = cumsum(TwentyFortyEight.NewBlockValueProbability);
            maxI = sum(TwentyFortyEight.NewBlockValueProbability);
            ID = find(probList >= randi(maxI),1);
            %            % 90% chance for 2 and 10% chance for 4.
            %            if randi(10) < 10
            %                ID = 1;
            %            else
            %                ID = 2;
            %            end
            obj.Board(nanID(num)) = TwentyFortyEight.NewBlockValue(ID);
        end
        
    end
    
end