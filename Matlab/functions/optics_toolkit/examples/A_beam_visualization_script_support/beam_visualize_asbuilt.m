%----------------------------------------------------------------------------------------------
% VARIABLE CONTROL 

var_mcwaist=0;          % Allow (1) or disallow (0) beam width variation at MC waist
var_rmwidth=0;          % Allow (1) or disallow (0) beam width variation insided PRM (at RM) 
var_deltaMMT2pos=1;     % Allow (1) or disallow (0) MMT2 position variation

postmc_power=3;         % Input power [Watts]
%----------------------------------------------------------------------------------------------
fontsize=0.01;          
figure(1);

for s=1:1
switch s
case 1
    wmc=0.01;               % MC waist width [inches] (only used if var_mcwaist=1)
    wrm=4.8/2.54;           % PRM beam width specified at RM [inches] (only used if var_rmwidth=1)        
    deltaMMT2pos=3.18;      % MMT2, distance from design position [inches] pos. value lengthens telescope (only used if var_deltaMMT2pos=1) 
    linestyle='-';
    linecolor='b';
case 2
    wmc=0.03;
    wrm=4.8/2.54;
    deltaMMT2pos=1.5;    
    linestyle='-';
    linecolor='r';
case 3
    wmc=0.06413;
    wrm=4.8/2.54;
    deltaMMT2pos=3.18;    
    linestyle='-';
    linecolor='g';
end

beam_propagate_llo_asbuilt;

%-----------------------------------------------------------------------------
% INPUT BEAM 
%-----------------------------------------------------------------------------
x=0; y=86; 
resolution=5000;

propdist=52-1.48;
[h,x,y]=beamplot(qMCwaist,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_smalloptic,0,x,y,0,1064e-9/0.0254,'MMT1');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=533.55;
[h,x,y]=beamplot(qMMT1FF,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_smalloptic,0,x,y,0,1064e-9/0.0254,'MMT2');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=565.99;
[h,x,y]=beamplot(qMMT2FF,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'MMT3');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=637.41;
[h,x,y]=beamplot(qMMT3FF,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'RM');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=173.13;
[h,x,y]=beamplot(qRMFF,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'BS');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=191.40;
[h,x,y]=beamplot(qBSFF,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'ITM');
set(th,'FontUnits','normalized','FontSize',fontsize);

%propdist=157284.7/10;
%[h,x,y]=beamplot(qITMXFF,[0:propdist/resolution:propdist],x,y); hold on;
%set(h,'Color',linecolor);
%set(h,'LineStyle',linestyle);
%[h,th]=lensplot(qd_largeoptic,0,x,y,0,1064e-9/0.0254,'ETM');
%set(th,'FontUnits','normalized','FontSize',fontsize);


%-----------------------------------------------------------------------------
% REFL
%-----------------------------------------------------------------------------

% REFL In vac
x=0; y=73; 
resolution=5000;

[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'RM');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=637.41;
[h,x,y]=beamplot(qRMrear,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'MMT3');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=565.99;
[h,x,y]=beamplot(qMMT3FFreturning,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_smalloptic,0,x,y,0,1064e-9/0.0254,'MMT2',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=533.55;
[h,x,y]=beamplot(qMMT2FFreturning,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_smalloptic,0,x,y,0,1064e-9/0.0254,'MMT1',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=17.21-1.48;
[h,x,y]=beamplot(qMMT1FFreturning,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_faraday,0,x,y,0,1064e-9/0.0254,'Faraday',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=60.8;
[h,x,y]=beamplot(qFaradayreturning,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'viewport',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% REFL Table, common path
propdist=43;
[h,x,y]=beamplot(qREFLviewport,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

xcommon=x; ycommon=y;

% REFL Table, 62 MHz LSC path
x=xcommon; y=ycommon;

propdist=40.25;
[h,x,y]=beamplot(qREFLL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2/25.4,0,x,y,0,1064e-9/0.0254,'60 MHz PD',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% REFL Table, 25 MHz LSC path
x=xcommon; y=ycommon-4;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=30.4;
[h,x,y]=beamplot(qREFLL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'~180 mm',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=6.5;
[h,x,y]=beamplot(qREFLL2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2/25.4,0,x,y,0,1064e-9/0.0254,'25 MHz PD',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% REFL Table, camera path
x=xcommon; y=ycommon-8;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=27;
[h,x,y]=beamplot(qREFLL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(5/25.4,0,x,y,0,1064e-9/0.0254,'Camera',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% REFL Table, WFS3 path
x=xcommon; y=ycommon-12;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=72.15;
[h,x,y]=beamplot(qREFLL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'401 mm',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=20.75;
[h,x,y]=beamplot(qREFLL3,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'-50 mm',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=4.75;
[h,x,y]=beamplot(qREFLL4,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(10/25.4,0,x,y,0,1064e-9/0.0254,'WFS3',2);
set(th,'FontUnits','normalized','FontSize',fontsize);


% REFL Table, WFS4 path
x=xcommon; y=ycommon-16;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=65.55;
[h,x,y]=beamplot(qREFLL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'~1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=37.75;
[h,x,y]=beamplot(qREFLL5,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(10/25.4,0,x,y,0,1064e-9/0.0254,'WFS4',1);
set(th,'FontUnits','normalized','FontSize',fontsize);


%-----------------------------------------------------------------------------
% AS
%-----------------------------------------------------------------------------

% AS in vac
x=0; y=59;
resolution=5000;

[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'BS');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=172.85;
[h,x,y]=beamplot(qBSRFreturning,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT1,0,x,y,0,1064e-9/0.0254,'ASOT1');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=52.2;
[h,x,y]=beamplot(qASOT1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT2,0,x,y,0,1064e-9/0.0254,'ASOT2',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=76.97;
[h,x,y]=beamplot(qASOT2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_faraday,0,x,y,0,1064e-9/0.0254,'Faraday',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=84.09;
[h,x,y]=beamplot(qASFaraday,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'viewport',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

% AS Table, LSC (detect) path
xlsc=x; ylsc=y;

propdist=86;
[h,x,y]=beamplot(qASviewport,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

xlsc=x; ylsc=y;

propdist=53.05;
[h,x,y]=beamplot(qASL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'229 mm',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=20.75;
[h,x,y]=beamplot(qASL2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2/25.4,0,x,y,0,1064e-9/0.0254,'Detection PD',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% AS Table, Acquire path
x=xlsc; y=ylsc-4;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=40.59;
[h,x,y]=beamplot(qASL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2/25.4,0,x,y,0,1064e-9/0.0254,'Acquisition PD',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

% AS Table, Camera path

x=xlsc; y=ylsc-8;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=53.8;
[h,x,y]=beamplot(qASL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(5/25.4,0,x,y,0,1064e-9/0.0254,'Camera',0);
set(th,'FontUnits','normalized','FontSize',fontsize);


% AS Table, WFS1 path

x=xlsc; y=ylsc-12;

[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=39.55;
[h,x,y]=beamplot(qASL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'-76 mm',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=14.25;
[h,x,y]=beamplot(qASL3,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(10/25.4,0,x,y,0,1064e-9/0.0254,'WFS1',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

%-----------------------------------------------------------------------------
% POB
%-----------------------------------------------------------------------------

% POB in vac
x=0; y=38; 
resolution=1000;

[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'BS');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=525.97;
[h,x,y]=beamplot(qBSFFexiting,[0:propdist/resolution:propdist],x,y,0); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT1,0,x,y,0,1064e-9/0.0254,'POBOT1');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=52.2;
[h,x,y]=beamplot(qPOBOT1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT2,0,x,y,0,1064e-9/0.0254,'POBOT2',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=133.85;
[h,x,y]=beamplot(qPOBOT2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'viewport',1);
set(th,'FontUnits','normalized','FontSize',fontsize);


% POB lsc path

propdist=82;
[h,x,y]=beamplot(qPOBviewport,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'0.69 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

xlsc=x; ylsc=y;

propdist=26.75;
[h,x,y]=beamplot(qPOBL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2/25.4,0,x,y,0,1064e-9/0.0254,'POB PD',2);
set(th,'FontUnits','normalized','FontSize',fontsize);


% POB SPOB path

x=xlsc; y=ylsc-4;
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'0.57 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=38.5;
[h,x,y]=beamplot(qPOBL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'50 mm',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=2.7;
[h,x,y]=beamplot(qPOBL2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(0.1/25.4,0,x,y,0,1064e-9/0.0254,'1811',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

%-----------------------------------------------------------------------------
% POX
%-----------------------------------------------------------------------------

x=0; y=24; 
resolution=1000;

[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'ITMX');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=358.77;
[h,x,y]=beamplot(qITMXRF,[0:propdist/resolution:propdist],x,y,0); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT1,0,x,y,0,1064e-9/0.0254,'POXOT1');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=52.2;
[h,x,y]=beamplot(qPOXOT1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT2,0,x,y,0,1064e-9/0.0254,'POXOT2',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=150.35;
[h,x,y]=beamplot(qPOXOT2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'viewport',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=88.5;
[h,x,y]=beamplot(qPOXviewport,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'0.69 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=27;
[h,x,y]=beamplot(qPOXL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2/25.4,0,x,y,0,1064e-9/0.0254,'POX PD',2);
set(th,'FontUnits','normalized','FontSize',fontsize);

%-----------------------------------------------------------------------------
% POY
%-----------------------------------------------------------------------------

% POY in vac
x=0; y=10; 
resolution=1000;

[h,th]=lensplot(d_largeoptic,0,x,y,0,1064e-9/0.0254,'ITMY');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=326.22;
[h,x,y]=beamplot(qITMYRF,[0:propdist/resolution:propdist],x,y,0); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT1,0,x,y,0,1064e-9/0.0254,'POYOT1');
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=52.2;
[h,x,y]=beamplot(qPOYOT1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(d_OT2,0,x,y,0,1064e-9/0.0254,'POYOT2',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=95.97;
[h,x,y]=beamplot(qPOYOT2,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'viewport',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% POY Table, common path

propdist=41;
[h,x,y]=beamplot(qPOYviewport,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

xcommon=x; ycommon=y;

%POY Table, WFS2 path
x=xcommon; y=ycommon;

%propdist=40.25;
%[h,x,y]=beamplot(qPOYL1,[0:propdist/resolution:propdist],x,y); hold on;
%set(h,'Color',linecolor);
%set(h,'LineStyle',linestyle);
%[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'-76.3 mm',1);
%set(th,'FontUnits','normalized','FontSize',fontsize);

%propdist=29.7;
%[h,x,y]=beamplot(qPOYL2,[0:propdist/resolution:propdist],x,y); hold on;
%set(h,'Color',linecolor);
%set(h,'LineStyle',linestyle);
%[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'~220 mm',0);
%set(th,'FontUnits','normalized','FontSize',fontsize);

propdist=72.95;
[h,x,y]=beamplot(qPOYL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(10/25.4,0,x,y,0,1064e-9/0.0254,'WFS2',2);
set(th,'FontUnits','normalized','FontSize',fontsize);

% POY Table, video camera path

x=xcommon; y=ycommon-4;

%[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'-76.3 mm',0);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

%propdist=28.75;
propdist=57.75;
%[h,x,y]=beamplot(qPOYL2,[0:propdist/resolution:propdist],x,y); hold on;
[h,x,y]=beamplot(qPOYL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(5/25.4,0,x,y,0,1064e-9/0.0254,'Camera',1);
set(th,'FontUnits','normalized','FontSize',fontsize);

% POY Table, phasecamera path
x=xcommon; y=ycommon-8;

%[h,th]=lensplot(1,0,x,y,0,1064e-9/0.0254,'-76.3 mm',0);
[h,th]=lensplot(2,0,x,y,0,1064e-9/0.0254,'1.1 m',0);
set(th,'FontUnits','normalized','FontSize',fontsize);

%propdist=28.75;
propdist=69;
%[h,x,y]=beamplot(qPOYL2,[0:propdist/resolution:propdist],x,y); hold on;
[h,x,y]=beamplot(qPOYL1,[0:propdist/resolution:propdist],x,y); hold on;
set(h,'Color',linecolor);
set(h,'LineStyle',linestyle);
[h,th]=lensplot(0.1/25.4,0,x,y,0,1064e-9/0.0254,'1811',1);
set(th,'FontUnits','normalized','FontSize',fontsize);


end

[h,th]=scalemarker(1800,15,393.70,'10 m','h');
set(th,'FontUnits','normalized','FontSize',0.03);
[h,th]=scalemarker(2000,20,3.9370,'0.1 m','v');
set(th,'FontUnits','normalized','FontSize',0.03);
set(gcf,'Color','w');
set(gcf,'NumberTitle','off');
set(gcf,'Name','LLO beams');
xlabel('Inches');
ylabel('Inches');
set(gca,'Visible','on');
set(gca,'YLim',[0 95]);
set(gca,'XLim',[-100,2400]);
set(gca,'Box','on');
set(gca,'Visible','on');
%title('Input and output beams');
hold off;

