clear all
load particle.mat
FOV_image = 20; %20um
px_image = 410; %px

FOV_xy = 540;   %um
px_xy = 2048;   %px

px_z = 100;
FOV_z = 10;

scale_xy = (FOV_image / px_image) / (FOV_xy/px_xy);
scale_z = (FOV_image / px_image) / (FOV_z/px_z);


image_3D = blurry;
[x,y,z] = size(image_3D);

size_x = x * scale_xy;
size_y = y * scale_xy;
size_z = z * scale_z;


out = resize(blurry,[size_x size_y size_z]);

final = zeros(2048,2048,100);

particles = 1;
for i = 1:10op
    
        [l,m,n]=size(out);
        xpos=px_xy*(rand);ypos=px_xy*rand();zpos=px_z*rand();
        
       coordinates(i,:) = [xpos ypos zpos];
       
        final(xpos:xpos+l-1,ypos:ypos+m-1,zpos:zpos+n-1)=out;
    
end
