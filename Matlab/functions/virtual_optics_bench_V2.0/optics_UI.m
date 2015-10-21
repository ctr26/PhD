function varargout = optics_UI(varargin)
% OPTICS_UI MATLAB code for optics_UI.fig
%      OPTICS_UI, by itself, creates a new OPTICS_UI or raises the existing
%      singleton*.
%
%      H = OPTICS_UI returns the handle to a new OPTICS_UI or the handle to
%      the existing singleton*.
%
%      OPTICS_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTICS_UI.M with the given input arguments.
%
%      OPTICS_UI('Property','Value',...) creates a new OPTICS_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before optics_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optics_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optics_UI

% Last Modified by GUIDE v2.5 16-Feb-2013 01:20:02

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optics_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @optics_UI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before optics_UI is made visible.
function optics_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optics_UI (see VARARGIN)

% Choose default command line output for optics_UI
handles.output = hObject;
handles.history=[];
handles.lambda=532;
handles.resolution_v=2048;
handles.oldresolution=2048;
handles.oldrange=6;
handles.undorange=6;
handles.undores=2048;
handles.range_v=6; %mm
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes optics_UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = optics_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in go_create.
function go_create_Callback(hObject, eventdata, handles)
% hObject    handle to go_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.gauss_h=hObject;

w0=handles.w0;
z1=handles.z1;
lambda=handles.lambda; %nm
res=handles.resolution_v; 
range=handles.range_v;
handles.oldresolution=res;
handles.oldrange=range;
handles.undores=res;
handles.undorange=range;
u1=create_gaussian(lambda,res,range,w0,z1);
handles.u1=u1;
handles.u_new=u1;
str_history=['beam start  [w0=' num2str(w0) '; z1=' num2str(z1) ']'];
new_history=cellstr(str_history);
handles.history=new_history;

plot_u1(handles)
guidata(hObject,handles);




function w0_Callback(hObject, eventdata, handles)
% hObject    handle to w0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w0 as text
%        str2double(get(hObject,'String')) returns contents of w0 as a double

w0=str2double(get(hObject,'String'));
handles.w0=w0;
guidata(hObject,handles);





% --- Executes during object creation, after setting all properties.
function w0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cg_dist_Callback(hObject, eventdata, handles)
% hObject    handle to cg_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cg_dist as text
%        str2double(get(hObject,'String')) returns contents of cg_dist as a double


z1=str2double(get(hObject,'String'));
handles.z1=z1;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function cg_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cg_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over go_create.
function go_create_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to go_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function lens_fl_Callback(hObject, eventdata, handles)
% hObject    handle to lens_fl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lens_fl as text
%        str2double(get(hObject,'String')) returns contents of lens_fl as a double

fl=str2double(get(hObject,'String'));
handles.lens_fl=fl;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function lens_fl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lens_fl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lens_zdist_Callback(hObject, eventdata, handles)
% hObject    handle to lens_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lens_zdist as text
%        str2double(get(hObject,'String')) returns contents of lens_zdist as a double

zdist=str2double(get(hObject,'String'));
handles.lens_zdist=zdist;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function lens_zdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lens_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lens.
function lens_Callback(hObject, eventdata, handles)
% hObject    handle to lens (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zdist=handles.lens_zdist;
fl=handles.lens_fl;
u0=handles.u_new;
lambda=handles.lambda;
handles.u1=u0;
res=handles.resolution_v; 
range=handles.range_v;
u_new=lens_prop(lambda,res,range,u0, zdist,fl);
handles.u_new=u_new;

cur_history=handles.history;
str_history=['lens  [fl=' num2str(fl) '; z=' num2str(zdist) ']'];
new_history=[cur_history;str_history];
handles.history=new_history;

plot_u1(handles)
guidata(hObject,handles)



function prop_zdist_Callback(hObject, eventdata, handles)
% hObject    handle to prop_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prop_zdist as text
%        str2double(get(hObject,'String')) returns contents of prop_zdist as a double

zdist=str2double(get(hObject,'String'));
handles.prop_zdist=zdist;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function prop_zdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prop.
function prop_Callback(hObject, eventdata, handles)
% hObject    handle to prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zdist=handles.prop_zdist;
u0=handles.u_new;
lambda=handles.lambda;
handles.u1=u0;
res=handles.resolution_v; 
range=handles.range_v;
u_new=prop(lambda,res,range,u0, zdist);
handles.u_new=u_new;

cur_history=handles.history;
str_history=['prop  [z=' num2str(zdist) ']'];
new_history=[cur_history;str_history];
handles.history=new_history;

plot_u1(handles)
guidata(hObject,handles)



function ap_radius_Callback(hObject, eventdata, handles)
% hObject    handle to ap_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ap_radius as text
%        str2double(get(hObject,'String')) returns contents of ap_radius as a double
r=str2double(get(hObject,'String'));
handles.ap_radius=r;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ap_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ap_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in aperture.
function aperture_Callback(hObject, eventdata, handles)
% hObject    handle to aperture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zdist=handles.ap_zdist;
r=handles.ap_radius;
lambda=handles.lambda;

u0=handles.u_new;
handles.u1=u0;
res=handles.resolution_v; 
range=handles.range_v;
u_new=aperture(lambda, res,range,u0, r,zdist);
handles.u_new=u_new;

cur_history=handles.history;
str_history=['aperture  [rad=' num2str(r) '; z=' num2str(zdist) ']'];
new_history=[cur_history;str_history];
handles.history=new_history;

plot_u1(handles)
guidata(hObject,handles)


function ap_zdist_Callback(hObject, eventdata, handles)
% hObject    handle to ap_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ap_zdist as text
%        str2double(get(hObject,'String')) returns contents of ap_zdist as a double
zdist=str2double(get(hObject,'String'));
handles.ap_zdist=zdist;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ap_zdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ap_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function optical_vortex_l_Callback(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text as text
%        str2double(get(hObject,'String')) returns contents of text as a double
l=str2double(get(hObject,'String'));
handles.optical_vortex_l=l;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function optical_vortex_l_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optical_vortex_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in optical_vortex.
function optical_vortex_Callback(hObject, eventdata, handles)
% hObject    handle to optical_vortex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zdist=handles.optical_vortex_zdist;
l=handles.optical_vortex_l;
lambda=handles.lambda;

u0=handles.u_new;
handles.u1=u0;
res=handles.resolution_v; 
range=handles.range_v;
u_new=vortex_plate_prop(lambda, res,range,u0,zdist,l);
handles.u_new=u_new;

cur_history=handles.history;
str_history=['vortex plate  [l=' num2str(l) '; z=' num2str(zdist) ']'];
new_history=[cur_history;str_history];
handles.history=new_history;

plot_u1(handles)
guidata(hObject,handles)


function optical_vortex_zdist_Callback(hObject, eventdata, handles)
% hObject    handle to optical_vortex_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of optical_vortex_zdist as text
%        str2double(get(hObject,'String')) returns contents of optical_vortex_zdist as a double
zdist=str2double(get(hObject,'String'));
handles.optical_vortex_zdist=zdist;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function optical_vortex_zdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optical_vortex_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function axicon_angle_Callback(hObject, eventdata, handles)
% hObject    handle to axicon_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of axicon_angle as text
%        str2double(get(hObject,'String')) returns contents of axicon_angle as a double
g=str2double(get(hObject,'String'));
handles.axicon_angle=g;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function axicon_angle_CreateFcn(hObject, eventdata, ~)
% hObject    handle to axicon_angle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axicon.
function axicon_Callback(hObject, eventdata, handles)
% hObject    handle to axicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zdist=handles.axicon_zdist;
g=handles.axicon_angle;
lambda=handles.lambda;

u0=handles.u_new;
handles.u1=u0;
res=handles.resolution_v; 
range=handles.range_v;
u_new= axicon_prop(lambda, res,range,u0, zdist,g);
handles.u_new=u_new;

cur_history=handles.history;
str_history=['axicon  [g=' num2str(g) '; z=' num2str(zdist) ']'];
new_history=[cur_history;str_history];
handles.history=new_history;

plot_u1(handles)
guidata(hObject,handles)



function axicon_zdist_Callback(hObject, eventdata, handles)
% hObject    handle to axicon_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of axicon_zdist as text
%        str2double(get(hObject,'String')) returns contents of axicon_zdist as a double
zdist=str2double(get(hObject,'String'));
handles.axicon_zdist=zdist;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function axicon_zdist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axicon_zdist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in startover.
function startover_Callback(hObject, eventdata, handles)
% hObject    handle to startover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
go_create_h=handles.gauss_h;
go_create_Callback(go_create_h, eventdata, handles)




% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
u1=handles.u1;
u_new=handles.u_new;


if all(size(u_new)==size(u1))
    if u_new==u1
    else
    handles.u_new=u1;
    cur_history=handles.history;
    last_h=char(cur_history(end));
    la=strfind(last_h,'resample');
    
    if length(cur_history) > 1
    cur_history(end)=[];
    handles.history=cur_history;
    else
    end
    
    if isempty(la)  %means last op was not resample       
    else

        oldres=handles.undores;
        oldrange=handles.undorange;
        
        handles.oldresolution=oldres;
        handles.oldrange=oldrange;
        handles.resolution_v=oldres;
        handles.range_v=oldrange;
        set(handles.range, 'String', num2str(oldrange))
        set(handles.resolution, 'String', num2str(oldres))
    end
    
    
    plot_u1(handles)
    end
else
    handles.u_new=u1;
    cur_history=handles.history;
    last_h=char(cur_history(end));
    la=strfind(last_h,'resample');
    
    if length(cur_history) > 1
    cur_history(end)=[];
    handles.history=cur_history;
    else
    end
    
    if isempty(la)  %means last op was not resample       
    else

        oldres=handles.undores;
        oldrange=handles.undorange;
        
        handles.oldresolution=oldres;
        handles.oldrange=oldrange;
        handles.resolution_v=oldres;
        handles.range_v=oldrange;
        set(handles.range, 'String', num2str(oldrange))
        set(handles.resolution, 'String', num2str(oldres))
    end
    plot_u1(handles)
end
guidata(hObject,handles)


% --- Executes on selection change in history.
function history_Callback(hObject, eventdata, handles)
% hObject    handle to history (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns history contents as cell array
%        contents{get(hObject,'Value')} returns selected item from history


% --- Executes during object creation, after setting all properties.
function history_CreateFcn(hObject, eventdata, handles)
% hObject    handle to history (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.listbox_h=hObject;
guidata(hObject,handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wavelength as text
%        str2double(get(hObject,'String')) returns contents of wavelength as a double
lambda=str2double(get(hObject,'String')); %nm
handles.lambda=lambda;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function wavelength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function range_Callback(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of range as text
%        str2double(get(hObject,'String')) returns contents of range as a double
range=str2double(get(hObject,'String')); %nm
handles.range_v=range;

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resolution_Callback(hObject, eventdata, handles)
% hObject    handle to resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolution as text
%        str2double(get(hObject,'String')) returns contents of resolution as a double
resolution=str2double(get(hObject,'String')); %nm
handles.resolution_v=resolution;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resamplebutton.
function resamplebutton_Callback(hObject, eventdata, handles)
% hObject    handle to resamplebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


u0=handles.u_new;
handles.u1=u0;
oldres=handles.oldresolution;
oldrange=handles.oldrange;
res=handles.resolution_v;
range=handles.range_v;
u_new=resample(u0,oldres,oldrange,res,range);
handles.u_new=u_new;

cur_history=handles.history;
str_history=['resample  [n=' num2str(res) '; rg=' num2str(range) ']'];
new_history=[cur_history;str_history];
handles.history=new_history;

handles.undorange=oldrange;
handles.undores=oldres;
handles.oldrange=range;
handles.oldresolution=res;

plot_u1(handles)
guidata(hObject,handles)
