function varargout = editing(varargin)
% EDITING MATLAB code for editing.fig
%      EDITING, by itself, creates a new EDITING or raises the existing
%      singleton*.
%
%      H = EDITING returns the handle to a new EDITING or the handle to
%      the existing singleton*.
%
%      EDITING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITING.M with the given input arguments.
%
%      EDITING('Property','Value',...) creates a new EDITING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help editing

% Last Modified by GUIDE v2.5 07-Nov-2016 12:58:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @editing_OpeningFcn, ...
                   'gui_OutputFcn',  @editing_OutputFcn, ...
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


% --- Executes just before editing is made visible.
function editing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to editing (see VARARGIN)

% Choose default command line output for editing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
% UIWAIT makes editing wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global Ic  bwtemp sel 
[i_t,~]=imread('next2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.before,'CData',i_t);
[i_t,~]=imread('before2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.next,'CData',i_t);

axes(handles.axes1)
if ~isempty(Ic)
    Ict=Ic;
    peri=bwperim(bwtemp(:,:,sel));
    peri=find(peri==1);
    Ict(peri)=255;
    Ict(peri+(size(Ic,1)*size(Ic,2)))=0;
    Ict(peri+(2*size(Ic,1)*size(Ic,2)))=0;
    imshow(Ict)
else
    imshow(bwtemp(:,:,sel))
end

% --- Outputs from this function are returned to the command line.
function varargout = editing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in paint.
function paint_Callback(hObject, eventdata, handles)
% hObject    handle to paint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bwtemp sel Ic seleccion 
set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'off')
set(handles.text1,'Visible','on')
axes(handles.axes1)
if ~isempty(Ic)
    Ict=Ic;
    peri=bwperim(bwtemp(:,:,sel));
    peri=find(peri==1);
    Ict(peri)=255;
    Ict(peri+(size(Ic,1)*size(Ic,2)))=0;
    Ict(peri+2*(size(Ic,1)*size(Ic,2)))=0;
    imshow(Ict)
end
t=0;
pos=false(size(bwtemp(:,:,sel)));
while t==0
    h = imfreehand(gca);
    position = wait(h);
    if(isempty (position)==1 )
        t=1;
    else
        setColor(h,'yellow');
        pos =or(pos, createMask(h));
    end
end
if seleccion==0
    bwtemp(:,:,sel)=or(bwtemp(:,:,sel),pos);
else
    bwtemp(:,:,sel)=bwtemp(:,:,sel).*imcomplement(and(bwtemp(:,:,sel),pos));
end
axes(handles.axes1)
if ~isempty(Ic)
    Ict=Ic;
    peri=bwperim(bwtemp(:,:,sel));
    peri=find(peri==1);
    Ict(peri)=255;
    Ict(peri+(size(Ic,1)*size(Ic,2)))=0;
    Ict(peri+2*(size(Ic,1)*size(Ic,2)))=0;
    imshow(Ict)
else
    imshow(bwtemp(:,:,sel))
end
set(findall(handles.uipanel1, '-property', 'enable'), 'enable', 'on')
set(handles.text1,'Visible','off')
% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global seleccion 
if (hObject==handles.add)
    seleccion=0;
else
    seleccion=1;
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp  bwtemp  mask_models  menu sel
mask_models=bwtemp;
resp='cancel';
axes(menu.mainax)
imshow(mask_models(:,:,sel))
close(editing)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp   mask_models  menu sel
resp='cancel';
axes(menu.mainax)
imshow(mask_models(:,:,sel))
close(editing)


% --- Executes on button press in before.
function before_Callback(hObject, eventdata, handles)
% hObject    handle to before (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bwtemp sel Ic ya
ya=1;
if sel-1>0
    sel=sel-1;
end
axes(handles.axes1)
if ~isempty(Ic)
    Ict=Ic;
    peri=bwperim(bwtemp(:,:,sel));
    peri=find(peri==1);
    Ict(peri)=255;
    Ict(peri+(size(Ic,1)*size(Ic,2)))=0;
    Ict(peri+2*(size(Ic,1)*size(Ic,2)))=0;
    imshow(Ict)
else
    
    imshow(bwtemp(:,:,sel))
end

if any(ishandle(handles.before))   % Catch no handle and empty ObjH
    FigH = ancestor(handles.before, 'figure');
    % Work-around
    if strcmpi(get(handles.before, 'Type'), 'uicontrol')
        set(handles.before, 'Enable', 'off');
        drawnow;
        set(handles.before, 'Enable', 'on');
        pause(0.01);  % Give the re-enabled control a chance to be rendered
    end
    % Methods according to the documentation (does not move the focus for
    % keyboard events under Matlab 5.3, 6.5, 2008b, 2009a, 2011b, 2015b):
    figure(FigH);
    set(0, 'CurrentFigure', FigH);
end


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bwtemp sel Ic ya
ya=1;
lim=size(bwtemp,3);
if sel+1<=lim
    sel=sel+1;
end
axes(handles.axes1)
if ~isempty(Ic)
    Ict=Ic;
    peri=bwperim(bwtemp(:,:,sel));
    peri=find(peri==1);
    Ict(peri)=255;
    Ict(peri+(size(Ic,1)*size(Ic,2)))=0;
    Ict(peri+2*(size(Ic,1)*size(Ic,2)))=0;
    imshow(Ict)
else
    
    imshow(bwtemp(:,:,sel))
end

if any(ishandle(hObject))   % Catch no handle and empty ObjH
    FigH = ancestor(hObject, 'figure');
    % Work-around
    if strcmpi(get(hObject, 'Type'), 'uicontrol')
        set(hObject, 'Enable', 'off');
        drawnow;
        set(hObject, 'Enable', 'on');
        pause(0.01);  % Give the re-enabled control a chance to be rendered
    end
    % Methods according to the documentation (does not move the focus for
    % keyboard events under Matlab 5.3, 6.5, 2008b, 2009a, 2011b, 2015b):
    figure(FigH);
    set(0, 'CurrentFigure', FigH);
end
