a = double(imread('test.jpg'));
colormap('gray'), imagesc(a);
a = 255-a;
colormap('gray'), imagesc(a);
b = bpass(a,1,10);
colormap('gray'), image(b);
pk = pkfnd(b,60,11);
max(max(b))
cnt = cntrd(b,pk,15);
whos cnt
hist(mod(cnt(:,1),1),20);