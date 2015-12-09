Game 2048 - MATLAB Edition


* If you are running R2012b or newer, install the App by double-clicking on "2048 MATLAB.mlappinstall".

* If you are running R2009b - R2012a, run "play2048" inside the folder "NonAppVersion".

* For programmatically simulating game solving algorithms, use "Game2048Simulator". For example,

    g = Game2048Simulator(@myAI);
    simulate(g, 100)
    viewResult(g, 15)


The algorithm must be a function that takes in a 4x4 matrix representing the game board (NaN for empty spots) and returns a character array representing the direction to move ('up', 'down', 'right', 'left'). See "myAI.m" and "myAI_sequential.m".


% Copyright 2014 The MathWorks, Inc.
% Jiro Doke
