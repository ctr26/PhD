function Game2048AIPlayer(game, AIfcn)
% Game2048AIPlayer  Helper function that applies the algorithm for turn

% Copyright 2014 The MathWorks, Inc.
% Jiro Doke

persistent noMoveCount

% Can be forced to initialize
if nargin == 0
    noMoveCount = 0;
    return
end
if isempty(noMoveCount)
    noMoveCount = 0;
end

origBoard = game.Board;
try
    move(game, AIfcn(game.Board))
catch ME
    error(['An error occurred when running the AI algorithm.\n\n', ...
        'Make sure the algorithm is a function that takes ', ...
        'in a matrix representing the game board (4x4 ', ...
        'matrix with NaNs for empty spots) and returns ', ...
        'one of the four strings: ', ...
        '''up'', ''down'', ''right'', ''left''\n\n', ...
        'Error message:\n%s'], ...
        ME.message);
end

% If the turn didn't move anything, increment noMoveCount.
% If it hasn't moved for 50 consecutive turns, stop the
% game. It's most likely stuck.
%if isequaln(origBoard, game.Board)
if isequalwithequalnans(origBoard, game.Board)
    noMoveCount = noMoveCount + 1;
    if noMoveCount >= 50
        error('The algorithm resulted in 50 consecutive turns without any moves');
    end
else
    noMoveCount = 0;
end

end