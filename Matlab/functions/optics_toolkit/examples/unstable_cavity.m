% Illustrates the use of cav.m by modeling a marginally stable optical cavity.
%------------------------------------------------------------------------------------
% PROGRAM NAME: unstable_cavity
% AUTHOR: Andri M. Gretarsson
% DATE: Aug. 24, 2004
%
% SYNTAX:  unstable_cavity
% 
% Uses cav.m to model the fields inside and outside a marginally unstable linear cavity 
% The example is based on the LIGO Livingston recycling cavity in its cold state.
% In the 1D mode, the output is a set of 9 graphs showing the 
% the field inside the cavity and in reflection as a function of length around a resonance. 
% Due to the marginally stable nature of the cavity in this example, we get interesing 
% structure in the fields. The program runs as a script rather than a function and 
% numerous parameters can be set near the beginning of the script.  These are: 
%
% R1, R2 - the radii of curvature of the input and end cavity mirrors
% r1, r2 - the amplitude reflection coefficients of the two mirrors
% l1, l2 - the amplitude loss coefficients of the two mirrors
% L0 - the cavity length
% lambda - the optical wavelength
% l_in, m_in - Hermite-Gaussian mode numbers for the input light (referred to 
%              the basis set by qin (see next line).
% qin - the complex radius of curvature of the input light
% npts - for a 1D calculation, the number of points in the calculation, for a 2D
%        calculation the number of grid points is npts^2
% twoD - Whether the calculation should be done in 1D (cross section) or 2D. The 2D
%        form is significantly slower.  To improve running speeds it may be a good
%        idea to reduce npts.  NOTE: It will help to maximize the figure window and 
%        rerun the program to improve visibility in the 1D mode.
%
% INPUT ARGUMENTS: none
% OUTPUT ARGUMENTS: none
% Last Updated: June 30, 2007 by AMG
%
%------------------------------------------------------------------------------------
% SYNTAX:  unstable_cavity
%------------------------------------------------------------------------------------

% Mirror properties
Ritmx=-14.76e3;             % ITMx radius of curvature [meters]
Ritmy=-14.52e3;             % ITMy radius of curvature [meters]
Rrm=20.78e3;                % RM radius of curvature [meters]
R1=Rrm;             
R2=(Ritmx+Ritmy)/2/1.45;    % 1.45 is due to the index of refraction
r1=sqrt(0.9725);            % Measured reflectance coefficients assuming 150ppm loss in ITMs.
r2=sqrt(0.9731);            % see: http://www.ligo-la.caltech.edu/ilog/pub/ilog.cgi?group=detector&date_to_view=08/19/2003&anchor_to_scroll_to=2003:08:25:10:47:28-rana
%r1=sqrt(1-0.027);          % nominal from COC (Helena Armandula) webpage
%r2=sqrt(1-0.0288);
%r1=0.96;                    % test
l1=0;%sqrt(150e-6);            % ITM loss (nominal)
l2=0;%sqrt(150e-6);            % ITM loss (nominal)
L0=9.2;

% Incident light
lambda=1.064e-6;
l_in=0;
m_in=0;
[qin,pin]=prop(q_(0.03875,7.1e3,lambda),free(L0),[l_in,m_in]); % Input beam is matched to arms so use arm cavity beam at ITMx to get q value.
%[qin,pin]=prop(q_(0.03685,-6.9564e3,lambda),free(L0),[l_in,m_in]);
win=w_(qin,lambda);

% Plot domain
twoD=1;
if twoD
    npts=9; 
    xseed=[-2*win:win/npts:2*win];    
    yseed=xseed';
    [x,y]=meshgrid(xseed,yseed);    
    thecolormap='bone';
else 
    npts=200; 
    xseed=[-2.5*win:win/npts:2.5*win];
    x=xseed;
    y=zeros(size(x));    
end


zin=HermiteGaussianE([l_in,m_in,qin,lambda(1),pin],x,y);


n_bounces=70;
n_lengths=9;
lowerdL=-15e-9; upperdL=15e-9;
deltaL=[lowerdL:(upperdL-lowerdL)/(n_lengths-1):upperdL];
Pcoherent_out=zeros(n_lengths,1);
for s=1:n_lengths
    L=round(L0/lambda)*lambda+deltaL(s);  % Cavity length

    [qrefl,qtrans,qcav,prefl,ptrans,pcav]=...
        cav(qin,l_in,m_in,lambda,L,R1,R2,r1,r2,l1,l2,n_bounces,[1.46,1,1,],[0,0]);
    
    zrefl=HermiteGaussianE([l_in * ones(size(qrefl)),m_in * ones(size(qrefl)),...
            qrefl,lambda(1) * ones(size(qrefl)),prefl],x,y);
    zcav=HermiteGaussianE([l_in * ones(size(qcav)),m_in * ones(size(qcav)),...
            qcav,lambda(1) * ones(size(qcav)),pcav],x,y);
    ztrans=HermiteGaussianE([l_in * ones(size(qtrans)),m_in * ones(size(qtrans)),...
            qtrans,lambda(1) * ones(size(qtrans)),ptrans],x,y);    
    if length(size(zcav))==3
        zsumrefl=sum(zrefl,3);
        zsumcav=sum(zcav,3);
        zsumtrans=sum(ztrans,3);        
    else
        zsumrefl=sum(zrefl,2);
        zsumcav=sum(zcav,2);
        zsumtrans=sum(ztrans,2);
    end
    
    if ~twoD
        interpdom=[min(xseed):(max(xseed)-min(xseed))/999:max(xseed)];
        dx_interp=interpdom(2)-interpdom(1);
        if s==1
            inputintens_interp=interp1(x,abs(zin).^2,interpdom,'spline');
            inputpower=sum(inputintens_interp*dx_interp.*abs(interpdom)*pi);
        end
        cavintens_interp=interp1(x,abs(zsumcav).^2,interpdom,'spline');
        cavpower=sum(cavintens_interp*dx_interp.*abs(interpdom)*pi);
        reflintens_interp=interp1(x,abs(zsumrefl).^2,interpdom,'spline');
        reflpower=sum(reflintens_interp*dx_interp.*abs(interpdom)*pi);
        transintens_interp=interp1(x,abs(zsumtrans).^2,interpdom,'spline');
        transpower=sum(transintens_interp*dx_interp.*abs(interpdom)*pi);
        Pcoherent_out(s)=reflpower+transpower;
    end

    if twoD
        figure(1);
        subplot(3,3,s); h=pcolor(x,y,abs(zsumcav));  % h=pcolor(x,y,abs(zsumcav).*cos(angle(zsumcav)));
        set(h,'EdgeColor','none'); axis square;
        colormap(thecolormap); %colorbar;  
        set(h,'EdgeColor','none'); set(h,'FaceColor','interp');
        set(gca,'Visible','off'); set(gcf,'Color','black');        
        set(gca,'Zlim',[-35 35]);
        drawnow; 
        h=figtext3D(3,1,10,['\Delta{L}: ',num2str(deltaL(s)*1e9,'%0.3g'),' nm'],10);
        set(h,'color','white');
        shg;
    else    
        figure(1); subplot(3,3,s);  
        set(gcf,'Color','default');
        plot(x*100,zin.*conj(zin),'m--','linewidth',2); hold on;
        h=plot(x*100,zsumrefl.*conj(zsumrefl),'-',x*100,zsumcav.*conj(zsumcav),'-');
        set(h,'linewidth',2);
        legend('input','refl','cav');
        drawnow; hold off;     
        xlabel('cm'); ylabel('intensity');
        figtext(0.5,9,['\Delta{L}: ',num2str(deltaL(s)*1e9,'%0.3g'),' nm'],8);
        figtext(0.5,7.5,['P_{cav}/P_{in} = ',num2str(cavpower,'%0.2g')],8);
        shg;
    end

end