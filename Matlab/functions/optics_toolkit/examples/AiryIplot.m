% Illustrates the use of AiryI.m
% Plots field intensity of a TEM00 mode after clipping at an aperture.  16 beam cross 
% sections are calculated starting in the near field ending in the far field 
% (takes some time to run).

lambda=10.6e-6;
a=0.005;
F=0.2
w0=a/sqrt(pi*F);

rmax=a;
nradialpts=50;
nthetapts=36;

for n=1:16
    L=n*25*a;
    %thetaoffset=20*pi/180;

    rseed=[0:rmax/nradialpts:sqrt(rmax)].^2;
    thetaseed=[0:360/nthetapts:360]*pi/180;

    [theta,r]=meshgrid(thetaseed,rseed);

    [x,y]=pol2cart(theta,r);

    subplot(4,4,n);
    
    z=AiryI([a,w0,L,lambda,4],r);
    h=pcolor(x,y,z); hold on
    %h_contours=contour(x,y,sqrt(x.^2+y.^2),[0.02,0.02],'r');
    colormap(bone);
    set(h,'EdgeColor','none');
    set(h,'FaceColor','interp');
    set(gca,'Visible','off');
    set(gcf,'Color','black');
    axis square
    set(gca,'XLim',[-rmax rmax]);
    set(gca,'YLim',[-rmax rmax]);
    %set(gca,'ZLim',[0 2.5]);
    hold off
    drawnow;
end
shg;