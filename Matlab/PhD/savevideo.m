outputFileName = 'img_stack.tif'
for K=1:length(final(1, 1, :))
   imwrite(final(:, :, K), outputFileName, 'WriteMode', 'append');
end