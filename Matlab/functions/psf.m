function z = psf(pupil,w)


z = pupil.*exp(2*pi*j*w);
z = fftshift(z);
z = fft2(z);
z = fftshift(z);
z = z.*conj(z);
zmax = max(max(z));
z = z/zmax;