% Illustrates the use fo LaguerreGaussianE.m, decompose.m and recompose.m by
% defining an off-center Guassian beam (Fig. 1, Col. 1) and recomposing it 
% in a basis of Laguerre Gaussians defined about the center on the figure.
% The recomposed beam is shown in Fig. 1, Col. 2, where we have used the
% first 40 Laguerre Gaussian modes.  Figure 1, Col. 3 shows the
% difference between the recomposed beam and the original.  Figure 2 shows
% the magnitude of the coefficients of the various modes in the
% decomposition.


ploton=[1 1];
overlaponly=0; showfigure=0;

clear domain;

screensize=0.1;
nptsr=50;
nptstheta=100;
accuracy=0.001;
n=400;

[rmesh,thetamesh,xmesh,ymesh]=polarmesh([0,screensize,nptsr],[0 2*pi nptstheta],'lin');
domain(:,:,1)=rmesh; domain(:,:,2)=thetamesh;

w=0.02;
R=-1e3;
lambda=1.064e-6;
q=q_(w,R,lambda);

deltax=1.5*w;
deltay=1.5*w;
wfactor=1;

if overlaponly
    z1=LaguerreGaussianE([0,2,q_(w,R,lambda),lambda],xmesh,ymesh,'cart');
    z2=LaguerreGaussianE([0,2,q_(w,R,lambda),lambda],xmesh,ymesh,'cart');
    a=overlap(z1,conj(z2),domain,rmesh)
    if showfigure
        figure(1);
        subplot(221); h=pcolor(xmesh,ymesh,abs(z1).^2); shg; colorbar; axis square; set(h,'edgecolor','none');
        subplot(222); h=pcolor(xmesh,ymesh,abs(z2).^2); shg; colorbar; axis square; set(h,'edgecolor','none');
        subplot(223); h=pcolor(xmesh,ymesh,angle(z1)); shg; colorbar; axis square; set(h,'edgecolor','none');
        subplot(224); h=pcolor(xmesh,ymesh,angle(z2)); shg; colorbar; axis square; set(h,'edgecolor','none');
    end
    return
end

zin=LaguerreGaussianE([0,0,q_(w*wfactor,R,lambda),lambda],xmesh+deltax,ymesh+deltay,'cart');
[coeffs,tmat]=decompose(zin,domain,'lg',n,[q,lambda,accuracy]);
disp(' '); disp('horizontal');
dispmat(abs(coeffs(:,:,1)));
disp(' '); disp('vertical')
dispmat(abs(coeffs(:,:,2)));
zout=recompose(domain,'lg',coeffs,[q,lambda],accuracy);


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
    title('recomposed');
    subplot(339);
    h=pcolor(xmesh,ymesh,imag(zout)-imag(zin)); set(h,'edgecolor','none'); axis square; colorbar; drawnow; shg;
    title('difference');
end

if length(ploton)>=2 & ploton(2)==1
    figure(2);
    coeffplotmat=[coeffs(:,end:-1:2,2),coeffs(:,:,1)];
    ps=[-size(coeffs(:,:,2),1)+1:size(coeffs(:,:,1),1)-1];
    ms=[0:size(coeffs(:,:,2))-1];
    [psmesh,msmesh]=meshgrid(ps,ms);
    h=pcolor(psmesh,msmesh,log10(abs(coeffplotmat))); axis square; colorbar; drawnow; shg;
    title('Log_{10} of coefficients of the modes in the decomposition');
    xlabel('m'); ylabel('p');
 end