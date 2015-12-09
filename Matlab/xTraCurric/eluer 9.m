
month(1) = 31
month(2) = 28
month(3) = 31
month(4) = 30
month(5) = 31
month(6) = 30
month(7) = 31
month(8) = 31
month(9) = 30
month(10) = 31
month(11) = 30
month(12) = 31

weekday_count = 3; %Tuesday start
sunday_counter = 0;

for year = 1901:2000
    
for month_count = 1:12
    if  month_count == 2
        
        if mod(year,4) == 0 && mod(year,100) ~= 0
           month(2) = 29;
        elseif  mod(year,4) == 0 && mod(year,100) == 0 && mod(year,400) == 0
           month(2) = 29;                 
        else
            month(2) = 28;
        end
    
    end
    for day = 1:month(month_count)

             
        if (mod(weekday_count,7) == 0) && day == 1
            
            sunday_counter = sunday_counter + 1;
            
        end
        
        weekday_count = weekday_count + 1;
                
    end
    
end

end