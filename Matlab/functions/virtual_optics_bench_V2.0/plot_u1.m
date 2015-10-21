function plot_u1(handles)


u1=handles.u_new;
history=handles.history;
list_h=handles.listbox_h;
%plot_u1(u1,history,list_h)
range=handles.range_v; %mm

npoints=handles.resolution_v;
step=range/npoints;


scale=-range/2:step:range/2-step;
ftscale=(npoints/range^2)*scale;


colormap('gray')
result=abs(u1).^2;
%imagesc(scale,scale,mod(angle(mt),2*pi),[0 2*pi])
imagesc(scale,scale,result);
axis([min(scale)/1 max(scale)/1 min(scale)/1 max(scale)/1]);

%string=['d = ' num2str(zdist, '%6.0f') ];
%string=['g = ' num2str(g,'%1.2f')];
%text(-1.1,-1.1,string,'Color',[1,1,1]);
axis('square');

history_str=history;
set(list_h,'String',history_str);


end