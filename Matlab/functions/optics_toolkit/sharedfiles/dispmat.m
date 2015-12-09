%---------------------------------------------------------------
% Displays a numeric matrix in a more readable format than
% the one with which Matlab normally displays matrixes.
% If filename is specified, then the matrix is written to 
% a text file.  If specified, the format can be controlled
% via the format argument which has the same form as the
% FORMAT argument in sprintf.
%
% SYNTAX: dispmat(matrix <,filename,format,writeflag>);
%
%---------------------------------------------------------------
% SYNTAX: dispmat(matrix<,format,filename,writeflag>);
%---------------------------------------------------------------

function dispmat(matrix,varargin);

errorstate=0;
if nargin==1
    disp(num2str(matrix));
end
if nargin>=4, writeflag=varargin{3}; else   writeflag='w'; end
        
if nargin>=3
    filename=varargin{2};
    fid=fopen(filename,writeflag);
    if ~isempty(varargin{1})
        format=varargin{1};         
        for s=1:size(matrix,1)
            matrow=num2str(matrix(s,:),format);
            fprintf(fid,'%s\n',matrow);
        end    
    else
        for s=1:size(matrix,1)
            matrow=num2str(matrix(s,:));
            fprintf(fid,'%s\n',matrow);
        end     
    end
    fclose(fid);
    errorstate=fid;
end

if nargin==2
    format=varargin{1};         
    for s=1:size(matrix,1)
        matrow=num2str(matrix(s,:),format);
        fprintf('%s\n',matrow);
        end    
    end
end

    
