function V = Particle_Bin(FOV_X,FOV_Y,FOV_Z,radius)

%Build binary particle
particle = 1*10^-6;
particle=radius


% FOV_X = 10 * 10^-6;
% FOV_Y = 10 * 10^-6;

%FOV_Z = 100 * 10^-6;


camera_px = 2048;
z_slices = 100;
mag = 25;

z_step = FOV_Z / z_slices;
x_step = FOV_X  / camera_px;
y_step = FOV_Y  / camera_px;

radius_px = particle / x_step;

[x,y,z]= meshgrid(-radius_px:radius_px);

size(z)

V=sqrt(x.^2+y.^2+z.^2);
V(V<radius_px)=1; V(V>radius_px)=0;

%V = V(:,:,1:10:size(V,10));
%Sample z dimension

%V = V;
%V = V(:,:,1:41:size(V,3));

%V = padarray(V,[295 295] ,'both');