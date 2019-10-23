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

% Last Modified by GUIDE v2.5 08-Nov-2016 16:16:49

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
[i_t,~]=imread('next2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.before,'CData',i_t);
[i_t,~]=imread('before2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.next,'CData',i_t);

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
global resp  mask_models  menu sel ur
mask_models=ur;
resp='ok';
axes(menu.mainax)
imshow(mask_models(:,:,sel))
close(activecontour)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp menu 
resp='cancel';
axes(menu.mainax)
close(activecontour)


% --- Executes on button press in before.
function before_Callback(hObject, eventdata, handles)
% hObject    handle to before (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sel ya menu ur Ic
ya=1;
if sel-1>0
    sel=sel-1;
end
if get(handles.radiobutton4, 'Value') && ~isempty(Ic)
axes(menu.mainax), imshow(mat2gray(Ic));
hold on; contour(ur(:,:,sel),[0,0],'r'); hold off; drawnow;      
else
axes(menu.mainax), imshow((ur(:,:,sel)));
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
global ur sel menu Ic
lim=2;
if sel+1<=lim
    sel=sel+1;
end
if get(handles.radiobutton4, 'Value') && ~isempty(Ic)
axes(menu.mainax), imshow(mat2gray(Ic));
hold on; contour(ur(:,:,sel),[0,0],'r'); hold off; drawnow;      
else
axes(menu.mainax), imshow((ur(:,:,sel)));
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


function regions_Callback(hObject, eventdata, handles)
% hObject    handle to regions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regions as text
%        str2double(get(hObject,'String')) returns contents of regions as a double
global i_regions
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   i_regions=temp;
 end
set(hObject,'String',num2str(i_regions));

% --- Executes during object creation, after setting all properties.
function regions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic u  i_regions menu
[m,n,~]=size(Ic);
u=false(m,n);
axes(menu.mainax)
for i=1:i_regions
    h = imfreehand;
    wait(h);
    u2=createMask(h);
    %u2=roipoly(mat2gray(Ic));
    u=or(u,u2);
end
hold on; contour(u,[0,0],'r'); hold off; drawnow; 
set(activecontour,'Selected','on');

function iter_Callback(hObject, eventdata, handles)
% hObject    handle to iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iter as text
%        str2double(get(hObject,'String')) returns contents of iter as a double
global ni
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   ni=temp;
 end
set(hObject,'String',num2str(ni));

% --- Executes during object creation, after setting all properties.
function iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function internal_Callback(hObject, eventdata, handles)
% hObject    handle to internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of internal as text
%        str2double(get(hObject,'String')) returns contents of internal as a double
global force
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   force(1)=temp;
 end
set(hObject,'String',num2str(force(1)));

% --- Executes during object creation, after setting all properties.
function internal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to internal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function external_Callback(hObject, eventdata, handles)
% hObject    handle to external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of external as text
%        str2double(get(hObject,'String')) returns contents of external as a double
global force
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   force(2)=temp;
 end
set(hObject,'String',num2str(force(2)));

% --- Executes during object creation, after setting all properties.
function external_CreateFcn(hObject, eventdata, handles)
% hObject    handle to external (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in breake.
function breake_Callback(hObject, eventdata, handles)
% hObject    handle to breake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ic u ni  H ur force menu  image_segmented
H = uicontrol('Style', 'PushButton', ...
    'String', 'Break', ...
    'Callback', 'delete(gcbo)');
set(H,'units', 'normalized','position',[0.716 0.384 0.236  0.095])
axes(menu.mainax)
val=get(handles.radiobutton3,'Value');
set(handles.text19,'Visible','on')
set(handles.text18,'Visible','on')
pause(0.001)
set(activecontour,'Selected','on');
if size(Ic,3)>1
    [m,n,~]=size(Ic);
    ur = bwdist(1-u)- bwdist(u);
    ur = 0.4*ur;
    ep=2.1;
    dt=2.5;%dt=0.8;
    a=0.1;
    i=0;
    I1=double(Ic(:,:,1));
    I2=double(Ic(:,:,2));
    I3=double(Ic(:,:,3));
    
    while ishandle(H)
        if i>=ni
            delete(H)
            pause(1)
            break
        end
        %curva
        ci1=sum(sum(I1(ur>=0))) /  length(ur(ur>=0));
        ci2=sum(sum(I2(ur>=0))) /  length(ur(ur>=0));
        ci3=sum(sum(I3(ur>=0))) /  length(ur(ur>=0));
        co1=sum(sum(I1(ur<0))) / length(ur(ur<0));
        co2=sum(sum(I2(ur<0))) / length(ur(ur<0));
        co3=sum(sum(I3(ur<0))) / length(ur(ur<0));
        del= ep./(pi.* (ep^2 + ur.^2));
        
        %derivadas
        ux=(ur(:,[2:n,n])-ur(:,[1,1:n-1]))/2;
        uy=(ur([2:m,m],:)-ur([1,1:m-1],:))/2;
        
        uxx=ur(:,[2:n,n])-2*ur+ur(:,[1,1:n-1]);
        uyy=ur([2:m,m],:)-2*ur+ur([1,1:m-1],:);
        uxy= (ur([2:m,m],[2:n,n]) + ur([1,1:m-1],[1,1:n-1]) ...
            -ur([1,1:m-1],[2:n,n]) - ur([2:m,m],[1,1:n-1]) ) /4;
        
        %minimizaciòn
        
        ur=ur + dt.* del.* (  (...
            ( (uxx.*(uy.^2)) - 2.*ux.*uy.*uxy + uyy.*(ux.^2) )...
            ./  ( ((ux.^2+uy.^2)).^(3/2) +a )...
            )...
            -(force(1)*( (I1-ci1).^2 + (I2-ci2).^2 + (I3-ci3).^2   ))  +  (force(2)*( (I1-co1).^2 + (I2-co2).^2 + (I3-co3).^2   ))   ) ;
        if val
            axes(menu.mainax), imshow(mat2gray(Ic));
            hold on; contour(ur,[0,0],'r'); hold off; drawnow;
        end
        dt=dt+1;
        i=i+1;
        set(handles.text19,'String',num2str(i)), pause(0.0001)
    end
    ur=im2bw(ur);
else
    
    [m,n,~]=size(Ic);
    ur = bwdist(1-u)- bwdist(u);
    ur = 0.4*ur;
    ep=0.1;
    dt=0.8;
    a=0.1;
    i=0;
    f=double(Ic(:,:,1));
    axes(menu.mainax)
    while ishandle(H)
        if i>=ni
            delete(H)
            pause(1)
            break
        end
        
        ci=sum(sum(f(u>=0))) /  length(u(u>=0));
        co=sum(sum(f(u<0))) / length(u(u<0));
        del= ep./(pi.* (ep^2 + u.^2));
        
        %derivadas
        ux=(u(:,[2:n,n])-u(:,[1,1:n-1]))/2;
        uy=(u([2:m,m],:)-u([1,1:m-1],:))/2;
        uxx=u(:,[2:n,n])-2*u+u(:,[1,1:n-1]);
        uyy=u([2:m,m],:)-2*u+u([1,1:m-1],:);
        uxy= (u([2:m,m],[2:n,n]) + u([1,1:m-1],[1,1:n-1]) ...
            -u([1,1:m-1],[2:n,n]) - u([2:m,m],[1,1:n-1]) ) /4;
        
        
        %minimizaciòn
        
        u=u + dt.* del.* (  (...
            ( (uxx.*(uy.^2)) - 2.*ux.*uy.*uxy + uyy.*(ux.^2) )...
            ./  ( ((ux.^2+uy.^2)).^(3/2) +a )...
            )...
            -(force(1)*(f-ci).^2)  +  (force(2)*(f-co).^2)   ) ;
        if val
            axes(menu.mainax), imshow(mat2gray(Ic));
            hold on; contour(ur,[0,0],'r'); hold off; drawnow;
        end
        dt=dt+1;
        i=i+1;
        set(handles.text19,'String',num2str(i)), pause(0.00001)
    end
    ur=im2bw(ur);
end
image_segmented=Ic;
l=find(ur==1);
image_segmented(l)=mean(mean(Ic(l)));
image_segmented(l+(m*n))=mean(mean(Ic(l+(m*n))));
image_segmented(l+(2*m*n))=mean(mean(Ic(l+(2*m*n))));
l=find(imcomplement(ur)==1);
image_segmented(l)=mean(mean(Ic(l)));
image_segmented(l+(m*n))=mean(mean(Ic(l+(m*n))));
image_segmented(l+(2*m*n))=mean(mean(Ic(l+(2*m*n))));

set(handles.text19,'Visible','off')
set(handles.text18,'Visible','off')
ur(:,:,2)=imcomplement(ur);
axes(menu.mainax), imshow(mat2gray(image_segmented));
set(handles.ok,'enable','on')
set(activecontour,'Selected','on');

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
global Ic ur sel menu 
if get(hObject, 'Value') && ~isempty(Ic)
axes(menu.mainax), imshow(mat2gray(Ic));
hold on; contour(ur(:,:,sel),[0,0],'r'); hold off; drawnow;      
else
  axes(menu.mainax), imshow( ur(:,:,sel) )
end
