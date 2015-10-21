%----------------------------------------------------------------
% Returns the elements of the ABCD matrix supplied.
%
% SYNTAX: [A,B,C,D]=elems(abcd);
%----------------------------------------------------------------

function [A,B,C,D]=elems(abcd)

A=abcd(1,1);
B=abcd(1,2);
C=abcd(2,1);
D=abcd(2,2);