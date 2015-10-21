%% Build binary particle

particle = 1*10^-6;

FOV_X = 500 * 10^-6;
FOV_Y = 500 * 10^-6;
FOV_Z = 100 * 10^-6;

camera_px = 100;
z_slices = 100;
mag = 25;

z_step = FOV_Z / 100;
x_step = FOV_X  / camera_px;
y_step = FOV_Y  / camera_px;

particle1_map = zeros(camera_px,camera_px,z_slices);


total = z_slices * camera_px * camera_px;
counter = 0;
h = waitbar(0,'Initializing waitbar...');

for k = 1:z_slices
    for j = 1:camera_px
        for i = 1:camera_px
           
            counter = counter + 1;
            percent = (counter/total) * 100;
            waitbar(counter/total,h,'Chugging...')
            
            x = (i - camera_px/2)*x_step;
            y = (j - camera_px/2)*y_step;
            z = (k - z_slices/2)*z_step;            
            
            r = sqrt(x^2 + y^2 + z^2);
            
            if (r < particle)
                
            particle1_map(i,j,k) =  1;
            
            
               
            end
            
        end
    end
end


%  k = 50
% j = 1022
%  i = 1022
%            
%             x = (i - camera_px/2)*x_step;
%             y = (j - camera_px/2)*y_step;
%             z = (k - z_slices/2)*z_step;            
%             
%             r = sqrt(x^2 + y^2 + z^2);
%             
%             
%              if (r < particle)
%                
%             particle1_map(i,j,k) =  1;
%                
%             end


