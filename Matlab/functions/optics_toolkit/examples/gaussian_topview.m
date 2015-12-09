% Illustrates the use of SimpleGaussian.m by plotting interesting features
% of a TEM_00 Hermite Gaussian beam. In Figure 1, the script plots
% the amplitude and phase of a TEM_00 beam near the focus. The amplitude
% of the two quadratures amplitude*sin(phase) and amplitude*cos(phase) are 
% shown in a Figure 2.

z=[-0.2:0.003:0.2];
r=[-1e-3:6e-6:1e-3];
lambda=1e-6;
w01=100e-6;
w02=200e-6;

dr=5e-5;

[E1,w1,R1,phi1,zr]=SimpleGaussian([w01,lambda],z,r);
theta1=angle(E1);
I1=E1.*conj(E1);
Inorm1=I1;
zpts=size(I1,1);
rpts=size(I1,2);
for s=1:zpts
    Inorm1(s,:)=I1(s,:)./max(I1(s,:));%I1(s,pos(r,0,1));
end

figure(1);
subplot(121);
h1=pcolor(r,z,sqrt(Inorm1)); set(h1,'EdgeColor','none'); hold on;
caxis([0 1]);
sidebar=colorbar;
contour(r,z,sqrt(Inorm1),1,'w','linewidth',2);
title('amplitude');
hold off;
subplot(122);
h2=pcolor(r,z,theta1); set(h2,'EdgeColor','none'); hold on;
title('phase (and 1/e envelope)');
caxis([-pi pi]);
sidebar=colorbar('ytick',[-2*pi,-3*pi/2,-pi,-pi/2,0,pi/2,pi,3*pi/2,2*pi],...
    'yticklabel',{'-2pi','-3pi/2','-pi','-pi/2','0','pi/2','pi','3pi/2','2pi'});
contour(r,z,sqrt(Inorm1),1,'w','linewidth',2);
hold off;

figure(2);
subplot(121);
h1=pcolor(r,z,Inorm1.*cos(theta1)); set(h1,'EdgeColor','none'); hold on;
sidebar=colorbar;
contour(r,z,sqrt(Inorm1),1,'w','linewidth',1);
caxis([-1.0 1.0]);
title('I phase and 1/e amplitude envelope');
hold off;
subplot(122);
h2=pcolor(r,z,Inorm1.*sin(theta1)); set(h2,'EdgeColor','none'); hold on;
sidebar=colorbar;
contour(r,z,sqrt(Inorm1),1,'w','linewidth',1);
caxis([-1.0 1.0]);
title('Q phase and 1/e amplitude envelope');
hold off;
