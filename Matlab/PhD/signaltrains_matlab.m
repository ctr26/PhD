clear all 
x1 = linspace(1,10,10)
y1 = linspace(0,1,11)

y2 = (cos(y1*pi) +1)/2;
y = [y1 y2(2:10)]; 

z1 = linspace(0,0.2,11)
z2 = ((cos(y1*pi) +1)/15)+0.08;

z = [z1 z2(2:10)];
for i = 1:4
    y = [y y1 y2(2:10)];
    z = [z z1+0.1*i z2(2:10)+0.1*i]

end

y = [y 0]
z = [z 0.482]
x = 0:100

subplot(2,1,1)

plot(x,y)
title('Signal Trains for Virtual Light Sheet Mirror Scanning');
p1 = gca;
p1.XTickLabel = {'0', 'Field of View', 'Interval', 'Field of View', 'Interval', 'Field of View', 'Interval', 'Field of View', 'Interval', 'Field of View', 'Interval'};
ylabel('Signal Intensity / A.U');
pretty_fig

subplot(2,1,2)
plot(x,z)
p2 = gca;
title('Signal Trains for z Mirror Scanning');
p2.XTickLabel = {'0', 'Field of View', 'Interval', 'Field of View', 'Interval', 'Field of View', 'Interval', 'Field of View', 'Interval', 'Field of View', 'Interval'};
ylabel('Signal Intensity / A.U');
pretty_fig