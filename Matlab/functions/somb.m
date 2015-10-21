function z=somb(x)
%SOMB 2*j1(pi*x)/(pi*x) function.
%   SOMB(X) returns a matrix whose elements are the somb of the elements 
%   of X, i.e.
%        y = 2*j1(pi*x)/(pi*x)    if x ~= 0
%          = 1                    if x == 0
%   where x is an element of the input matrix and y is the resultant
%   output element.  

%   Author(s): J. Loomis, 6-29-1999

z=ones(size(x));
i=find(x);
z(i)=2.0*besselj(1,pi*x(i))./(pi*x(i));