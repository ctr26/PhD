function u1=vortex_plate_prop(lam,npoints,range,u0,zdist,l)
%u1=vortex_plate_prop(lambda, u0,zdist,l)
%u0: initial wave
%zdist: distance to propagate after vortex plate;
%l: vortex topological charge

lambda=lam*1e-6; %mms;
k=2*pi/lambda;

distance=zdist;


step=range/npoints;


scale=-range/2:step:range/2-step;
ftscale=(npoints/range^2)*scale;
xvec=scale;
yvec=xvec;


[fx,fy]=meshgrid(ftscale,ftscale);
[xi,yj]=meshgrid(xvec,yvec);


phi=atan2(yj,xi)+pi;

mt=exp(1i*l.*phi);


mt1=mt.*u0;
ind=isnan(mt1);
mt1(ind)=0;

dt=fftshift(fft2(mt1));

ff=h2(fx,fy,distance,lambda);

ft=ff.*dt;

u1=ifft2(fftshift(ft));

% colormap('gray')
% result=abs(u1).^2;
% %imagesc(scale,scale,mod(angle(mt),2*pi),[0 2*pi])
% imagesc(scale,scale,result);
% axis([min(scale)/2.4 max(scale)/2.4 min(scale)/2.4 max(scale)/2.4]);
% 
% string=['d = ' num2str(zdist, '%6.0f') ];
% %string=['g = ' num2str(g,'%1.2f')];
% %text(-1.1,-1.1,string,'Color',[1,1,1]);
% axis('square');

end