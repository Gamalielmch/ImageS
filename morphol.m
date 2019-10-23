function varargout = morphol(varargin)
% MORPHOL MATLAB code for morphol.fig
%      MORPHOL, by itself, creates a new MORPHOL or raises the existing
%      singleton*.
%
%      H = MORPHOL returns the handle to a new MORPHOL or the handle to
%      the existing singleton*.
%
%      MORPHOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MORPHOL.M with the given input arguments.
%
%      MORPHOL('Property','Value',...) creates a new MORPHOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before morphol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to morphol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help morphol

% Last Modified by GUIDE v2.5 03-Nov-2016 14:57:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @morphol_OpeningFcn, ...
                   'gui_OutputFcn',  @morphol_OutputFcn, ...
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


% --- Executes just before morphol is made visible.
function morphol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to morphol (see VARARGIN)

% Choose default command line output for morphol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
% UIWAIT makes morphol wait for user response (see UIRESUME)
% uiwait(handles.figure1);
[i_t,~]=imread('next2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.before,'CData',i_t);
[i_t,~]=imread('before2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.next,'CData',i_t);
% --- Outputs from this function are returned to the command line.
function varargout = morphol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation list 
sel =get(handles.popupmenu1,'String');
sel =sel(get(handles.popupmenu1,'Value'));
val =str2double(get(handles.edit1,'String'));
if get(handles.popupmenu1,'Value')==1
    l=size(list,2);
    list{l-1}='fill holes';
    list{l+1}=[];
     l=size(operation,1);
    operation{l+1,1}=sel{1};
    operation{l+1,2}=[];
else
    
    l=size(operation,1);
    operation{l+1,1}=sel{1};
    operation{l+1,2}=val;
    l=size(list,2);
    list{l-1}=[sel{1},'  ', get(handles.edit1,'String')];
    list{l+1}=[];
end


set(handles.listbox1,'String',list);


% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation list 
sel =get(handles.listbox1,'Value');
operation(sel,:)=[];
list(sel)=[];
set(handles.listbox1,'String',list);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in Preview.
function Preview_Callback(hObject, eventdata, handles)
% hObject    handle to Preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask_models operation menu bwtemp sel  list Ic thrs
bwtemp=mask_models;
all=get(handles.radiobutton1,'value');

if all
    
    for j=1:size(mask_models,3)
        for i=1:size(operation,1)
            if strcmp(list(i),'fill holes')
                bwtemp(:,:,j)=imfill(bwtemp(:,:,j),'holes');
            else
                bwtemp(:,:,j)=bwmorph(bwtemp(:,:,j),operation{i,1},operation{i,2});
            end
            
        end
        stats=regionprops(bwtemp(:,:,j), 'PixelIdxList');
        t=false([size(bwtemp,1) size(bwtemp,2)]);
        if thrs{1}>0 || thrs{2}~=-1
            if thrs{2}==-1
                for i=1:length(stats)
                    if length (stats(i).PixelIdxList)>=thrs{1}
                        t(stats(i).PixelIdxList)=1;
                    end
                end
            elseif thrs{1}<=0
                for i=1:length(stats)
                    if length (stats(i).PixelIdxList)<thrs{2}
                        t(stats(i).PixelIdxList)=1;
                    end
                end
            else
                for i=1:length(stats)
                    if length (stats(i).PixelIdxList)>=thrs{1} &&length (stats(i).PixelIdxList)<thrs{2}
                        t(stats(i).PixelIdxList)=1;
                    end
                end
            end
            bwtemp(:,:,j)=t;
        end
        
    end
else
    
    for i=1:size(operation,1)
        
        if strcmp(list(i),'fill holes')
            bwtemp(:,:,sel)=imfill(bwtemp(:,:,sel),'holes');
        else
            bwtemp(:,:,sel)=bwmorph(bwtemp(:,:,sel),operation{i,1},operation{i,2});
        end
        
    end
    stats=regionprops(bwtemp(:,:,sel), 'PixelIdxList');
    t=false([size(bwtemp,1) size(bwtemp,2)]);
    if thrs{1}>0 || thrs{2}~=-1
        if thrs{2}==-1
            for i=1:length(stats)
                if length (stats(i).PixelIdxList)>=thrs{1}
                    t(stats(i).PixelIdxList)=1;
                end
            end
        elseif thrs{1}<=0
            for i=1:length(stats)
                if length (stats(i).PixelIdxList)<thrs{2}
                    t(stats(i).PixelIdxList)=1;
                end
            end
        else
            for i=1:length(stats)
                if length (stats(i).PixelIdxList)>=thrs{1} &&length (stats(i).PixelIdxList)<thrs{2}
                    t(stats(i).PixelIdxList)=1;
                end
            end
        end
        bwtemp(:,:,sel)=t;
    end
end



axes(menu.mainax)
if get(handles.radiobutton3,'value')==1
    if ~isempty(Ic)
        peri=(bwtemp(:,:,sel));
         imagesc(peri)
    hold on
    h=imshow(Ic);
    peri=double(peri);
    peri(peri==1)=0.3;
    peri(peri==0)=1;
    set(h,'alphadata',peri);
    hold off
    end  
else
    
    imshow(bwtemp(:,:,sel))
end
set(handles.ok,'enable','on')
set(morphol,'Selected','on')

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp  bwtemp  mask_models sel
all=get(handles.radiobutton1,'value');
if all
mask_models=bwtemp;
else
 mask_models(:,:,sel)=bwtemp(:,:,sel);   
end
resp='ok';
close(morphol)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(morphol)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in before.
function before_Callback(hObject, eventdata, handles)
% hObject    handle to before (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bwtemp sel menu Ic
if sel-1>0
    sel=sel-1;
end
axes(menu.mainax)
if get(handles.radiobutton3,'value')==1
    if ~isempty(Ic)
        peri=(bwtemp(:,:,sel));
        imagesc(peri)
        hold on
        h=imshow(Ic);
        peri=double(peri);
        peri(peri==1)=0.3;
        peri(peri==0)=1;
        set(h,'alphadata',peri);
        hold off
        
    end
    
    
    
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
global bwtemp sel menu Ic type
lim=size(bwtemp,3);
if sel+1<=lim
    sel=sel+1;
end
axes(menu.mainax)
if get(handles.radiobutton3,'value')==1
    if ~isempty(Ic)
        it=Ic;
        peri=(bwtemp(:,:,sel));
       % peri=find(peri==1);
         if ~strcmp(type,'rgb')
             it(:,:,2)=it;
             it(:,:,3)=it(:,:,1);
         end
         it(peri)=255;
         it(peri+size(it,1)*size(it,2))=0;
         it(peri+2*size(it,1)*size(it,2))=0;
    end
    imagesc(peri)
    hold on
    h=imshow(Ic);
    peri=double(peri);
    peri(peri==1)=0.3;
    peri(peri==0)=1;
    set(h,'alphadata',peri);
    hold off
    
    
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


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global thrs
temp=get(hObject,'String');
 temp=str2double(temp);
 if isnan(temp)==0
   thrs{1}=temp;
 else
    thrs{1}=0; 
 end
set(hObject,'String',num2str(thrs{1}));

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
global thrs
temp=get(hObject,'String');
temp=str2double(temp);
 if isnan(temp)==0
   thrs{2}=temp;
   set(hObject,'String',num2str(thrs{2}));
 else
    thrs{2}=-1; 
    set(hObject,'String','-');
 end


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
