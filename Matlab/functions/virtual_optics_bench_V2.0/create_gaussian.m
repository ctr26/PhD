function u0=create_gaussian(lam,npoints,range,w0,z1)
%u0=create_gaussian(lambda, resolution, range, w0, z1)
%creates gaussian beam with following parameters:
%lambda: wavelength in nm
%resolution: like...2048
%range: full width of analysis box
%w0: minimum beam waist size
%z1: distance from beam waist


lambda=lam*1e-6; %mms;
k=2*pi/lambda;
b=pi*w0^2/lambda;
w=sqrt(w0^2*(1+(z1^2/b^2)));


step=range/npoints;


scale=-range/2:step:range/2-step;
ftscale=(npoints/range^2)*scale;
xvec=scale;
yvec=xvec;


[fx,fy]=meshgrid(ftscale,ftscale);





Rz=-(z1^2+b^2)/z1;


[xi,yj]=meshgrid(scale,scale);

phi=-1*k*(xi.^2+yj.^2)./(2*Rz);
mt=exp(-(xi.^2+yj.^2)./w^2).*exp(1i.*phi);
% 
% for i=1:npoints
%     xi=xvec(i);
%     for j=1:npoints
%         yj=yvec(j);
%         %phi_th=myatan(yj,xi);
%         %phi_r=g*sqrt(xi^2+yj^2);
%         phi=-1*k*(xi^2+yj^2)/(2*Rz);
%         mt(i,j)=exp(-(xi^2+yj^2)/w^2).*exp(1i*phi);
%     end
% end


ind=isnan(mt);
mt(ind)=0;

u0=mt;
% 
% colormap('gray');
% 
% imagesc(scale,scale,abs(u0).^2);
% axis([min(scale)/2.3 max(scale)/2.3 min(scale)/2.3 max(scale)/2.3]);


end