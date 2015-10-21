laser=0;
if Laser==0;
laser=0;
end
if Laser==1;
laser=1;
end

Sweep_Time=Sweep_Time/1000000;
Sweep_Interval=Sweep_Interval/1000000
Sample_Rate=Sample_Rate*1000;
Camera_Phase=Camera_Phase/1000000;

dt=1/Sample_Rate;

% Establish phase shift

n_points_del=abs(Camera_Phase)*Sample_Rate;

 if Camera_Phase>0
delay_wav_cam=zeros(1,n_points_del);
delay_wav_mirr=[];
elseif Camera_Phase<0
delay_wav_mirr=zeros(1,n_points_del);
delay_wav_cam=[];
else
delay_wav_cam=[];
delay_wav_mirr=[];
end

% Generate Scan Mirror Waveform
n_points_sw=Sweep_Time*Sample_Rate;
n_points_int=Sweep_Interval*Sample_Rate;

interval_wav=1:n_points_int;
interval_wav=Scan_Mirror_Min+Scan_Mirror_Amplitude*(0.5+0.5*cos(pi*interval_wav/n_points_int));

sweep=linramp(Scan_Mirror_Min, (Scan_Mirror_Min+Scan_Mirror_Amplitude), n_points_sw);
sweep=[sweep, interval_wav];
sweep_length=length(sweep);

%Scan_correction=linspace(0,Number_Slices,(sweep_length*Number_Slices));
%Scan_correction=Beam_at_max*floor(Scan_correction);

Scan_Mirror_Waveform=repeatmx(sweep, 1, Number_Slices);
%Scan_Mirror_Waveform=Scan_Mirror_Waveform+Scan_correction;

Scan_Mirror_Waveform=[delay_wav_mirr, Scan_Mirror_Waveform, delay_wav_cam];

waveform_length=length(Scan_Mirror_Waveform);

% Generate Piezo waveform
Piezo_Waveform=linspace(0, (Number_Slices), (Number_Slices*sweep_length+1));
Piezo_Waveform=Piezo_Waveform(1,1:(end-1));
Piezo_Waveform=floor(Piezo_Waveform);
Piezo_Waveform=Piezo_Waveform*((Piezo_End/10-Piezo_Start/10)/(Number_Slices-1));
Piezo_Waveform=Piezo_Start/10+Piezo_Waveform;

piezo_return=1:n_points_int;
piezo_return=Piezo_Start/10+(Piezo_End/10-Piezo_Start/10)*(0.5+0.5*cos(pi*piezo_return/n_points_int));

Piezo_Waveform=Piezo_Waveform(n_points_int+1:end);
Piezo_Waveform=[Piezo_Waveform, piezo_return];

Piezo_Waveform=[delay_wav_mirr, Piezo_Waveform, delay_wav_cam];

% Update Scan mirror waveform
Scan_Mirror_Waveform=Scan_Mirror_Waveform+Beam_at_max*Piezo_Waveform;


% Generate camera waveform
Digi_high=round(sweep_length/10);
Digi_low=sweep_length-Digi_high;

Camera_Waveform=[ones(1,Digi_high) zeros(1,Digi_low)];
Camera_Waveform=repeatmx(Camera_Waveform,1,Number_Slices);
Camera_Waveform=[delay_wav_cam, Camera_Waveform, delay_wav_mirr]';

% Generate Z_mirror
Z_mirror_Waveform=Z_Offset+Z_Gain*Piezo_Waveform;
ex_det_corr=[linramp(-Z_Offset_2/2,Z_Offset_2/2,n_points_sw), zeros(1,n_points_int)];
ex_det_corr=repeatmx(ex_det_corr,1,Number_Slices);
ex_det_corr=[delay_wav_mirr, ex_det_corr, delay_wav_cam];

Z_mirror_Waveform=Z_mirror_Waveform+ex_det_corr;

% Generate laser
Laser_waveform=[ones(1,n_points_sw), zeros(1,n_points_int)];
Laser_waveform=repeatmx(Laser_waveform,1,Number_Slices);
Laser_waveform=[delay_wav_mirr, Laser_waveform, delay_wav_cam]';

% Generate lens 1 waveform
  Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);
   %Lens1_Waveform=Scan_Mirror_Waveform;
   %Lens1_Waveform=linspace(Tuneable_Lens_1,Tuneable_Lens_1+0.3,waveform_length)

% bent switch
bent_state =Z_Offset_1;

%%%%%%%%%%%%%%%%%%%%%%%%%
if bent_state ==0

% Generate lens 2 waveform
   Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);
   Lens2_Waveform=Tuneable_Lens_2*ones(1,waveform_length);

   %Lens2_Waveform=0.5*cos(linspace(-pi/2,pi/2,n_points_sw))+0.5;
   %Lens2_Waveform=Lens2_Waveform*2+Tuneable_Lens_2;
   %Lens2_Waveform=[Lens2_Waveform, Tuneable_Lens_2*ones(1,n_points_int)];
   %Lens2_Waveform=repeatmx(Lens2_Waveform,1,Number_Slices);
   %Lens2_Waveform=[delay_wav_cam, Lens2_Waveform, delay_wav_mirr];


%%%%%%%%%%%%%%%%%%%%%%%%%
elseif  bent_state ==2

Lens2_Waveform=Tuneable_Lens_2*ones(1,waveform_length);

R=Scan_position_1;
offset=0.0;
Corr=0;

Lens1_Waveform=[];

for n=0:Number_Slices-1
Lens1_sweep=Tuneable_Lens_1*ones(1,sweep_length);
    
b=R*sqrt(1-((Number_Slices-n)/Number_Slices)^2);    
a=sqrt(1-((Number_Slices-n)/Number_Slices)^2);

X=linspace(-1,1,(n_points_sw-2*floor(offset*n_points_sw)));
Y=b*sqrt(1-(X./a).^2);
Y=real(Y);

Y=Y+Corr*linspace(0,100,length(Y));
Y=[zeros(1,floor(offset*n_points_sw)),Y,zeros(1,floor(offset*n_points_sw)),zeros(1,n_points_int)];

Lens1_sweep=Lens1_sweep + Y;

Lens1_Waveform=[Lens1_Waveform, Lens1_sweep];


end

Lens1_Waveform=[delay_wav_mirr, Lens1_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%%%

elseif bent_state==3

R=Scan_position_1;
Y=Scan_position_2;

Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);

Lens2_wav=Tuneable_Lens_2*ones(1,n_points_sw-round(0.9*n_points_sw));
Lens2_wav2=Tuneable_Lens_2+R*linspace(0,1,round(0.9*n_points_sw));
Lens2_wav2(Lens2_wav2>Y)=Y;

Lens2_Waveform=[Lens2_wav, Lens2_wav2, Tuneable_Lens_2*ones(1,n_points_int)];
Lens2_Waveform=repeatmx(Lens2_Waveform,1,Number_Slices);
Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%%%%

elseif bent_state==4

R=Scan_position_1;
Y=Scan_position_2;

Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);

X=linspace(-2,4,n_points_sw);

Lens2_wav=exp(-R*X);
Lens2_wav2=Tuneable_Lens_2+Y*((1+Lens2_wav).^-1);

Xint=linspace(2,-4,n_points_int);

Lens2_wavint=exp(-R*Xint);
Lens2_wav2int=Tuneable_Lens_2+Y*((1+Lens2_wavint).^-1);

Lens2_Waveform=[Lens2_wav2, Lens2_wav2int];
Lens2_Waveform=repeatmx(Lens2_Waveform,1,Number_Slices);
Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%

elseif bent_state==5

R=Scan_position_1;
Y=Scan_position_2;

Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);

X=linspace(0,2*pi,n_points_sw);

Lens2_wav2=Y*sin(R*X);

Lens2_Waveform=[Lens2_wav2, Tuneable_Lens_2*ones(1,n_points_int)];
Lens2_Waveform=repeatmx(Lens2_Waveform,1,Number_Slices);
Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%

elseif bent_state==6

R=Scan_position_1;
Y=Scan_position_2;

Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);

Lens_wav1=Tuneable_Lens_2+R*linspace(0,1,round(n_points_sw/2));
Lens_wav2=Tuneable_Lens_2+R*linspace(1,0,n_points_sw-round(n_points_sw/2))

Lens2_Waveform=[Lens_wav1, Lens_wav2, Tuneable_Lens_2*ones(1,n_points_int)];
Lens2_Waveform=repeatmx(Lens2_Waveform,1,Number_Slices);
Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%%%%%%

elseif bent_state==7

Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);
Lens2_sweep=Tuneable_Lens_2*ones(1,sweep_length);

R=Scan_position_1;
offset1=0;
offset2=0.3;
fac=Beam_at_min;
fac2=Scan_position_2;

x=linspace(-1,1,(n_points_sw-floor(offset1*n_points_sw)-floor(offset2*n_points_sw)));;
y=R*cos(x*pi);
%y=R*real(sqrt(1-x.^2));
yp=fac2*diff(y);
yp(yp<0)=fac*yp(yp<0);

yi=zeros(1,length(x)-1);
for i=1:(length(x)-1)
yi(i)=trapz(yp(1:i));
end

yi=[0,zeros(1,floor(offset1*n_points_sw)),yi,min(yi)*ones(1,floor(offset2*n_points_sw)),zeros(1,n_points_int)];

Lens2_sweep=Lens2_sweep + yi;

Lens2_Waveform=repeatmx(Lens2_sweep,1,Number_Slices);

Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%

elseif bent_state==8

Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);
Lens2_sweep=Tuneable_Lens_2*ones(1,sweep_length);

R=Scan_position_1;
offset=0.4;
fac2=Scan_position_2;
fac=Beam_at_min;

x=linspace(-1,1,n_points_sw);;
y=R*cos(x*pi);
%y=R*real(sqrt((1-offset)^2-x.^2));
yp=fac2*diff(y);
yp(yp<0)=fac*yp(yp<0);

yi=zeros(1,length(x)-1);
for i=1:(length(x)-1)
yi(i)=trapz(yp(1:i));
end

yi=[0,yi,zeros(1,n_points_int)];

Lens2_sweep=Lens2_sweep + yi;

Lens2_Waveform=repmat(Lens2_sweep,1,Number_Slices);

Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

%%%%%%%%%%%%%%%%%%
else
Lens1_Waveform=Tuneable_Lens_1*ones(1,waveform_length);

R=Scan_position_1;
offset=0.0;
Corr=0;

Lens2_Waveform=[];

for n=0:Number_Slices-1
Lens2_sweep=Tuneable_Lens_2*ones(1,sweep_length);
    
b=R*sqrt(1-((Number_Slices-n)/Number_Slices)^2);    
a=sqrt(1-((Number_Slices-n)/Number_Slices)^2);

X=linspace(-1,1,(n_points_sw-2*floor(offset*n_points_sw)));
Y=b*sqrt(1-(X./a).^2);
Y=real(Y);

Y=Y+Corr*linspace(0,100,length(Y));
Y=[zeros(1,floor(offset*n_points_sw)),Y,zeros(1,floor(offset*n_points_sw)),zeros(1,n_points_int)];

Lens2_sweep=Lens2_sweep + Y;

Lens2_Waveform=[Lens2_Waveform, Lens2_sweep];


end

Lens2_Waveform=[delay_wav_mirr, Lens2_Waveform, delay_wav_cam];

end


%Combine digital waveforms
Camera_Waveform=[Camera_Waveform, Laser_waveform];