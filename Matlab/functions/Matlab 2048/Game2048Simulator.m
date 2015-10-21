classdef Game2048Simulator < handle
    % Game2048Simulator  Simulate algorithms for solving the 2048 game
    %
    %   OBJ = GAME2048SIMULATOR(AIFCN) creates a simulator using the
    %   algorithm AIFCN. AIFCN must be a function handle to a function that
    %   takes in a 4x4 matrix representing the game board and returns a
    %   character array representing the direction ('up', 'down', 'right',
    %   'left').
    %
    %   Game2048Simulator Properties:
    %     Game
    %     Result
    %     AIFcn
    %
    %   Game2048Simulator Methods:
    %     simulate   - Simulate the game
    %     viewResult - View the results from simulation
    %
    % Examples:
    %   Create the following function:
    %     function direction = myAI(~)
    %       d = {'up', 'down', 'right', 'left'};
    %       direction = d{randi(4)};
    %
    %   g = Game2048Simulator(@myAI);
    %   simulate(g, 100)
    %   viewResult(g, 15)

    % Copyright 2014 The MathWorks, Inc.
    % Jiro Doke
    
    properties (SetAccess = protected)
        Game
        Result
    end
        
    properties
        AIFcn
    end
    
    methods
        function obj = Game2048Simulator(fcn)
            error(nargchk(1,1,nargin,'struct')) %#ok<NCHKN>
            
            validateattributes(fcn, {'function_handle'}, {'scalar'}, mfilename, 'FCN');
            
            obj.Game = TwentyFortyEight(false, true);
            obj.Game.AIMode = true;
            obj.AIFcn = fcn;
        end
        
        function simulate(obj,num)
            % simulate   Simulate the game
            %
            %   SIMULATE(OBJ, N) simulates the game using the supplied
            %   algorithm for N times.
            %
            %   If you have Parallel Computing Toolbox, try starting a pool
            %   of workers to run the simulations in parallel.
            %
            % Examples:
            %   g = Game2048Simulator(@myAI);
            %   simulate(g, 100)
            %   viewResult(g, 15)
            
            error(nargchk(2,2,nargin,'struct')) %#ok<NCHKN>
            
            obj.Result = [];
            
            Won = false(num,1);
            Score = nan(num,1);
            NumMoves = nan(num,1);
            HighestBlock = nan(num,1);
            
            % Run the simulations in parallel if PCT is installed.
            %
            % For R2013b or newer, make use of PARFEVAL so that we can look
            % at the progress using WAITBAR
            if ~verLessThan('matlab', '8.2') && ...
                    license('test', 'distrib_computing_toolbox') && ...
                    ~isempty(gcp('nocreate'))

                hW = waitbar(0, 'Preparing simulation...');
                for id = num:-1:1
                    F(id) = parfeval(@obj.simulateOnce, 4);
                    waitbar((num-id)/num, hW)
                end
                
                for id = 1:num
                    [~, Won(id), Score(id), NumMoves(id), HighestBlock(id)] = fetchNext(F);
                    waitbar(id/num, hW, 'Simulating...')
                end
                delete(hW)
            else
                displayPCTWarning()
                
                fprintf('Simulating...')
                parfor id = 1:num
                    [Won(id), Score(id), NumMoves(id), HighestBlock(id)] = simulateOnce(obj);
                end
                fprintf('Done\n')
            end
            
            obj.Result = struct(...
                'Won', Won, ...
                'Score', Score, ...
                'NumMoves', NumMoves, ...
                'HighestBlock', HighestBlock);
        end
        
        function viewResult(obj, nBins)
            % viewResult   View the results from simulation
            %
            %   VIEWRESULT(OBJ) displays a histogram of the scores from
            %   the simulation, grouped by the highest block number for
            %   each simulation.
            %
            %   VIEWRESULT(OBJ, NBINS) specifies the number of bins to use
            %   for the histogram.
            %
            % Examples:
            %   g = Game2048Simulator(@myAI);
            %   simulate(g, 100)
            %   viewResult(g, 15)
            
            if isempty(obj.Result)
                disp('No results available. Simulate first.')
                return
            end
            
            % Group the results based on score and highest block
            if nargin == 1
                nBins = 10;
            end
            [~,bins] = hist(obj.Result.Score,nBins);
            
            diffb = diff(bins);
            step = diffb(1)/2;
            
            uniqueBlocks = unique(obj.Result.HighestBlock);
            
            mat = zeros(length(bins),length(uniqueBlocks));
            
            for i = 1:length(bins)
                for j = 1:length(uniqueBlocks)
                    if i == 1
                        idxs = obj.Result.Score >= bins(i)-step & obj.Result.Score <=  bins(i)+step;
                    else
                        idxs = obj.Result.Score > bins(i)-step & obj.Result.Score <=  bins(i)+step;
                    end
                    mat(i,j) = sum(idxs & obj.Result.HighestBlock == uniqueBlocks(j));
                end
            end
            
            % Draw
            figure;
            bar(bins,mat,'BarLayout','stacked','BarWidth',1);
            grid on
            title({sprintf('Histogram of 2048 Simulation Results for "%s"', func2str(obj.AIFcn));...
                'Color denotes highest block created'}, 'interpreter', 'none');
            ylabel('Number of Simulations');
            xlabel('Score');
            legend(cellstr(num2str(uniqueBlocks)));
            
            
        end
        
        
    end
    
    methods (Access = protected)
        function [Won, Score, NumMoves, HighestBlock] = simulateOnce(obj)
            % Simulates for one game
            
            % Reset game
            reset(obj.Game)
            
            % This initializes
            Game2048AIPlayer()
            while true
                Game2048AIPlayer(obj.Game, obj.AIFcn);
                if isGameWon(obj.Game) || isGameOver(obj.Game)
                    break
                end
            end
            obj.Game.Scores = obj.Game.Scores(~isnan(obj.Game.Scores));
            
            if nargout
                Won = isGameWon(obj.Game);
                Score = obj.Game.Scores(end);
                NumMoves = obj.Game.NumMoves;
                HighestBlock = obj.Game.HighestBlock;
            end
        end
    end
end

function displayPCTWarning()

if ~verLessThan('matlab', '8.2')
    if license('test', 'distrib_computing_toolbox') && ...
            isempty(gcp('nocreate'))
        warning('Consider starting a "parpool" to speed up the simulation');
    end
else
    if license('test', 'distrib_computing_toolbox') && ...
            matlabpool('size') == 0 %#ok<DPOOL>
        warning('Consider starting a "matlabpool" to speed up the simulation');
    end
end

end