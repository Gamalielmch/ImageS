function varargout = qmmf(varargin)
% QMMF MATLAB code for qmmf.fig
%      QMMF, by itself, creates a new QMMF or raises the existing
%      singleton*.
%
%      H = QMMF returns the handle to a new QMMF or the handle to
%      the existing singleton*.
%
%      QMMF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QMMF.M with the given input arguments.
%
%      QMMF('Property','Value',...) creates a new QMMF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qmmf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qmmf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qmmf

% Last Modified by GUIDE v2.5 24-Oct-2016 10:50:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qmmf_OpeningFcn, ...
                   'gui_OutputFcn',  @qmmf_OutputFcn, ...
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


% --- Executes just before qmmf is made visible.
function qmmf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qmmf (see VARARGIN)

% Choose default command line output for qmmf
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
% UIWAIT makes qmmf wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = qmmf_OutputFcn(hObject, eventdata, handles) 
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
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global lambda
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   lambda=temp;
 end
set(hObject,'String',num2str(lambda));

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
global miu
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   miu=temp;
 end
set(hObject,'String',num2str(miu));

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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global ni
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   ni=temp;
 end
set(hObject,'String',num2str(ni));

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic medias sgm menu nm colm
set(handles.segment,'Enable','on')
[as,bs,~]=size(Ic);
axes(menu.mainax)
h = imfreehand;
wait(h);
bw=createMask(h);
% bw = roipoly;
s=regionprops(bw, 'PixelIdxList' );
Ic=double(Ic);
nm=nm+1;
medias(nm,1)=mean(mean(Ic( s.PixelIdxList(:))));
medias(nm,2)=mean(mean(Ic( s.PixelIdxList(:)+(as*bs))));
medias(nm,3)=mean(mean(Ic( s.PixelIdxList(:)+(2*as*bs))));
sgm(1,1,nm)=std(double(Ic(s.PixelIdxList(:))));
sgm(2,2,nm)=std(double(Ic(s.PixelIdxList(:)+(as*bs))));
sgm(3,3,nm)=std(double(Ic(s.PixelIdxList(:)+(2*as*bs))));
colm(nm,1:3)=uint8([medias(nm,1),medias(nm,2),medias(nm,3)]);
Ic=uint8(Ic);
set(qmmf,'Selected','on');
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic medias  sgm menu nm fore colm
set(handles.segment,'Enable','on')
[as,bs,~]=size(Ic);
axes(menu.mainax)
h = imfreehand;
wait(h);
bw=createMask(h);
s=regionprops(bw, 'PixelIdxList' );
Ic=double(Ic);
nm=nm+1;
medias(nm,1)=mean(mean(Ic( s.PixelIdxList(:))));
medias(nm,2)=mean(mean(Ic( s.PixelIdxList(:)+(as*bs))));
medias(nm,3)=mean(mean(Ic( s.PixelIdxList(:)+(2*as*bs))));
sgm(1,1,nm)=std(double(Ic(s.PixelIdxList(:))));
sgm(2,2,nm)=std(double(Ic(s.PixelIdxList(:)+(as*bs))));
sgm(3,3,nm)=std(double(Ic(s.PixelIdxList(:)+(2*as*bs))));
colm(nm,1:3)=uint8([medias(nm,1),medias(nm,2),medias(nm,3)]);
Ic=uint8(Ic);
set(qmmf,'Selected','on');
fore=[fore nm];
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic medias sgm menu nm back colm
set(handles.segment,'Enable','on')
[as,bs,~]=size(Ic);
axes(menu.mainax)
h = imfreehand;
wait(h);
bw=createMask(h);
s=regionprops(bw, 'PixelIdxList' );
Ic=double(Ic);
nm=nm+1;
medias(nm,1)=mean(mean(Ic( s.PixelIdxList(:))));
medias(nm,2)=mean(mean(Ic( s.PixelIdxList(:)+(as*bs))));
medias(nm,3)=mean(mean(Ic( s.PixelIdxList(:)+(2*as*bs))));
sgm(1,1,nm)=std(double(Ic(s.PixelIdxList(:))));
sgm(2,2,nm)=std(double(Ic(s.PixelIdxList(:)+(as*bs))));
sgm(3,3,nm)=std(double(Ic(s.PixelIdxList(:)+(2*as*bs))));
colm(nm,1:3)=uint8([medias(nm,1),medias(nm,2),medias(nm,3)]);
Ic=uint8(Ic);
set(qmmf,'Selected','on');
back=[back nm];

% --- Executes on button press in cleanmodels.
function cleanmodels_Callback(hObject, eventdata, handles)
% hObject    handle to cleanmodels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  medias sgm nm fore back Ic menu
set(handles.segment,'Enable','off')
axes(menu.mainax)
imshow(Ic)
medias=[];
sgm=[];
nm=0;
fore=[];
back=[];
set(qmmf,'Selected','on');
% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic medias sgm lambda miu nm ni  menu  mode_models fore  mask_models image_segmented
set(handles.text4,'Visible','on')
pause(0.1)
[nf,nc,~]=size(Ic);
sgmi=zeros(3,3,nm);
for i=1:nm
    sgmi(1:3,1:3,i)=inv(sgm(1:3,1:3,i));
end
image_segmented=uint8(zeros(nf,nc,3));

bpr=ones(nf,nc,nm)*(1/nm);
bpr=qmmftri(double(Ic),medias',sgmi,lambda,miu,bpr,ni,nm);
if mode_models==1
    mask_models=false(nf,nc,nm);
    for i=1:nf
        for j=1:nc
            [~,l]=max(bpr(i,j,:));
            mask_models(i,j,l)=1;
        end
    end
else
    mask_models=false(nf,nc,2);
    for i=1:nf
        for j=1:nc
            [~,l]=max(bpr(i,j,:));
            if ~isempty(find(fore==l, 1))
                mask_models(i,j,1)=1;
            else
                mask_models(i,j,2)=1;
            end
            
        end
    end
end


for i=1:size(mask_models,3)
    l=find(mask_models(:,:,i)==1);
    image_segmented(l)=mean(mean(Ic(l)));
    image_segmented(l+(nf*nc))=mean(mean(Ic(l+(nf*nc))));
    image_segmented(l+(2*nf*nc))=mean(mean(Ic(l+(2*nf*nc))));
end

axes(menu.mainax)
imshow(image_segmented)
set(handles.text4,'Visible','off')
set(handles.ok,'Enable','on')
set(qmmf,'Selected','on');
% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='ok';
close(qmmf)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(qmmf)

% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global mode_models
if (hObject==handles.radiobutton1) 
mode_models=1;
set(handles.pushbutton1,'Enable','on')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
else
mode_models=2;  
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','on')
set(handles.pushbutton3,'Enable','on')
end
