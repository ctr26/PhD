function [varargout]=savefigure(fname,varargin)
%% Easy way of saving figures to publication friendly format
%
% Usage: [Args=]savefigure(name[,property,value,...])
%
% properties and default value
% 'Dpi',600,
% 'Size',[3.3 2.5]      inches
% 'FontSize',0          fontsize multiplier
% 'MinFontSize',8       minimum fontsize in pt
% 'LineWidth',.5        linewidth multiplier
% 'MinLineWidth',.5     minimum linewidth in pt
% 'MarkerSize',.5       markersize multiplier
% 'MinMarkerSize',3     minimum MarkerSize in pt
% 'Margins',[0 0 0 0]   [Left,Right,Top,Bottom] - can be used to set margins (relative units)
% .                     * When using automargins then this will be interpreted as additional margins
% .                     * when a single number is specified then it is used as a multiplier to the tight-inset used for auto margins.
% 'AutoMargins',true
% 'PrintOptions',''     (OBSOLETE! Use Format or file-extension instead)
% 'Format','png'        if not specified then it will be inferred from the filename
%
% AGU journals: Figures can be 20 picas wide or 41 picas wide and 58 picas deep.  That's
% 3.3 inches, 6.83, and 9.66.
%
% (C) Aslak Grinsted 2002-2004

global sf_UndoStack
sf_UndoStack={};

%CmPrInch=2.54;
f=gcf;


Args=struct('Dpi',600,...
    'Size',[3.3 2.5],  ...    %inches
    'FontSize',0,      ...    %fontsize multiplier
    'Margins',[0 0 0 0],...   %Left,Right,Top,Bottom - can be used to set margins (relative units)
    'LineWidth',.5,    ...    %linewidth multiplier
    'MarkerSize',.7,   ...    %markersize multiplier
    'MinFontSize',8,   ...    %minimum fontsize in pt
    'MinLineWidth',.5, ...    %minimum linewidth in pt
    'MinMarkerSize',3,  ...    %minimum MarkerSize in pt
    'BlackWhite',0, ...
    'AutoMargins',true, ...
    'Format','', ...
    'PrintOptions','' ...
    );

Args=parseArgs(varargin,Args,{'BlackWhite'});

Args.PrintOptions=regexp(Args.PrintOptions,'\s+','split');
Args.PrintOptions(cellfun(@isempty,Args.PrintOptions))=[];

Args.PrintOptions{end+1}=['-r' num2str(Args.Dpi)];

ismetaformat=false;
[pathstr,name,ext] = fileparts(fname); %#ok
ext=strrep(ext,'.','');
% idx=strfind(fname,'.');
% ext='';
% if length(idx)>0
%     ext=fname(idx(end)+1:end);
% end
if isempty(Args.Format)
    switch lower(ext)
        case 'png'
            Args.Format=lower(ext);
        case 'eps'
            if Args.BlackWhite
                Args.Format='eps';
            else
                Args.Format='epsc';
            end
        case {'jpeg','jpg'}
            Args.Format='jpeg';
        case 'svg'
            addpath('C:\Users\Aslak\Documents\MATLAB\Download\plot2svg');
            Args.Format='svg';
        case 'pdf'
            Args.Format='pdf';
            %              try
            %
            %                  delete(fname);
            %
            %                  drawnow
            %              catch
            %              end
        case 'emf'
            Args.Format='meta';
            ismetaformat=true;
        case {'tif' 'tiff'}
            Args.Format='tiff';
        case ''
            Args.Format='png';
        case 'svg'
            Args.Format='svg';
        otherwise
            Args.Format='png';
            warning('SAVEFIGURE:unknownExtension','unrecognized extension... assuming png')
    end
end

sfSet(0,'ShowHiddenHandles','on');
sfSet(f,'ResizeFcn',[]);
%sfSet(f,'Visible','off')
sfSet(f,'paperorientation','portrait');
sfSet(f,'PaperUnits','inches');
sfSet(f,'PaperPositionMode','manual');
sfSet(f,'PaperSize',Args.Size);
sfSet(f,'PaperPosition',[0 0 Args.Size])
% sfSet(f,'outerposition', [0 0 Args.Size])
% sfSet(f,'paperpositionmode', 'auto')
%if ismetaformat

%end

if Args.BlackWhite
    Cmap=colormap;
    Cmap=mean(Cmap,2); %make colormap b&w
    sfSet(f,'Colormap',[Cmap Cmap Cmap]);
end




%-------------GET LIST OF AXES CHILDREN AND SET AXIS DEFAULT FONT SIZE--------
%Hc=get(f,'children');


Hc=findobj(f,'type','axes');
Hcc=[];
for ii=1:length(Hc)
   
    switch lower(get(Hc(ii),'tag'))
        case {'legend' 'colorbar'} 
            h=copyobj(Hc(ii),f); %remove weird resizing of colorbars etc
            sfSet(Hc(ii),'Visible','off');
            Hc(ii)=h;
            sfSet(h,'tag','_SF_DELETE_THIS_'); %delete the copy when popping
    end

    sfSet(Hc(ii),'ActivePositionProperty','position');
    sfSet(Hc(ii),'Units','normalized');
    sfSet(Hc(ii),'fontsize',max(get(Hc(ii),'fontsize')*Args.FontSize,Args.MinFontSize));
    sfSet(Hc(ii),'DeleteFcn',[]);
    sfSet(Hc(ii),'CreateFcn',[]);
    HH=get(Hc(ii),'children');
    Hcc(end+(1:length(HH)))=HH(:);
end


%-------------SET CHILD OBJECT PROPERTIES (line size mm.)------------
for ii=1:length(Hcc)
    tp=get(Hcc(ii),'type');
    if strcmp(tp,'patch')
        sfSet(Hcc(ii),'linewidth',max(get(Hcc(ii),'linewidth')*Args.LineWidth,Args.MinLineWidth))
        if Args.BlackWhite
            c=get(Hcc(ii),'FaceVertexCData');
            if length(size(c))==3
                c=mean(c,3);
                c(:,:,[2 3])=c(:,:,[1 1]);
                sfSet(Hcc(ii),'FaceVertexCData',c);
            end
            try
                c=get(Hcc(ii),'FaceColor');
                c=mean(c);
                sfSet(Hcc(ii),'FaceColor',[c c c]);
            catch
                c=get(Hcc(ii),'EdgeColor');
                c=mean(c);
                sfSet(Hcc(ii),'EdgeColor',[c c c]);
            end
        end
    end
    if strcmp(tp,'line')
        sfSet(Hcc(ii),'linewidth',max(get(Hcc(ii),'linewidth')*Args.LineWidth,Args.MinLineWidth))
        sfSet(Hcc(ii),'markersize',max(get(Hcc(ii),'markersize')*Args.MarkerSize,Args.MinMarkerSize))
    end
    if strcmp(tp,'text')
        sfSet(Hcc(ii),'fontunits','points');
        sfSet(Hcc(ii),'fontsize',max(get(Hcc(ii),'fontsize')*Args.FontSize,Args.MinFontSize));
    end
    if strcmp(tp,'image')||strcmp(tp,'patch')
        if Args.BlackWhite
            c=get(Hcc(ii),'CData');
            if length(size(c))==3
                c=mean(im2double(c),3);
                c(:,:,[2 3])=c(:,:,[1 1]);
                sfSet(Hcc(ii),'CData',c);
            end
        end
    end
    if Args.BlackWhite
        try %#ok
            c=get(Hcc(ii),'Color');
            c=mean(c);
            sfSet(Hcc(ii),'Color',[c c c]);
        end
    end
end

%-------------CALCULATE CURRENT OUTERBOUNDS FOR AUTOMARGINS-----------
%sfSet(f,'activepositionproperty','position');
sfSet(f,'Units','inches');
pos=get(f,'position');
sfSet(f,'position',[pos(1:2) Args.Size]);

if Args.AutoMargins
    outerbounds=[2 2 -1 -1];
    posbounds=[2 2 -1 -1];
    for ii=1:length(Hc)
        if strcmpi(get(Hc(ii),'type'),'axes')
            ti=get(Hc(ii),'tightinset');
            ps=get(Hc(ii),'position');
            ps(3:4)=ps(1:2)+ps(3:4);
            
            
            op=[ps(1:2)-ti(1:2) ps(3:4)+ti(3:4)];
            
            %axes('position',[op(1:2) op(3:4)-op(1:2)],'color','none')
            outerbounds(1:2)=min(outerbounds(1:2),op(1:2));
            outerbounds(3:4)=max(outerbounds(3:4),op(3:4));
            posbounds(1:2)=min(posbounds(1:2),ps(1:2));
            posbounds(3:4)=max(posbounds(3:4),ps(3:4));
        end
    end
    ti=abs(outerbounds-posbounds); %effective tightinset
    if length(Args.Margins)==1
        ti=ti*Args.Margins;
        Args.Margins=[0 0 0 0];
    end
    %Args.Margins=[-outerbounds(1:2) outerbounds(3:4)-1];
    %s=solve('til=pbl*(1-ml-mr)+ml','1-tir=pbr*(1-ml-mr)+ml','ml,mr');
    %s.ml=-(pbl*tir-pbl+pbr*til)/(pbl-pbr)
    %s.mr=(pbl*tir+pbr*til-tir+1-til-pbr)/(pbl-pbr)
    Args.Margins([1 4])=Args.Margins([1 4])-(posbounds(1:2).*ti(3:4)-posbounds(1:2)+posbounds(3:4).*ti(1:2))./(posbounds(1:2)-posbounds(3:4));
    Args.Margins([2 3])=Args.Margins([2 3])+(posbounds(1:2).*ti(3:4)+posbounds(3:4).*ti(1:2)-ti(3:4)+1-ti(1:2)-posbounds(3:4))./(posbounds(1:2)-posbounds(3:4));
end


%-------------REPOSITION ALL AXES USING MARGINS-----------------------

WH=1-Args.Margins([2 4])-Args.Margins([1 3]); %convert to width,height;
for ii=1:length(Hc)
    if strcmpi(get(Hc(ii),'type'),'axes')%&&(~strcmpi(get(Hc(ii),'tag'),'legend'))&&(~strcmpi(get(Hc(ii),'tag'),'colorbar'))
        newpos=get(Hc(ii),'position');
        newpos([3 4])=newpos([3 4])+newpos([1 2]);
        newpos([1 3])=newpos([1 3])*WH(1)+Args.Margins(1);
        newpos([2 4])=newpos([2 4])*WH(2)+Args.Margins(4);
        newpos([3 4])=newpos([3 4])-newpos([1 2]);
        sfSet(Hc(ii),'ActivePositionProperty','position'); %other wise undo won't work...
        sfSet(Hc(ii),'units','normalized');
        sfSet(Hc(ii),'position',newpos);
    end
end


if strcmpi(Args.Format,'svg')
    plot2svg(fname);
else
    if ismetaformat
        %TODO: remove -r options from printoptions
    end
    Args.PrintOptions{end+1}=['-d' Args.Format];
    print(f,Args.PrintOptions{:},fname)
end

if strcmpi(ext,'eps')&&verLessThan('matlab', '8.4.0')
    replaceDottedLines(fname);
end

for ii=length(sf_UndoStack):-1:1
    if strcmp(sf_UndoStack{ii}.NewValue,'_SF_DELETE_THIS_')
        delete(sf_UndoStack{ii}.Handle)
    else
        set(sf_UndoStack{ii}.Handle,sf_UndoStack{ii}.Property,sf_UndoStack{ii}.Value);
    end
end

clear sf_UndoStack

if nargout>=1
    varargout{1}=Args;
end

function sfSet(H,prop,value)
global sf_UndoStack

sf_UndoStack{length(sf_UndoStack)+1}.Handle=H;
sf_UndoStack{length(sf_UndoStack)}.Property=prop;
sf_UndoStack{length(sf_UndoStack)}.Value=get(H,prop);
sf_UndoStack{length(sf_UndoStack)}.NewValue=value;
set(H,prop,value)





function replaceDottedLines(fname)
%
% MAKE EPS FILES BETTER
%

fid=fopen(fname,'r+');
fseek(fid,0,-1);
%load first block of data:
bytes=3000;
str=fread(fid,[1 bytes],'uint8=>char');
%ensure it ends with a newline
ix=strfind(str,sprintf('\r\n'));
ix=ix(end);
str(ix:end)=[];
bytes=length(str);

%replace line styles:
%/SO { [] 0 setdash } bdef
str=strrep(str,'/DO { [.5 dpi2point mul 4 dpi2point mul] 0 setdash } bdef','/DO { [.5 dpi2point mul 1 dpi2point mul] 0 setdash } bdef');
str=strrep(str,'/DA { [6 dpi2point mul] 0 setdash } bdef','/DA { [3 dpi2point mul] 0 setdash } bdef');
str=strrep(str,'/DD { [.5 dpi2point mul 4 dpi2point mul 6 dpi2point mul 4','/DD { [.5 dpi2point mul 2 dpi2point mul 3 dpi2point mul 2');

%make sure that str is still bytes long
while length(str)<bytes
    str(end+(1:2))=sprintf('\r\n');
end
while length(str)>bytes
    ix=strfind(str,sprintf('\r\n'));
    ix=ix(end);
    if isempty(ix)
        warning('SAVEFIGURE:noEpsLineStyleReplace','Couldn''t replace eps line styles!');
        fseek(fid,0,1);
        fclose(fid);
        return
    end
    str(ix)=[];
end

%write it
fseek(fid,0,-1);
fwrite(fid,str);
fseek(fid,0,1);
fclose(fid);
