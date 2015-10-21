clear all
close all
x = zeros(2,2);
y = zeros(2,2);
a = zeros(2);

y(1,1) = 0.1; x(1,1) = 0;
y(1,2) = 1; x(1,2) = 0;
y(2,1) = 0; x(2,1) = 1;
y(2,2) = 2; x(2,2) =1;

y00 = y(1,1);   x00 = x(1,1);
y01 = y(1,2);   x01 = x(1,2);
y10 = y(2,1);   x10 = x(2,1);
y11 = y(2,2);   x11 = x(2,2);

a = x11 - x00;  A = y11 - y00;
b = x10 - x00;  B = y10 - y00;
c = x01 - x00;  C = y01 - y00;

ScaleSource = inv([0,0,1;0,1,0;1,1,1])*[1;1;1];
ScaleImage = inv([x00,x01,x10;y00,y01,y10;1,1,1])*[x11;y11;1];

%repmat(ScaleImage',3,1)

A = [0,0,1;0,1,0;1,1,1].*repmat(ScaleSource',3,1);
%A = [x00,x01,x10;y00,y10,y01;0.5,0.5,0.5].*repmat(ScaleImage',3,1);
B = [x00,x01,x10;y00,y01,y10;1,1,1].*repmat(ScaleImage',3,1);

C = B*inv(A);

[inx iny] = meshgrid(0:0.02:1);

for i = 1:50
    for j = 1:50
        
    temp= C*[inx(i,j),iny(i,j),1]';

    outx(i,j) = temp(1)./temp(3);
    outy(i,j) = temp(2)./temp(3);

    end
end
%%
 outx = outx(:);
 outy = outy(:);
 
 scatter(outx,outy,'.');
 hold on

 box_x = [x00,x01,x11,x10]
 box_y = [y00,y01,y11,y10]
 plot(box_x,box_y,'LineWidth',4);
 
hold off
