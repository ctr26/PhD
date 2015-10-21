clear all
close all
x = zeros(2,2);
y = zeros(2,2);
a = zeros(2);

y(1,1) = 0.5; x(1,1) = 0.5;
y(1,2) = 2.5; x(1,2) = -1;
y(2,1) = 0.5; x(2,1) = 2.5;
y(2,2) = 3; x(2,2) =3.5;

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
samples = 10000;
[inx iny] = meshgrid(0:1/samples:1);%,0:1/samples:1);

% 
% for i = 1:size(inx,1)
%     for j = 1:size(iny,1)
%         
% 
%         
%     temp= C*[inx(i,j),iny(i,j),1]';
% 
%     outx(i,j) = temp(1)./temp(3);
%     outy(i,j) = temp(2)./temp(3);
% 
%     end
% end


        %outx = C(1,1)*inx+C(2,1)
        
        
        outx = (C(1,1)*inx+C(1,2)*iny+C(1,3))./(C(3,1).*inx+C(3,2).*iny+C(3,3));
        outy = (C(2,1).*inx+C(2,2).*iny+C(2,3))./(C(3,1).*inx+C(3,2).*iny+C(3,3));
        %outzII =(C(3,1).*inx+C(3,2).*iny+C(3,3));
        
%         samples = 200;
% [inx iny] = meshgrid(0:1/samples:1);
%         
%         [outx outy] = interp2(outx,outy,V,Xq,Yq)
        
        

%outxII(i,j)
%outzII(i,j)
%%
 outx = outx(:);
 outy = outy(:);
 
 scatter(outx,outy,'.');
 hold on

 box_x = [x00,x01,x11,x10];
 box_y = [y00,y01,y11,y10];
 plot(box_x,box_y,'LineWidth',4);
 
hold off
