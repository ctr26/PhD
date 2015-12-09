%----------------------------------------------------------------
% Returns the ABCD matrix for propagation througe a spherical 
% dielectric interface.
%
% SYNTAX: abcd=sdie(R,n1,n2);
%
% R  = Interface radius of curvature. R is positive when the
%      the interface curves toward the direction from which 
%      the beam comes, negative otherwise.
% n1 = index of refraction of material being left
% n2 = index of refraction of material being entered
%
% abcd = |       1            0   |
%        | -(n1-n2)/n2/R     n1/n2 |
%
%----------------------------------------------------------------
% SYNTAX: abcd=sdie(R,n1,n2);
%----------------------------------------------------------------

function abcd=sdie(R,n1,n2)

abcd=[
    1               0
    -(n1-n2)/n2/R    n1/n2
];