%----------------------------------------------------------------------------------------------
% PROGRAM: polarmesh
% AUTHOR:  Andri M. Gretarsson
% DATE:    7/10/04
%
% SYNTAX: [rmesh,thetamesh,xmesh,ymesh]=polarmesh(r <,theta,rspacing>);
%           <...> indicates optional arguments
%
% Simplified way of generating arbitrary polar meshes. 
%
% INPUT ARGUMENTS:
% ----------------    
% r        = specification for the r mesh. If r is a 1x3 vector the entries are assumed
%            to indicate r_start, r_end and n_rpts (number of r=const curves) and a set
%            of equally spaced or square spaced r=const mesh curves are generated. If r is 
%            nx1, each entry is assumed to be a constant for which to generate an r=const
%            curve in the mesh.  If r is 2D (nxn, where n>1) it is assumed to be already
%            in mesh form.  In this case theta must be specified in mesh form and the 
%            function does no more than pol2cart.
% theta    = specification for the theta mesh. If it is left blank the default theta is
%            used (a mesh with 1 line per theta from 0 to 360).  If theta is 1x3, the 
%            values are assumed to be [theta_start,theta_end,n_thetapts] and are used to 
%            generate a set of n_thetapts equally spaced theta=const curves in the mesh.
%            If theta is [nx1] the one mesh curve is generated for each entry at the
%            specified angle. 
% rspacing = 'lin' for linear spacing of the r mesh
%            'sqr' for r-line spacing proportional to r^2.
%
% OUTPUT ARGUMENTS:
% -----------------
% rmesh,thetamesh = r and theta meshes in polar coordinates
% xmesh,ymesh     = the r and theta meshes but in cartesian coordinates.
%
% Last updated: July 18, 2004 by AMG
%----------------------------------------------------------------------------------------------
%% SYNTAX: z=recompose(domain,type,coeffs,varargin);
%----------------------------------------------------------------------------------------------
function [rmesh,thetamesh,xmesh,ymesh]=polarmesh(r,varargin);

if nargin>=2 theta=varargin{1}; defaulttheta=0; else defaulttheta=1; end
if nargin>=3 & strcmp(varargin{2},'rsqr') linflag=0; else linflag=1; end 

if min(size(r))==1                                                      % r is 1D
    if size(r,1)==1 & size(r,2)==3                                      % r=[r_start,r_end,rpts]
        if linflag                                                      % linear r-spacing for mesh
            rseed=[r(1):(r(2)-r(1))/(r(3)-1):r(2)].';       
        else                                                            % r-spacing proportional to r^2
            rseed=[sqrt(r(1)):(sqrt(r(2))-sqrt(r(1)))/(r(3)-1):sqrt(r(2))].'.^2;
        end
        if defaulttheta==1                                              % default theta
            thetaseed=[0:1:360].'*pi/180;
            [thetamesh,rmesh]=meshgrid(thetaseed,rseed);                % I like r to be arranged in the first position (r,theta)
            thetamesh=transpose(thetamesh);                             % rather than (theta,r) so for consistency with (xmesh,ymesh)
            rmesh=transpose(rmesh);                                     % rmesh must have identical rows and thetamesh identical columns
        else                                                            % not default theta
            if size(theta,1)==1 & size(theta,2)==3                      % theta =[theta_start,theta_end,theta_pts]
            thetaseed=[theta(1):(theta(2)-theta(1))/(theta(3)-1):theta(2)].';
            [thetamesh,rmesh]=meshgrid(thetaseed,rseed);
            thetamesh=transpose(thetamesh);
            rmesh=transpose(rmesh);
            else                                                        % theta lines specified
                [thetamesh,rmesh]=meshgrid(theta,rseed);
                thetamesh=transpose(thetamesh);
                rmesh=transpose(rmesh);
            end
        end
    else                                                                % r lines specified
        if size(r,1)<size(r,2), r=r.'; end                              % make r columnar
        if defaulttheta==1                                              % default theta
            thetaseed=[0:1:360].'*pi/180;
            [thetamesh,rmesh]=meshgrid(thetaseed,r);
            thetamesh=transpose(thetamesh);
            rmesh=transpose(rmesh);
        else                                                            % not default theta
            if size(theta,1)==1 & size(theta,2)==3                      % theta =[theta_start,theta_end,theta_pts]
                thetaseed=[theta(1):(theta(2)-theta(1))/(theta(3)-1):theta(2)].';
                [thetamesh,rmesh]=meshgrid(thetaseed,r);
                thetamesh=transpose(thetamesh);
                rmesh=transpose(rmesh);
            else                                                        % theta lines specified
                [thetamesh,rmesh]=meshgrid(theta,r);                    % theta and r must be the same length
                thetamesh=transpose(thetamesh);
                rmesh=transpose(rmesh);
            end
        end   
    end
else                                                                 
    thetamesh = theta;                                                  % r and theta are already mesh grids
    rmesh=r;                                                            % (and are the same size)
end

[xmesh,ymesh]=pol2cart(thetamesh,rmesh);