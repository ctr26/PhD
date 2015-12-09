function direction = myAI(~)
% random algorithm

% Copyright 2014 The MathWorks, Inc.
% Jiro Doke

d = {'up', 'down', 'right', 'left'};

direction = d{randi(4)};

end