%--------------------------------------------------------------------
% Propagates a Gaussian beam with complex radius of curvature q1
% using the ABCD matrix supplied. Returns the new q and the 
% new amplitude factor p = 1/(A+B/q1)^(1+l+m) by which the field is
% multiplied. (See eqn 4.7.30 in Principles of Lasers by O. Svelto.)
% If q1 is a vector q and p will be vectors of the same size.
%
% For a Hermite Gaussian l,m are the mode designators.
% For a Laguerre Gaussian l=2p and m is the usual m.
%
% SYNTAX: [q,p]=prop(q1,abcd <,[l,m]>);
%           <...> indicates optional arguments
%--------------------------------------------------------------------

function [q,p]=prop(q1,abcd,varargin)

if nargin>=3, mode=varargin{1}; else mode=[0,0]; end

A=abcd(1,1);
B=abcd(1,2);
C=abcd(2,1);
D=abcd(2,2);

l=mode(1);
m=mode(2);

q = (A*q1 + B)./(C*q1 + D);
p = 1./(A+B./q1).^(1+l+m);