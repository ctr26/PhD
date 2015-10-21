%% Creates a variabloe grating for tests with diffraction.

width = 1000;
height = 1000;
array = zeros(width,height);

init = zeros(10,width);

tiled_x = 10;
tiled_y = 10;

for x = 1:tiled_x
    for y = 1:tiled_y
        
        image_width = width/tiled_x;
        image_height = height/tiled_y;
            for x_small = 1:image_width;
                for y_small = 1:image_height;
                    num = floor(x_small/x);
                    even_odd = mod(num,2);                 
                        array((x-1)*(width/tiled_x)+x_small,(y-1)*(height/tiled_y)+y_small) = even_odd;
                        image(x_small,y_small) = even_odd;
                        %init = [init image];
                end
            end
        
    end
end

imagesc(array)

