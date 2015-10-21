

radius_part = 1*10^-6;
FOV_X = 10 * 10^-6;
FOV_Y = 10 * 10^-6;
FOV_Z = 100 * 10^-6;
lambda = 500 * 10 ^ -9;

result = Particle_Bin(FOV_X,FOV_Y,FOV_Z,radius_part);

psf = Airy2(lambda,1.33,FOV_X); %make
psf = inpaint_nans(psf); %nans
psf = psf(400:600,400:600); %crop

%particle_map = padarray(result,[295 295] ,'both');
particle_map = result;
[temp temp i_end] = size(particle_map);


h = waitbar(0,'Initializing waitbar...');
for i = 1:i_end
    waitbar(i/i_end,h,'Halfway there...');
    blurry(:,:,i) = conv2(psf,particle_map(:,:,i));
end