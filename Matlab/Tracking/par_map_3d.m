%Guassian Model
mu = 20; %px

width = 512;
height = 512;
depth = 100;

for x = 1:width
    for y = 1:height
        for z = 1:depth
            
            r = sqrt((x-width/2)^2 + ((y-height/2)^2) + ((z-depth/2)^2) );            
            map(x,y,z) = exp( - (r^2 / (2 * ((mu/abs(z-depth/2)))^2)));            
            
        end
    end
end
