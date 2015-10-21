%Guassian Model
mu = 100;

for x = 1:1000
    for y = 1:1000
        for z = 1:1000
            
            r = sqrt(x^2 + y^2+z^2)
            map = exp( - (r^2 / (2 * mu^2)))            
            
        end
    end
end
