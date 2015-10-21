function direction = myAI_sequential(~)
% Sequentially select directions from "moves" cell array

% Copyright 2014 The MathWorks, Inc.
% Jiro Doke

persistent counter
if isempty(counter)
    counter = 0;
end

% The order in which moves are selected
moves = {'left','up','right','down'};

direction = moves{mod(counter,length(moves))+1};
counter = counter+1;
