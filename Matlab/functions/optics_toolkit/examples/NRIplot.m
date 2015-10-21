% Illustrates the use of NewtonsRingsI by plotting Newton's rings

thetaoffset=20*pi/180;
    
rseed=[0:0.001:sqrt(0.1)].^2;
thetaseed=[0:1:360]*pi/180;

[theta,r]=meshgrid(thetaseed,rseed);

[x,y]=pol2cart(theta,r);

subplot(111);

h=pcolor(x,y,NewtonRingsI([0.01,100,14e3,-.1e3,1,1,1.024e-6,thetaoffset],r)); hold on
%h_contours=contour(x,y,sqrt(x.^2+y.^2),[0.02,0.02],'r');
colormap('bone');
set(h,'EdgeColor','none');
set(h,'FaceColor','interp');
set(gca,'Visible','off');
set(gcf,'Color','black');
%figtext(4.3,-0.7,['(',num2str(p),',',num2str(m),')'],8);
axis square
hold off
shg;
