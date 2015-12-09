path = 'C:\Users\Craig\Dropbox\First Year\Spim Upgrade\dichorics\';
list = {'e02','zt458rdc','zt514rdc','zt594rdc'};

colour = [445 488 561 647];

clf

figure(1)

hold on

for i=1:length(list)
    spectrumRGB(colour(i))
   strcat(path,list{1,i},'.xlsx');
    %num{i} = xlsread(strcat(path,list{1,i},'.xlsx'));
   % temp = num{1,i});
   temp = xlsread(strcat(path,list{1,i},'.xlsx'));
   plot(temp(:,1),temp(:,2),'Color',spectrumRGB(colour(i)));
   
    
end
title('Reflectance Profiles of Mirrors');
xlabel('Wavelength /nm')
ylabel('Refleactance /A.U');
%legend(list)
for i=1:length(list)
line([colour(i),colour(i)],[0,1],'Color',spectrumRGB(colour(i)),'LineWidth',2,'LineStyle','--');

end

br = strcat(cellfun(@num2str, num2cell(colour(:)), 'UniformOutput', false)', ' nm');
ar = list;
A = [ar;br];   % concatenate them vertically
c = A(:)';




legend([ar';br'])
axis([300,700,0,1])

hold off


pretty_fig