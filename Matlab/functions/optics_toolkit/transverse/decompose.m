%----------------------------------------------------------------------------------------------
% PROGRAM: decompose
% AUTHOR:  Andri M. Gretarsson
% DATE:    7/10/04
%
% SYNTAX: [coeffs,tmat]=decompose(z1,domain,type,terms,[q <,lambda,accuracy>]);
%           <...> indicates optional arguments
%
% Calculates the coefficients of the decomposition of the function z1 into
% Hermite Gaussian modes or Laguerre Gaussian modes.
%
% INPUT ARGUMENTS:
% ----------------
% z1        = The values of the function to be decomposed. 2D (nxn) matrix
% domain    = the domain values at which the values in z1 are specified. 
%             The domain is a nxmx2 array where domain(:,:,1) and
%             domain(:,:,2) are the x and y meshes corresponding to the
%             values in z1. (These meshes are often generated using meshgrid.m.)
% type      = 'hg' for a Hermite Gaussian mode decomposition
%             'lg' for a Laguerre Gaussian mode decomposition
% terms     = This argument can be specified either as a scalar or as a matrix.
%              If it is specified as a scalar,  it indicates the number of
%              terms out to which to calculate the decomposition.  Since the
%              Hermite and Laguerre bases are two dimensional and are specified
%              by a 2D argument (l,m) or (p,m), default rules are applied to
%              decide exactly which terms to calculate. The output  
%              matrix tmat indicates what terms were calculated. 
%
%              When terms is specified as a matrix, it indicates exactly which
%              terms to calculate. For Hermite Gaussian modes (type='hg')
%              terms is a LxM matrix where a 1 in the (i,j)th entry indicates
%              that the term TEM(l,m)=(i-1,j-1) will be calculated. A zero 
%              indicates it will not be calculated.  For example:
%
%                         1 0 0 
%              terms  =   0 1 0   
%                         0 1 0
%
%              indicates that the coefficients of the Hermite Gaussian modes 
%              (0,0), (1,1) and (2,1) will be calculated but no others.
%             
%              For Laguerre Gaussian modes (type='lg') the terms matrix is
%              interpreted similarly.  However, since the (p,m) mode can
%              have either positive or negative m terms the  terms matrix is now 
%              a PxMx2 matrix, where terms(:,:,1) indicates which positive-m
%              terms to calculate and terms(:,:,2) indicates which negative-m
%              terms to calculate.  However, note that since m=0 must not
%              be duplicated, the first column in terms(:,:,2) is always zero.
%              Thus for example:
%
%                              1 0 0
%              terms(:,:,1) =  0 1 0
%                              0 1 0
% 
%                              0 0 0
%              terms(:,:,2) =  0 1 0
%                              0 1 1
%
%              indicates that the coefficients of the Laguerre Gaussian modes
%              (0,0), (1,1), (2,1), (1,-1), (2,-1) and (2,-2) will be calculated.
%                 
% q         = the complex radius of curvature "q" of the Gaussian basis.
% lambda    = wavelength of the light in the Gaussian basis. Default is 1.064 microns
% accuracy  = only calculate the coefficients of the decomposition to the
%             specified accuracy.   Actually rounds each result to the nearest 
%             increment of accuracy.  For example, if accuracy=0.3, then a coefficient 
%             of 1.54 would be rounded to 1.5 while a coefficient of 1.56 would be 
%             rounded to 1.8.  Accuracy of 0 applies no rounding.  Specifying
%             accuracy other than "0" does not speed up the calculation.
%
% OUTPUT ARGUMENTS:
% -----------------
% coeffs    = the coefficients of the terms in the expansion. coeffs is a matrix
%             the same size a tmat.
% tmat      = coefficient request matrix.  Often this would be specified by the user
%             by the input argument "terms", in other words tmat=terms. However, as explained
%             under the definition of the input argument terms, this function 
%             allows the user to specify only how many terms he wants, in other words terms can be
%             a scalar and not a matrix.  In this case tmat must be calculated according to 
%             default rules.  In this case it is convenient to have the terms request matrix  
%             as an output argument. Each entry in the coefficient request matrix tmat correspond 
%             to a particular term of the expansion (as explained above).  If the tmat(i,j) is 1, 
%             the coefficient of that term is calculated and returned in coeffs(i,j).  If tmat(i,j)  
%             is 0, the corresponding coefficient was not calculated and coeffs(i,j) is set to 0 
%             regardless of whether the contribution of that term to z1 is really zero.
% 
% EXAMPLE 1 (Hermite Gaussian, only number of terms specified):
%       [x,y]=meshgrid([-pi/2:0.1:pi/2],[-pi/2:0.1:pi/2]); z1=cos(sqrt(x.^2+y.^2));
%       clear domain; domain(:,:,1)=x; domain(:,:,2)=y;
%       w=pi/4; R=1e3; lambda=1e-6; q=(1./R - i* lambda./pi./w.^2).^(-1);
%       [coeffs,tmat]=decompose(z1,domain,'hg',140,[q,lambda,1e-6])
%       z1recomposed=recompose(domain,'hg',coeffs,[q,lambda,1e-6]);
%       subplot(3,1,1); h=pcolor(x,y,abs(z1).^2); set(h,'EdgeColor','none'); axis square; colorbar
%       subplot(3,1,2); h=pcolor(x,y,abs(z1recomposed).^2); set(h,'EdgeColor','none'); axis square; colorbar
%       subplot(3,1,3); h=pcolor(x,y,abs(z1).^2-abs(z1recomposed).^2); set(h,'EdgeColor','none'); axis square; colorbar; shg;
%
% Last updated: July 18, 2004 by AMG
%----------------------------------------------------------------------------------------------
% SYNTAX: [coeffs,tmat]=decompose(z1,domain,type,terms,[q <,lambda,accuracy>]);
%----------------------------------------------------------------------------------------------
function [coeffs,tmat]=decompose(z1,domain,type,terms,varargin);

% HERMITE GAUSSIAN EXPANSION --------------------------------------------------------------------------
if strcmp(lower(type),'hg')
    params=varargin{1};
    q=params(1);
    if length(params)>=2, lambda=params(2); else lambda=1.064e-6; end
    if length(params)>=3, accuracy=params(3); else accuracy=1e-4; end
    if size(terms,1)==1 & size(terms,2)==1                                  % Make terms request matrix
       n=ceil(sqrt(terms));
       tmat=ones(n,n);
       if n^2>terms
           tmat(end,end-ceil((n^2-terms)/2)+1:end)=0;
           tmat(end-floor((n^2-terms)/2):end-1,end)=0;       
       end
   else
       tmat=terms;
   end
    coeffs=zeros(size(tmat));
    for s=1:size(tmat,1)                                                    % Calculate the coefficients
        l=s-1;
        for t=1:size(tmat,2)
            m=t-1;
            if tmat(s,t)==1 
                z2=HermiteGaussianE([l,m,q,lambda],domain(:,:,1),domain(:,:,2));
                coeffs(s,t)=overlap(z1,conj(z2),domain,1,accuracy);
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
    if size(terms,1)==1 & size(terms,2)==1                                  % Make terms request matrix
       n=ceil( (1+sqrt(1+8*terms))/4 );
       tmat=ones(n,n,2); tmat(:,1,2)=0;
       ndiff=2*n^2-n-terms;
       if ndiff>0
           rdiff=ceil(ndiff/2); ldiff=floor(ndiff/2);
           tmat(end,end-ceil(rdiff/2)+1:end,1)=0;
           tmat(end-floor(rdiff/2):end-1,end,1)=0;       
           tmat(end,end-ceil(ldiff/2)+1:end,2)=0;
           tmat(end-floor(ldiff/2):end-1,end,2)=0;  
       end
       %disp(' '); dispmat(tmat(:,:,1)); disp(' '); dispmat(tmat(:,:,2)); disp(' '); disp(num2str(sum(sum(sum(tmat)))));
   else
       tmat=terms;
   end
    clear coeffs;
    coeffs(:,:,1)=zeros(size(tmat,1),size(tmat,2));
    coeffs(:,:,2)=zeros(size(tmat,1),size(tmat,2));
    for s=1:size(tmat,1)                                                    % Calculate the coefficients
        p=s-1;
        for t=1:size(tmat,2)
            m=t-1;
            if tmat(s,t,1)==1                                               % coeff requested
                z2=LaguerreGaussianE([p,m,q,lambda],domain(:,:,1),domain(:,:,2),'pol');
                coeffs(s,t,1)=overlap(z1,conj(z2),domain,domain(:,:,1),accuracy);
            else
                coeffs(s,t,1)=0;
            end
            if tmat(s,t,2)==1                                               % coeff requested 
                z2=LaguerreGaussianE([p,-m,q,lambda],domain(:,:,1),domain(:,:,2),'pol');
                coeffs(s,t,2)=overlap(z1,conj(z2),domain,domain(:,:,1),accuracy);
            else
                coeffs(s,t,2)=0;
            end            
        end
   end
end