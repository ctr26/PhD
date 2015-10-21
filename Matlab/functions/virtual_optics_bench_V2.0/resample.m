function u_new=resample(u0,old_npoints,old_range,new_npoints,new_range)


old_res=old_range/old_npoints; %mm/pixel

new_res=new_range/new_npoints; %mm/pixel

ratio=old_res/new_res;


newside=ratio*old_npoints;
% u0_mag=abs(u0);
% u0_ph=angle(u0);
% 
% u1_mag=imresize(u0_mag,[newside,newside]);
% u1_ph=imresize(u0_ph,[newside,newside],'nearest');
% 
% u1=u1_mag.*exp(1i*u1_ph);

u1=imresize(u0,[newside,newside],'nearest');
t=0
u1_size=size(u1);

if (u1_size==new_npoints)
    u2=u1;

elseif (u1_size > new_npoints)
    
   center_ind=floor(size(u1,1)/2);
   halfrange=ceil(new_npoints/2);
   u2=u1(center_ind-halfrange+1:center_ind+halfrange,center_ind-halfrange+1:center_ind+halfrange);

elseif (u1_size < new_npoints)
    diff=new_npoints-u1_size(1);
        if mod(diff,2)==0
            diff2=diff/2;
            u2=padarray(u1,[diff2,diff2]);

        else 
            diff1=floor(diff/2);
            diff2=ceil(diff/2);
            u2=padarray(u1,[diff1,diff1],'pre');
            u2=padarray(u2,[diff2,diff2],'post');
        end

end



u_new=u2;

end