%---------------------------------------------------------------
% Returns the ABCD matrix for propagation through a thin lens.
%
% SYNTAX: abcd=lens(f);
%
%
% f = lens focal length
%
% abcd = |  1    0 |
%        |-1/f   1 |
%
%---------------------------------------------------------------
% SYNTAX: abcd=lens(f);
%---------------------------------------------------------------

function abcd=lens(f)

abcd=[
    1       0
    -1/f    1
];