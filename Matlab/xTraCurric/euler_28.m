%1,3,7,13,21
%1,5,9,17,25,37,49
sum = 0
for n = 1:1001;

first = n.^2 - n +1

if mod(n,2) == 0    
    second  = n.^2 + 1    
else
    second = n.^2;
end

    sum = +sum + first + second;

end

sum = sum - 1;
