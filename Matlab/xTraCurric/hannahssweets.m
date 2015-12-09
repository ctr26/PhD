clear all

for n = 1:100
    for o = 1:100

        a = sqrt(o / n * (o-1) / (n-1));

        answer(n,o) = o * 1/a;
        diff(n,o) = n - answer(n,o);
        percent(n,o)= n*100/diff(n,o) ;
        final(n,o) = round(answer(n,o));
        n_table(n,o) = n;
        
            if (final(n,o) == not(n))
                table(n,o) = 1;
            else
                table(n,o) = 0;
            end 
           
    end
end



proof = final - n_table; 
imagesc(proof)

xlabel('Orange Sweets')
ylabel('Number of Sweets')