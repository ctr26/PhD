%-----------------------------------
% Hermite Polynomial
% (See e.g. Arfken section 13.1)
%
% SYNTAX y=hermitepoly(n,x)
%-----------------------------------

function y=hermitepoly(n,x)

m=[0:floor(n/2)];

a=fact(n-2*m);
b=fact(m);

y=zeros(size(x));
for s=1:length(m)
    y = y   +   factorial(n) ./ a(s) ./ b(s)  .*   (-1).^m(s)  *  (2*x).^(n-2*m(s));
end
