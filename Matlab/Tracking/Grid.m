bead_diametre = 10^-6;


grid_size = 2000;

grid = zeros(2000,2000);
grid(grid_size/2,grid_size/2) = 1;

mesh(grid)
PSF = Airy(465*10^-6,1.5,500*10^-6);
bead = conv2(PSF,grid);