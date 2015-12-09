%----------------------------------------------------------------------------------------------
% PROGRAM: recompose
% AUTHOR:  Andri M. Gretarsson
% DATE:    7/10/04
%
% SYNTAX: z=recompose(domain,type,coeffs,[q <,lambda,accuracy>]);
%           <...> indicates optional arguments
%
% Calculates the complex field amplitude resulting from summing the specified terms of 
% a Hermite or Laguerre Gaussian mode expansion.
%
% INPUT ARGUMENTS:
% ----------------    
% domain    = the domain over which to do the recomposition.  domain is a NxMx2 matrix
%             where domain(:,:,1) is the x mesh and domain(:,:,2) is the y mesh 
%            (or r mesh and theta mesh respectively in the case of a Laguerre Gaussian
%             mode expansion).
% type      = 'hg' for a Hermite Gaussian mode expansion, and 'lg' for a Laguerre
%             Gaussian mode expansion.
% coeffs    = the matrix of coefficients in the same form as returned by decompose.m
% q         = the complex radius of curvature "q" of the Gaussian basis.
% lambda    = wavelength of the light in the Gaussian basis. Default is 1.064 microns
% accuracy  = only calculate the coefficients of the decomposition to th
%             specified accuracy.   For example, if accuracy=0.3, then coeffs(i,j)= 1.4 
%             would be rounded to 1.3.
%
% OUTPUT ARGUMENTS:
% -----------------
% z(i,j) = Resultant complex field of the recomposed modes at over the domain.  
%
% Last updated: July 18, 2004 by AMG
%----------------------------------------------------------------------------------------------
%% SYNTAX: z=recompose(domain,type,coeffs,varargin);
%----------------------------------------------------------------------------------------------

function z=recompose(domain,type,coeffs,varargin);

z=zeros(size(domain(:,:,1)));
% HERMITE GAUSSIAN EXPANSION --------------------------------------------------------------------------   
if strcmp(lower(type),'hg')
    params=varargin{1};
    q=params(1);
    if length(params)>=2, lambda=params(2); else lambda=1.064e-6; end
    if length(params)>=3, accuracy=params(3); else accuracy=1e-4; end
    for s=1:size(coeffs,1)
        l=s-1;
        for t=1:size(coeffs,2)
            m=t-1;
            if abs(coeffs(s,t))>accuracy
                z=z+HermiteGaussianE([l,m,q,lambda,coeffs(s,t)],domain(:,:,1),domain(:,:,2));
            else
                coeffs(s,t)=0;
            end
        end
   end

% LAGUERRE GAUSSIAN EXPANSION --------------------------------------------------------------------------   
elseif strcmp(lower(type),'lg')
    params=varargin{1};
    q=params(1);
    if length(params)>=2, lambda=params(2); else lambda=1.064e-6; end
    if length(params)>=3, accuracy=params(3); else accuracy=1e-4; end
    for s=1:size(coeffs,1)
        p=s-1;
        for t=1:size(coeffs,2)
            m=t-1;
            if abs(coeffs(s,t,1))>accuracy
                z=z+LaguerreGaussianE([p,m,q,lambda,coeffs(s,t,1)],domain(:,:,1),domain(:,:,2));
            else
                coeffs(s,t,1)=0;
            end
        end
   end
    for s=1:size(coeffs,1)
        p=s-1;
        for t=2:size(coeffs,2)                                              % skip terms with m=0
            m=t-1;
            if abs(coeffs(s,t,2))>accuracy
                z=z+LaguerreGaussianE([p,-m,q,lambda,coeffs(s,t,2)],domain(:,:,1),domain(:,:,2));
            else
                coeffs(s,t,2)=0;
            end
        end
   end   
end