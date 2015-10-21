function out = Airy2(lambda,NA,FOV)
NA = 1.33;
lambda = 500 * 10 ^ -9;
FOV = 10 * 10 ^ -6;
%FOV = 1000*10^-6; %m
width = 1000; 
height = 1000;
pixel_size = FOV /width;

res = (lambda /  (pixel_size*3.81* 2*NA)); %Rayleigh limit

[x y] = meshgrid(-((width/2)-1)/res:1/res:((width/2))/res,-((height/2)-1)/res:1/res:((height/2))/res);
r = sqrt(x.^2 + y.^2);
out = (besselj(1,r)./r).^2;

imagesc(out)

% 
% for x_2 = 1:width
%     for y_2 = 1:height
%         test_x(x_2,y_2) = ((x_2-(width/2))/res);
%         test_x(x_2,y_2) = ((y_2-(height/2))/res);        
%         
%         r_2(x_2,y_2) = sqrt(((x_2-(width/2))/res)^2 + ((y_2-(height/2))/res)^2);
%         out_2(x_2,y_2) = (besselj(1,r_2(x_2,y_2))/r_2(x_2,y_2))^2;
%         
%     end
% end

%end