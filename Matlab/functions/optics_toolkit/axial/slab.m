%----------------------------------------------------------------
% Returns the ABCD matrix for propagation through a flat
% dielectric interface.
%
% SYNTAX: abcd=fdie(n1,n2);
%
% n1 = index of refraction of material being left
% n2 = index of refraction of material being entered
%
% abcd = | 1       0  |
%        | 0    n1/n2 |
%
%----------------------------------------------------------------
% SYNTAX: abcd=fdie(n1,n2);
%----------------------------------------------------------------

function abcd=slab(n1,n2)

abcd=[
    1     0
    0   n1/n2
];