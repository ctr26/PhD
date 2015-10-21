% Illustrates the use of LaguerreGaussianE.m by plotting the 
% first 16 Laguerre-Gaussian modes (p,m)=([0:3],[0:3]).

pnumbers=[0:3];
mnumbers=[0:3];
pmax=max(pnumbers);
mmax=max(mnumbers);

w=1;

n=0.5;

for p=0:3
for m=0:3
    
rseed=[0:0.03:sqrt(n*w)].^2;
thetaseed=[0:1:360]*pi/180;

[theta,r]=meshgrid(thetaseed,rseed);

[x,y]=pol2cart(theta,r);

subplot(pmax+1,mmax+1,p*(mmax+1)+m+1)
h=pcolor(x,y,abs(LaguerreGaussianE([p,m,q_(w,100),1e-6],r,theta,'pol')+LaguerreGaussianE([p,-m,q_(w,100),1e-6],r,theta,'pol')).^2);
colormap('bone')
set(h,'EdgeColor','none');
set(h,'FaceColor','interp');
set(gca,'Visible','off');
set(gcf,'Color','black');
%figtext(4.3,-0.7,['(',num2str(p),',',num2str(m),')'],8);
axis square
hold off
shg;

end
end