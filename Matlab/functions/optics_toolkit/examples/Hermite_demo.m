% Illustrates the use fo HermiteGaussianE.m, decompose.m and recompose.m by
% defining an off-center Guassian beam (Fig. 1, Col. 1) and recomposing it 
% in a basis of Hermite Gaussians defined about the center on the figure.
% The recomposed beam is shown in Fig. 1, Col. 2, where we have used the
% first 40 Hermite Gaussian (TEM_mn) modes.  Figure 1, Col. 3 shows the
% difference between the recomposed beam and the original.  Figure 2 shows
% the magnitude of the coefficients of the TEM_(l,m) mode in the
% decomposition.

clear domain;
screensize=0.1;
npts=75;
x=[-screensize:2*screensize/(npts-1):screensize];
y=x;
w=0.022;
R=-1e3;
deltax=1/sqrt(2)*w;
deltay=0*w;
wfactor=1;
lambda=1.064e-6;
ploton=[1,1];
n=40;

[xmesh,ymesh]=meshgrid(x,y);
domain(:,:,1)=xmesh; domain(:,:,2)=ymesh;
q=q_(w,R,lambda);
%zin=exp(-(xmesh.^2+ymesh.^2)/2/q);
zin=HermiteGaussianE([0,0,q_(w*wfactor,R,lambda),lambda],xmesh+deltax,ymesh+deltay);
[coeffs,tmat]=decompose(zin,domain,'hg',n,[q,lambda,1e-6]);
disp(' ');
dispmat(abs(coeffs));
zout=recompose(domain,'hg',coeffs,[q,lambda]);

if ploton(1)==1
    figure(1);
    subplot(331);
    h=pcolor(xmesh,ymesh,abs(zin).^2); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('original intensity');
    subplot(332);
    h=pcolor(xmesh,ymesh,abs(zout).^2); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('recomposed');
    subplot(333);
    h=pcolor(xmesh,ymesh,abs(zout).^2-abs(zin).^2); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('difference');
    subplot(334);
    h=pcolor(xmesh,ymesh,real(zin)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('original real part');
    subplot(335);
    h=pcolor(xmesh,ymesh,real(zout)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('recomposed');
    subplot(336);
    h=pcolor(xmesh,ymesh,real(zout)-real(zin)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('difference');
    subplot(337);
    h=pcolor(xmesh,ymesh,imag(zin)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('original imaginary part')
    subplot(338);
    h=pcolor(xmesh,ymesh,imag(zout)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('recomposed')
    subplot(339);
    h=pcolor(xmesh,ymesh,imag(zout)-imag(zin)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('difference');
end

if length(ploton)>=2 & ploton(2)==1
    figure(2);
    ls=[0:size(coeffs,1)-1];
    ms=[0:size(coeffs,2)-1];
    h=pcolor(ls,ms,log10(abs(coeffs.'))); axis square; colorbar; drawnow; shg;
    title('Log_{10} of coefficients of the modes in the decomposition');
    xlabel('l');
    ylabel('m');
end