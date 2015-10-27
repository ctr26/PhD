z_slices = 100;
run("Enhance Contrast", "saturated=0.35");
getDimensions(width, height, channels, slices, frames);
t_slices = slices / z_slices;
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=z_slices frames=t_slices display=Grayscale");
