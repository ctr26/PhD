% Vector form of factorial.
% For some reason the function "factorial" can't act on vectors.
% 6/24/03

function y=fact(x);

y=[];
for s=1:length(x)
    y(s)=factorial(x(s));
end