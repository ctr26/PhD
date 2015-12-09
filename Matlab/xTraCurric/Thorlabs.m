dir = 'C:\Users\Craig\Desktop\';
file =  'cart.xls';
[num txt raw] = xlsread([dir file]);
[length temp] = size(raw);


%subtotal column 6

j = 1;
sum = 0;
l = 1;
for i = 1:length-1
    
    sum = sum + cell2mat(raw((i+1),6));
    
    if (sum >= 1000)
        new_array {2,j} = sum - cell2mat(raw((i+1),6));
        j = j+1;
        l = 1;
        sum = cell2mat(raw((i+1),6))        
    end
    
    new_array{1,j}(l,1) = raw((i+1),1);
    new_array{1,j}(l,2) = raw((i+1),4);
    
    l = l + 1;
        
end

new_array{2,j} = sum;

[a b] = size(new_array);

for k = 1 : b

    dlmcell([dir 'cart_' num2str(k) ' £' num2str(floor(new_array{2,k})) '.txt'],new_array{1,k})
    
    sum  =new_array{2,k} + sum;
    
end

    




