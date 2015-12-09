clf
clear all
close all

A = 0.015;     %%increase to tax all
B = 0.0000;    %%increase to tax poor

A = 0.1;     %%increase to tax all
B = 0.01;    %%increase to tax poor



x = 1:150
for x = 1:150
    salary(x) = x
    ttax(x) = A * (exp( B * salary(x)) - 1);
    wage(x) = salary(x) * (1-ttax(x));
    
    income(x) = salary(x) - wage(x);
    if x == 1
        welness (1) = 0
    else
        
    wellness(x) = wage(x) - wage(x-1);
    end
    
    
    
end

figure(1)
 plot(wellness)
 figure(2)
plot(ttax)
xlabel('Salary / 1000s')
   ylabel('Tax')
   title('Tax versus Salary, Early Draft')
   
   
   
%  figure(3)
%  xlabel('Salary / 1000s')
%  ylabel('Tax')
%  hold on
%   xlabel('Salary / 1000s')
%   ylabel('Wages')
%  plot(wage)
%  plot(salary)
% hold off



