function varargout = resizeg(varargin)
% RESIZEG MATLAB code for resizeg.fig
%      RESIZEG, by itself, creates a new RESIZEG or raises the existing
%      singleton*.
%
%      H = RESIZEG returns the handle to a new RESIZEG or the handle to
%      the existing singleton*.
%
%      RESIZEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESIZEG.M with the given input arguments.
%
%      RESIZEG('Property','Value',...) creates a new RESIZEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resizeg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resizeg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resizeg

% Last Modified by GUIDE v2.5 29-Sep-2017 13:07:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resizeg_OpeningFcn, ...
                   'gui_OutputFcn',  @resizeg_OutputFcn, ...
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


% --- Executes just before resizeg is made visible.
function resizeg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resizeg (see VARARGIN)

% Choose default command line output for resizeg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
% UIWAIT makes resizeg wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global resiz trac
if trac==1
set(handles.x,'String',num2str(resiz(2)))
set(handles.y,'String',num2str(resiz(1)))
set(handles.xn,'String',num2str(resiz(2)))
set(handles.yn,'String',num2str(resiz(1)))
set (handles.slider1,'value',1)
trac=0;
end
% --- Outputs from this function are returned to the command line.
function varargout = resizeg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editx_Callback(hObject, eventdata, handles)
% hObject    handle to editx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editx as text
%        str2double(get(hObject,'String')) returns contents of editx as a double



function y_Callback(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y as text
%        str2double(get(hObject,'String')) returns contents of y as a double


% --- Executes during object creation, after setting all properties.
function y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global resiz xnew ynew
coef=get(hObject,'value');
ynew=round(resiz(1)*coef);
xnew=round(resiz(2)*coef);
set(handles.xn,'String',num2str(xnew))
set(handles.yn,'String',num2str(ynew))

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xnew ynew menu Ic mask_models sel
axes(menu.mainax)
if ~isempty(Ic)
imshow(imresize(Ic,[ynew,xnew]))
else
  imshow(imresize(mask_models(:,:,sel),[ynew,xnew]))  
end
set(resizeg,'Selected','on');

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='ok';
close(resizeg)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(resizeg)

function xn_Callback(hObject, eventdata, handles)
% hObject    handle to xn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xn as text
%        str2double(get(hObject,'String')) returns contents of xn as a double
global xnew
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
     if temp>0
   xnew=temp;
     end
 end
set(hObject,'String',num2str(xnew));

% --- Executes during object creation, after setting all properties.
function xn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yn_Callback(hObject, eventdata, handles)
% hObject    handle to yn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yn as text
%        str2double(get(hObject,'String')) returns contents of yn as a double
global ynew
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
     if temp>0
   ynew=temp;
     end
 end
set(hObject,'String',num2str(ynew));

% --- Executes during object creation, after setting all properties.
function yn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x as text
%        str2double(get(hObject,'String')) returns contents of x as a double
