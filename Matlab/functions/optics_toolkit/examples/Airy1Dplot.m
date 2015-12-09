% Illustrates the use of AiryI.m
% Plots the field intensity of a TEM00 mode gaussian after passing through an aperture 
% of width a.

lambda=10.6e-6;
a=0.005;
F=0.2;
w0=a/sqrt(pi*F);
figure
rmax=2*a;
nradialpts=300;
r=[0:rmax/nradialpts:sqrt(rmax)].^2;
for n=1:16
    L=n*25*a;
    subplot(4,4,n);
    z=AiryI([a,w0,L,lambda,2],r);
    plot([-reverse(r),r],[reverse(z),z],'w');
    set(gca,'Visible','off');
    set(gcf,'Color','black');
    %axis([-1.1*rmax 1.1*rmax 0 2.5]);
    pause(0.1);
end
shg;