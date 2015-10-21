function out = Airy(lambda,NA,FOV)

%FOV = 1000*10^-6; %m
width = 1000; 
height = 1000;
pixel_size = FOV /width;

res = (lambda /  (pixel_size*3.81* 2*NA));

for x = 1:width
    for y = 1:height
        
        r = sqrt(((x-(width/2))/res)^2 + ((y-(height/2))/res)^2);
        out(x,y) = (besselj(1,r)/r)^2;
        
    end
end

end