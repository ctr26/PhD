function u1=axicon_prop(lam, npoints,range,u0,zdist,gamma)
%u1= axicon_prop(lambda, u0, zdist,gamma)
%u0 is wave when it reaches axicon
%zdist is distance in mm after axicon
%gamma is opening angle in degrees


%set up code
n=1.46; %fused silica substrate;
lambda=lam*1e-6; %mms;
k=2*pi/lambda; 
a=pi*gamma/(180); %angle in rad
g= k*(n-1)*tan(a); 


w=1.3;
z_max=w/((n-1)*a);
r_c=2.405*sqrt(1+a^2)/(a*k);




step=range/npoints;
distance=zdist;

scale=-range/2:step:range/2-step;
ftscale=(npoints/range^2)*scale;
xvec=scale;
yvec=xvec;


[fx,fy]=meshgrid(ftscale,ftscale);



mt=zeros(npoints,npoints);


[xi,yj]=meshgrid(scale,scale);
phi_r=g*sqrt(xi.^2+yj.^2);
mt=exp(1i.*phi_r);
% 
% for i=1:npoints
%     xi=xvec(i);
%     for j=1:npoints
%         yj=yvec(j);
%         phi_r=g*sqrt(xi^2+yj^2);
%         mt(i,j)=exp(1i*phi_r);
%     end
% end

mt1=mt.*u0;
ind=isnan(mt1);
mt1(ind)=0;

dt=fftshift(fft2(mt1));

ff=h2(fx,fy,distance,lambda);

ft=ff.*dt;

u1=ifft2(fftshift(ft));
% 
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
