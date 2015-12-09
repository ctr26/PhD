%----------------------------------------------------------------
% Returns the ABCD matrix for reflection from a spherical mirror.
%
% SYNTAX: abcd=mirr(R);
%            <...> indicates optional argument
%
% R = mirror radius of curvature
%
% abcd = |  1   0 |
%        |-2/R  1 |
%
%----------------------------------------------------------------
% SYNTAX: abcd=mirr(R);
%----------------------------------------------------------------

function abcd=mirr(R)

abcd=[
    1       0
    -2/R    1
];