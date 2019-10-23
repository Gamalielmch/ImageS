function varargout = operations(varargin)
% OPERATIONS MATLAB code for operations.fig
%      OPERATIONS, by itself, creates a new OPERATIONS or raises the existing
%      singleton*.
%
%      H = OPERATIONS returns the handle to a new OPERATIONS or the handle to
%      the existing singleton*.
%
%      OPERATIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPERATIONS.M with the given input arguments.
%
%      OPERATIONS('Property','Value',...) creates a new OPERATIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before operations_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to operations_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help operations

% Last Modified by GUIDE v2.5 11-Nov-2016 11:45:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @operations_OpeningFcn, ...
                   'gui_OutputFcn',  @operations_OutputFcn, ...
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


% --- Executes just before operations is made visible.
function operations_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to operations (see VARARGIN)

% Choose default command line output for operations
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
% UIWAIT makes operations wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global list
set(handles.listbox1,'String',list);

% --- Outputs from this function are returned to the command line.
function varargout = operations_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
global menu mask_models sel selec
selec=1;
sel=get(handles.listbox1,'value');
axes(menu.mainax)
imshow(mask_models(:,:,sel));
set(operations,'Selected','on')
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


% --- Executes on button press in and.
function and_Callback(hObject, eventdata, handles)
% hObject    handle to and (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=0;
    l=size(operation,2);
    operation{l+1}='AND';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on button press in nand.
function nand_Callback(hObject, eventdata, handles)
% hObject    handle to nand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=0;
    l=size(operation,2);
    operation{l+1}='NAND';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on button press in or.
function or_Callback(hObject, eventdata, handles)
% hObject    handle to or (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=0;
    l=size(operation,2);
    operation{l+1}='OR';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
global selec 
selec=2;

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in nor.
function nor_Callback(hObject, eventdata, handles)
% hObject    handle to nor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=0;
    l=size(operation,2);
    operation{l+1}='NOR';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on button press in xor.
function xor_Callback(hObject, eventdata, handles)
% hObject    handle to xor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=0;
    l=size(operation,2);
    operation{l+1}='XOR';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on button press in xnor.
function xnor_Callback(hObject, eventdata, handles)
% hObject    handle to xnor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=0;
    l=size(operation,2);
    operation{l+1}='XNOR';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on button press in not.
function not_Callback(hObject, eventdata, handles)
% hObject    handle to not (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if thrs
    thrs=1;
    l=size(operation,2);
    operation{l+1}='NOT';
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add a mask','!! Warning !!')
end

% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask_models operation menu bwtemp
try
    n=operation{1};
    n=str2double(n(6:end));
    bwtemp=mask_models(:,:,n) ;
    in=1;
    for i=1:2:size(operation,2)-1
        n=operation{i+in};
        if ~strcmp(n,'NOT')
            n2=operation{i+in+1};
            n2=str2double(n2(6:end));
            switch n
                case 'AND'
                    bwtemp=and(bwtemp,mask_models(:,:,n2));
                case 'NAND'
                    bwtemp=not(and(bwtemp,mask_models(:,:,n2)));
                case 'OR'
                    bwtemp=or(bwtemp,mask_models(:,:,n2));
                case 'NOR'
                    bwtemp=not(or(bwtemp,mask_models(:,:,n2)));
                case 'XOR'
                    bwtemp=xor(bwtemp,mask_models(:,:,n2));
                case 'XNOR'
                    bwtemp=not(xor(bwtemp,mask_models(:,:,n2)));
                otherwise
                    bwtemp=not(bwtemp);
            end
        else
            bwtemp=not(bwtemp);
            in=in-1;
        end
        
    end
    axes(menu.mainax)
    imshow(bwtemp)
    set(handles.ok,'enable','on')
    set(operations,'Selected','on')
catch
    warndlg('Check the operations, there is an error','!! Warning !!')
end
% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp  bwtemp  mask_models sel
mask_models(:,:,end+1)=bwtemp;
sel=size(mask_models,3);
resp='ok';
close(operations)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(operations)


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in over.
function over_Callback(hObject, eventdata, handles)
% hObject    handle to over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask_models Ic sel type menu selec bwtemp
if ~isempty(Ic)
    if selec==1
        peri=bwperim(mask_models(:,:,sel));
    else
        if ~isempty(bwtemp)
            peri=bwperim(bwtemp);
        else
            peri=bwperim(mask_models(:,:,sel));
        end
    end
Ict=Ic;

l=find(peri==1);
if strcmp(type,'gray')
Ict(l)=255;
else
Ict(l)=255;
Ict(l+(size(Ic,1)*size(Ic,2)))=0;
Ict(l+2*(size(Ic,1)*size(Ic,2)))=0;
end
axes(menu.mainax)
imshow(Ict)
set(operations,'Selected','on')
end

% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
if ~thrs
    thrs=1;
    val =get(handles.listbox1,'String');
    val =val(get(handles.listbox1,'Value'));
    l=size(operation,2);
    operation{l+1}=val{1};
    set(handles.listbox2,'String',operation);
else
    warndlg('First you must add an operation','!! Warning !!')
end


% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clean.
function clean_Callback(hObject, eventdata, handles)
% hObject    handle to clean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global operation thrs
    thrs=0;
    operation={};
    set(handles.listbox2,'String',operation);
