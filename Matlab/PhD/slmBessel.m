%% Function to create annular rings for projection in the Fourier Plane 

p = 1;
r_out = 200;
r_in = 100;

[X,Y] = meshgrid(-255:1:256,-255:1:256);

r = sqrt(X.^2 + Y.^2);
t = (1-heaviside(r - r_out)) .*(1-heaviside(r_in - r));


kr = (2*pi) / p;
d_theta = -kr.*r;
d_theta_mod=mod(real(d_theta),2*pi);

h = t.*exp(1i.*d_theta_mod);
h = mod(real(h),2*pi);

imagesc(t)