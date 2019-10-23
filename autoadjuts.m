function varargout = autoadjuts(varargin)
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

% Last Modified by GUIDE v2.5 05-Jun-2017 09:54:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autoadjuts_OpeningFcn, ...
                   'gui_OutputFcn',  @autoadjuts_OutputFcn, ...
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
function autoadjuts_OpeningFcn(hObject, eventdata, handles, varargin)
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

% --- Outputs from this function are returned to the command line.
function varargout = autoadjuts_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  menu Ic type
set(handles.text7,'Visible','on')
pause(0.01)
set(autoadjuts,'Selected','on');
axes(menu.mainax)
if strcmp(type,'rgb')
    
    
    cform2lab = makecform('srgb2lab');
    LAB = applycform(double(Ic)/256, cform2lab);
    
    % Scale values to range from 0 to 1
    L = LAB(:,:,1)/100;
    
    % Perform CLAHE
    LAB(:,:,1) = adapthisteq(L,'NumTiles',...
        [8 8],'ClipLimit',0.005)*100;
    
    % Convert back to RGB color space
    cform2srgb = makecform('lab2srgb');
    imshow( uint8(applycform(LAB, cform2srgb)*256));
else
    imshow(imadjust(Ic));
end
set(handles.text7,'Visible','off')
set(autoadjuts,'Selected','on');

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='ok';
set(handles.text7,'Visible','on')
pause(0.01)
set(autoadjuts,'Selected','on');
close(autoadjuts)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(autoadjuts)
