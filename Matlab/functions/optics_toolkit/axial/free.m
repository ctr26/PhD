%---------------------------------------------------------------
% Returns the ABCD matrix for free space propagation.
%
% SYNTAX: abcd=free(L <,n>);
%            <...> indicates optional argument
%
% L = distance to propagate.
% n = index of refraction. Default is 1.
%
% abcd = |1   L/n|
%        |0    1 |
%
%---------------------------------------------------------------
% SYNTAX: abcd=free(L <,n>);
%---------------------------------------------------------------

function abcd=free(L,varargin)

if nargin>=2, n=varargin{1}; else n=1; end

abcd=[
    1   L/n
    0   1
];
