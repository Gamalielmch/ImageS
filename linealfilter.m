function varargout = linealfilter(varargin)
% LINEALFILTER MATLAB code for linealfilter.fig
%      LINEALFILTER, by itself, creates a new LINEALFILTER or raises the existing
%      singleton*.
%
%      H = LINEALFILTER returns the handle to a new LINEALFILTER or the handle to
%      the existing singleton*.
%
%      LINEALFILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LINEALFILTER.M with the given input arguments.
%
%      LINEALFILTER('Property','Value',...) creates a new LINEALFILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before linealfilter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to linealfilter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help linealfilter

% Last Modified by GUIDE v2.5 21-Oct-2016 12:32:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @linealfilter_OpeningFcn, ...
                   'gui_OutputFcn',  @linealfilter_OutputFcn, ...
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


% --- Executes just before linealfilter is made visible.
function linealfilter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to linealfilter (see VARARGIN)

% Choose default command line output for linealfilter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
global answe selec filt
set(handles.edit1,'String',num2str(answe(1)));
set(handles.edit2,'String',num2str(answe(2)));
selec=0;
if filt==1 || filt==4 ||  filt==5
    set(handles.edit2,'Enable','off');
end
if filt==4 ||  filt==5
    set(handles.edit1,'Enable','off');
end
if filt==6
    set(handles.text1,'String','Iterations:')
    set(handles.text2,'String','Time step(0-(dims)^-2):')
end
if filt==7
    set(handles.text1,'String','WindowSize(5,9,13,...(4*k+1) ):')
    set(handles.text2,'String','Empty:')
    set(handles.edit2,'Enable','off');
end
if filt==8
    set(handles.text1,'String','Width of spatial Gaussian')
    set(handles.text2,'String','Width of range Gaussian:')
end
% UIWAIT makes linealfilter wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = linealfilter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a
%        double}
global answe filt
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   answe(1)=temp;
 end
set(hObject,'String',num2str(answe(1)));
if filt==7
    if mod(answe(1),4)~=1
        answe(1)=5;
        set(hObject,'String',num2str(answe(1)))
    end
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global answe
temp=get(hObject,'String');
temp=str2double(temp);
 if isnan(temp)==0
   answe(2)=temp;
 end
set(hObject,'String',num2str(answe(2)));

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic menu answe filt type
set(handles.text4,'visible','on')
pause (0.01)
Ict=Ic;
switch filt
    case 1
        Ict=imfilter(Ic,fspecial('average',[answe(1) answe(1)]));
    case 2
        Ict=imfilter(Ic,fspecial('gaussian',[answe(1) answe(1)],answe(2)));
    case 3
        Ict=mat2gray(imfilter(Ic,fspecial('log',[answe(1) answe(1)],answe(2))));
    case 4
        Ict=imfilter(Ic,fspecial('prewitt'));
    case 5
        Ict=imfilter(Ic,fspecial('sobel'));
    case 6
        if strcmp(type,'rgb')
            for i=1:3
                Ict(:,:,i)=uint8(beltrami2D(double(Ic(:,:,i)), answe(1), answe(2)));
            end
        else
            Ict=uint8(beltrami2D(double(Ic), answe(1), answe(2)));
        end
    case 7
        if strcmp(type,'rgb')
            for i=1:3
                Ict(:,:,i)=uint8(Kuwahara(double(Ic(:,:,i)),answe(1)));
            end
        else
            Ict=uint8(Kuwahara(double(Ic),answe(1)));
        end
        
    otherwise
        Ict=Ic;
%         set(handles.text4,'Visible','on');
%         pause(0.1)
%         if strcmp(type,'rgb')
%             for i=1:3
%               Ict(:,:,i) =  bif(Ict(:,:,i),answe(1),answe(2));
%             end
%         else
%            Ict=bif(Ict,answe(1),answe(2));
%         end 
%         Ict=imresize(Ict,2);
%         set(handles.text4,'Visible','off');
end
set(handles.text4,'visible','of')
axes(menu.mainax)
imshow(Ict)
set(linealfilter,'Selected','on');
% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='ok';
set(handles.text4,'visible','on')
close(linealfilter)

% --- Executes on button press in cancel.
 function cancel_Callback(hObject, eventdata, handles)
% % hObject    handle to cancel (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(linealfilter)
