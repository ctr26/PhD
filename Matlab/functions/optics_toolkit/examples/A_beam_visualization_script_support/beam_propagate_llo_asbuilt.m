%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a beam propagation calculation for LLO.  The script is normally run in %
% standalone mode where all quantities take either the "as built" or design      %
% values (set variable "asbuilt" to 1 to get the as built design).  By specifying%
% "standalone=0" the script assumes that the mc waist size and/or beam width at  %
% the recycling mirror are already specified.  To use beam_visualize.m set       %
% standalone to zero.                                                            %
%                                                                                %
% In-vacuum distances obtained from CAD drawing D970610-A.dwg unless otherwise   %
% noted.  Distances on the output tables (outside the vacuum) were measured with %
% a measuring tape to 0.25" accuracty.                                           %
% Radii of curvature were obtained from design documents unless otherwise        %   
% indicated.                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

standalone=1;

if standalone
    postmc_power=3; % Watts
    var_mcwaist=0;
    var_rmwidth=0;
    var_deltaMMT2pos=1;  deltaMMT2pos=3.180;
end

faraday_thermlensdata=[%input power[W]  FL[m] (values from IOO final design document, fig. 37)
    1   600/0.0254
    2   350/0.0254
    3   225/0.0254
    3.2 200/0.0254
    4.1 150/0.0254
    5   113/0.0254
    10  57/0.0254
    13  50/0.0254
    20  30/0.0254
];
faradaylens=interp1(faraday_thermlensdata(:,1),faraday_thermlensdata(:,2),[0:0.1:20],'spline');
% lookup table for the faraday lens where the nth row gives the estimated 
% induced focal length of the faraday in inches for n/10 Watts of incident power.

faraday_f=faradaylens(round(postmc_power*10)); % Thermally induced focal length of the faraday


%-------------------------------------------------------------------------------
% Reflection matrixes for curved optics (suspended optics not listed are flat)
%-------------------------------------------------------------------------------    

lambda=1064e-9/0.0254;

RM=mirr(6.213e5);
RMrear=fdie(1.45,1)*free(3.63,1.45)*mirr(-6.213e5)*free(3.63,1.45)*fdie(1,1.45);
RMlens=sdie(-6.213e5,1.45,1)*free(3.63,1.45)*fdie(1,1.45);
BSlens=slab(1.90,1.45);
ITMX=mirr(5.811e5);
ITMXrear=fdie(1.45,1)*free(3.83,1.45)*mirr(-5.811e5)*free(3.83,1.45)*fdie(1,1.45);
ITMY=mirr(5.717e5);
ITMYrear=fdie(1.45,1)*free(3.83,1.45)*mirr(-5.717e5)*free(3.83,1.45)*fdie(1,1.45);
ITMXlens=sdie(-5.811e5,1.45,1)*free(3.83,1.45)*fdie(1,1.45);
ITMYlens=sdie(-5.717e5,1.45,1)*free(3.83,1.45)*fdie(1,1.45);
ETMX=mirr(3.437e5);
ETMY=mirr(3.433e5);

MC2=mirr(679.1);
MMT1=mirr(266.1);
MMT2=mirr(124.4);
MMT3=mirr(990.6);
OT1=mirr(119.2);         % off axis parabolic 
OT2=mirr(-14.90);        % off axis parabolic

%mirror diameters:
d_smalloptic=2.36;       % active area   (60 mm)
d_largeoptic=9.84;
d_OT1=8;
d_OT2=3.15;
d_faraday=0.472;         % clear aperture (12 mm)


%------------------------------------------------------------------------------
% Lenses on tables (focal lengths are in inches)
%------------------------------------------------------------------------------

ASL1=lens(45.11);   % first lens, 2" diameter (at bottom of periscope)
ASL2=lens(9.02);    % second lens in LSC detect path (going to ASPD2 and ASPD3)
ASL3=lens(-3.00);   % in WFS1 path immediately before WFS1

POBL1=lens(27.07);  % first lens, 2" diameter (at bottom of periscope)
POBL2=lens(1.97);   % lens immediately before SPOB (1811) PD

REFLL1=lens(45.11); % Immediately following REFL periscope
REFLL2=lens(7);     % immediately before 25 MHz LSC PD (lens is mismarked, this f is a guess)
REFLL3=lens(15.79); % first lens in WFS3 path
REFLL4=lens(-1.97); % second lens in WFS3 path
REFLL5=lens(15);    % only lens in WFS4 path

POYL1=lens(45.11);  % on POY periscope
POYL2=lens(-3.00);  % second lens in POY path on table
POYL3=lens(8.5);    % lens right before the WFS3 head (lens is not marked, this is
                    % a guess based on imaging the room lights, i.e. the distance from
                    % the floor at which the room lights are focused. The lights are
                    % about 20 meters overhead.
POXL1=lens(27.07);  % Immediately following POX periscope

%------------------------------------------------------------------------------
% Free space propagation matrixes for interoptic and transoptic distances.
% In vacuum distances are accurate to about 0.1 inch.  Distances outside of
% vacuum are accurate to 0.25 inches unless otherwise specified.
%------------------------------------------------------------------------------

%MCrefl
MCwaist_MC1FF=free(3.74);
MC1FF_MC1RF=free(1.10,1.45);
MC1RF_MCreflviewport=free(75.92);

%MCtrans
MCwaist_MC3FF=free(3.74);
MC3FF_MC3RF=free(1.10,1.45);
MC3RF_SMFF=free(20.47);
SMFF_SMRF=free(1.14,1.45);
SMRF_MCtransviewport=free(99.91);

%MMT
SMFF_MMT1FF=lens(faraday_f)*free(27.03-1.48);   
                                % CAD drawing D970610-A.dwg. Additive pathlength correction is for optical path in faraday (2 polarizers+faraday TGG crystal, each 0.8 in thick).
if ~var_deltaMMT2pos
    MMT1FF_MMT2FF=free(533.55); % CAD drawing D970610-A.dwg    
    MMT2FF_MMT3FF=free(565.99); % CAD drawing D970610-A.dwg
else
    MMT1FF_MMT2FF=free(533.55+deltaMMT2pos); % CAD drawing D970610-A.dwg    
    MMT2FF_MMT3FF=free(565.99+deltaMMT2pos);
end
MMT3FF_RMRF=free(637.41);       % CAD drawing D970610-A.dwg
MMT1FF_Faraday=lens(faraday_f)*free(17.21-1.48); %Additive pathlength correction is for optical path in faraday (2 polarizers+faraday TGG crystal, each 0.8 in thick).

%REFL
Faraday_REFLviewport=free(60.8);

REFLviewport_REFLL1=free(43);
REFLL1_REFLL2=free(30.4);
REFLL2_REFLPD1=free(6.5);
REFLL1_REFLPD2=free(40.25);
REFLL1_REFLL3=free(76.5);
REFLL3_REFLL4=free(21.5);
REFLL4_WFS3=free(5.25);
REFLL1_REFLL5=free(70.75);
REFLL5_WFS4=free(39.5);
REFLL1_REFLcam=free(27);

%Recycling Cavity
RMFF_BSFF=free(173.13);
BSRF_ITMXRF=free(186.12);
BSFF_ITMYRF=free(177.09);

RMFF_ITMXFF=free(368.35);       %measured
RMFF_ITMYFF=free(354.49);       %measured

%Arm Cavities
ITMXFF_ETMXFF=free(157284.7);   %measured
ITMYFF_ETMYFF=free(157283.5);   %measured


%AS
BSRF_ASOT1=free(172.85);
OT1_OT2=free(52.2);
ASOT2_ASFaraday=free(76.97);
ASFaraday_ASviewport=free(84.09);

ASviewport_ASL1=free(86);
ASL1_ASL2=free(53.05);
ASL2_ASPD=free(20.75);
ASL1_ASacquirePD=free(40.59);
ASL1_AScam=free(53.8);
ASL1_ASL3=free(39.55);
ASL3_WFS1=free(14.25);

%POB
BSFF_POBOT1=free(525.97);
POBOT2_POBviewport=free(133.85);

POBviewport_POBL1=free(82);
POBL1_POBPD=free(26.75);
POBL1_POBL2=free(38.5);
POBL2_SPOBPD=free(2.7);

%POX
ITMXRF_POXOT1=free(358.77);
POXOT2_POXviewport=free(150.35);
POXviewport_POXL1=free(48+7+25+8.5);    % viewport to periscope top distance of 48" has uncertainty of +/- 3".
POXL1_POXPD=free(27);

%POY
ITMYRF_POYOT1=free(326.22);
POYOT2_POYviewport=free(95.97);

POYviewport_POYL1=free(41);
POYL1_POYcam=free(57.75);
POYL1_WFS2=free(72.95);
POYL1_PhasecameraPD=free(64);
%POYL1_POYL2=free(40.25);      % After removal of second lens (Feb/Mar 'O4) these were commented out
%POYL2_POYcam=free(17.5);
%POYL2_POYL3=free(29.7);
%POYL3_WFS2=free(3);
%POYL2_PhasecameraPD=free(28.75);


%--------------------------------------------------------
% MC
%--------------------------------------------------------

if ~var_mcwaist
    qMCwaist=q_(0.06413,1e30,lambda);
else
    qMCwaist=q_(wmc,1e30,lambda);
end

qMCreflvac=prop(qMCwaist,...                % MC waist to MC Refl viewport
    MC1RF_MCreflviewport*...
    MC1FF_MC1RF*...
    MCwaist_MC1FF...
    );                    

qMCtransvac=prop(qMCwaist,...               % MC waist to MC Trans viewport
    SMRF_MCtransviewport.*...
    SMFF_SMRF*...
    MC3RF_SMFF*...
    MC3FF_MC3RF*...
    MCwaist_MC3FF...
    );                  
    

%--------------------------------------------------------
% MMT
%--------------------------------------------------------

qMMT1FF=prop(qMCwaist,...
    MMT1*...
    SMFF_MMT1FF*...
    MC3RF_SMFF*...
    MC3FF_MC3RF*...
    MCwaist_MC3FF...
    );

qMMT2FF=prop(qMMT1FF,...
    MMT2*...
    MMT1FF_MMT2FF...
    );

qMMT3FF=prop(qMMT2FF,...
    MMT3*...
    MMT2FF_MMT3FF...
    );

qRMRFincident=prop(qMMT3FF,MMT3FF_RMRF);

if ~var_rmwidth
    qRMFF=prop(qRMRFincident,RMlens);
else
    qRMFF=q_(wrm,1e30);
end


%--------------------------------------------------------
% REFL
%--------------------------------------------------------

qRMrear=prop(qRMRFincident,RMrear);

qMMT3FFreturning=prop(qRMrear,...
    MMT3*...
    MMT3FF_RMRF...
    );

qMMT2FFreturning=prop(qMMT3FFreturning,...
    MMT2*...
    MMT2FF_MMT3FF...
    );


qMMT1FFreturning=prop(qMMT2FFreturning,...
    MMT1*...
    MMT1FF_MMT2FF...
    );

qFaradayreturning=prop(qMMT1FFreturning,MMT1FF_Faraday);

qREFLviewport=prop(qFaradayreturning,Faraday_REFLviewport);

qREFLL1=prop(qREFLviewport,REFLL1*REFLviewport_REFLL1);
qREFLL2=prop(qREFLL1,REFLL2*REFLL1_REFLL2);
qREFLPD1=prop(qREFLL2,REFLL2_REFLPD1);
qREFLPD2=prop(qREFLL1,REFLL1_REFLPD2);

qREFLL3=prop(qREFLL1,REFLL3*REFLL1_REFLL3);
qREFLL4=prop(qREFLL3,REFLL4*REFLL3_REFLL4);
qWFS3=prop(qREFLL4,REFLL4_WFS3);
qREFLL5=prop(qREFLL1,REFLL5*REFLL1_REFLL5);
qWFS4=prop(qREFLL5,REFLL5_WFS4);

qREFLcam=prop(qREFLL1,REFLL1_REFLcam);


%--------------------------------------------------------
% Recycling cavity
%--------------------------------------------------------

qBSFF=prop(qRMFF,RMFF_BSFF);

qBSRF=prop(qBSFF,BSlens);

qITMXRF=prop(qRMFF,...
    BSRF_ITMXRF*...
    BSlens*...
    RMFF_BSFF...
    );

qITMXFF=prop(qITMXRF,ITMXlens);

qITMYRF=prop(qRMFF,...
    BSFF_ITMYRF*...
    RMFF_BSFF...
    );

qITMYFF=prop(qITMYRF,ITMYlens);


%--------------------------------------------------------
% Arm Cavities
%--------------------------------------------------------

qETMXFF=prop(qITMXFF,ITMXFF_ETMXFF);
qETMYFF=prop(qITMYFF,ITMYFF_ETMYFF);


%--------------------------------------------------------
% POB
%--------------------------------------------------------

qBSFFexiting=prop(qBSFF,...
    BSlens*...
    BSlens...
    );

qPOBOT1=prop(qBSFFexiting,...
    OT1*...
    BSFF_POBOT1...
    );

qPOBOT2=prop(qPOBOT1,...
    OT2*...
    OT1_OT2...
    );

qPOBviewport=prop(qPOBOT2,POBOT2_POBviewport);

qPOBL1=prop(qPOBviewport,POBL1*POBviewport_POBL1);
qPOBPD=prop(qPOBL1,POBL1_POBPD);

qPOBL2=prop(qPOBL1,POBL2*POBL1_POBL2);
qSPOBPD=prop(qPOBL2,POBL2_SPOBPD);


%--------------------------------------------------------
% AS
%--------------------------------------------------------

qBSRFreturning=prop(qBSRF,...
    BSRF_ITMXRF*...
    ITMXrear*...
    BSRF_ITMXRF...
    );

qASOT1=prop(qBSRFreturning,...
    OT1*...
    BSRF_ASOT1...
    );

qASOT2=prop(qASOT1,...
    OT2*...
    OT1_OT2...
    );
qASFaraday=prop(qASOT2,ASOT2_ASFaraday);

qASviewport=prop(qASFaraday,ASFaraday_ASviewport);

qASL1=prop(qASviewport,ASL1*ASviewport_ASL1);
qASL2=prop(qASL1,ASL2*ASL1_ASL2);
qASPD=prop(qASL2,ASL2_ASPD);

qASacquirePD=prop(qASL1,ASL1_ASacquirePD);

qAScam=prop(qASL1,ASL1_AScam);

qASL3=prop(qASL1,ASL3*ASL1_ASL3);
qWFS1=prop(qASL3,ASL3_WFS1);


%--------------------------------------------------------
% POX
%--------------------------------------------------------

qPOXOT1=prop(qITMXRF,...
    OT1*...
    ITMXRF_POXOT1...
    );

qPOXOT2=prop(qPOXOT1,...
    OT2*...
    OT1_OT2...
    );

qPOXviewport=prop(qPOXOT2,POXOT2_POXviewport);

qPOXL1=prop(qPOXviewport,POXviewport_POXL1);

qPOXPD=prop(qPOXL1,POXL1_POXPD);

%--------------------------------------------------------
% POY
%--------------------------------------------------------

qPOYOT1=prop(qITMYRF,...
    OT1*...
    ITMYRF_POYOT1...
    );

qPOYOT2=prop(qPOYOT1,...
    OT2*...
    OT1_OT2...
    );

qPOYviewport=prop(qPOYOT2,POYOT2_POYviewport);

qPOYL1=prop(qPOYviewport,POYL1*POYviewport_POYL1);
qWFS2=prop(qPOYL1,POYL1_WFS2);
qphasecamera=prop(qPOYL1,POYL1_PhasecameraPD);

%qPOYL2=prop(qPOYL1,POYL2*POYL1_POYL2);
%qPOYL3=prop(qPOYL2,POYL3*POYL2_POYL3);
%qWFS2=prop(qPOYL3,POYL3_WFS2);

%qPhasecamera=prop(qPOYL2,POYL2_PhasecameraPD);
