clear all
close all
x = zeros(2,2);
y = zeros(2,2);
a = zeros(2);

y(1,1) = 1.2; x(1,1) = 1;
y(1,2) = 9; x(1,2) = 1.3;
y(2,1) = 2; x(2,1) = 10;
y(2,2) = 11; x(2,2) =10;

y00 = y(1,1);   x00 = x(1,1);
y01 = y(1,2);   x01 = x(1,2);
y10 = y(2,1);   x10 = x(2,1);
y11 = y(2,2);   x11 = x(2,2);

a = x11 - x00;  A = y11 - y00;
b = x10 - x00;  B = y10 - y00;
c = x01 - x00;  C = y01 - y00;

from_y00 = 0; from_x00 = 0;
from_y01 = 100; from_x01 = 0;
from_y10 = from_y00; from_x10 = 1;
from_y11 = from_y01; from_x11 = 1;



%ScaleSource = inv([0,0,1;0,1,0;1,1,1])*[1;1;1];
ScaleSource = inv([from_x00,from_x01,from_x10;from_y00,from_y01,from_y10;1,1,1])*[from_x11;from_y11;1];
ScaleImage = inv([x00,x01,x10;y00,y01,y10;1,1,1])*[x11;y11;1];

%repmat(ScaleImage',3,1)

A = [from_x00,from_x01,from_x10;from_y00,from_y01,from_y10;1,1,1].*repmat(ScaleSource',3,1);
%A = [x00,x01,x10;y00,y10,y01;0.5,0.5,0.5].*repmat(ScaleImage',3,1);
B = [x00,x01,x10;y00,y01,y10;1,1,1].*repmat(ScaleImage',3,1);

C = B*inv(A);

samples = 50;
[inx iny] = meshgrid(linspace(from_x00,from_x11,samples),linspace(from_y00,from_y01,samples)); %Choosing an area of space based on input because thats what will be happening in reality.

for i = 1:samples
    for j = 1:samples
        
    temp= C*[inx(i,j),iny(i,j),1]';

    outx(i,j) = (temp(1)./temp(3));
    outy(i,j) = (temp(2)./temp(3));

    end
end
%%
 outx = outx(:);
 outy = outy(:);
 
 scatter(outx,outy,'.');
 hold on

 box_x = [x00,x01,x11,x10]
 box_y = [y00,y01,y11,y10]
 %plot(box_x,box_y,'LineWidth',4);
 
hold off
