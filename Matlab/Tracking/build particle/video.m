function[] =video(map)
[a b z_end] = size(map);
pause on;
for z = 1:z_end
    
    imshow(map(:,:,z))
    drawnow
    pause((40*10^-3))
end
