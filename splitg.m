function varargout = splitg(varargin)
% SPLITG MATLAB code for splitg.fig
%      SPLITG, by itself, creates a new SPLITG or raises the existing
%      singleton*.
%
%      H = SPLITG returns the handle to a new SPLITG or the handle to
%      the existing singleton*.
%
%      SPLITG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPLITG.M with the given input arguments.
%
%      SPLITG('Property','Value',...) creates a new SPLITG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before splitg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to splitg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help splitg

% Last Modified by GUIDE v2.5 07-Nov-2016 13:39:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @splitg_OpeningFcn, ...
                   'gui_OutputFcn',  @splitg_OutputFcn, ...
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


% --- Executes just before splitg is made visible.
function splitg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to splitg (see VARARGIN)

% Choose default command line output for splitg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
% UIWAIT makes splitg wait for user response (see UIRESUME)
% uiwait(handles.figure1);
[i_t,~]=imread('next2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.before,'CData',i_t);
[i_t,~]=imread('before2.jpg');
i_t=imresize(i_t,[22,22]);
set(handles.next,'CData',i_t);

% --- Outputs from this function are returned to the command line.
function varargout = splitg_OutputFcn(hObject, eventdata, handles) 
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
global mask_models menu bwtemp sel temp
all=get(handles.radiobutton1,'value');
set(handles.text1,'Visible','on');
pause(0.0001)
bwtemp=mask_models;
if all
   set(handles.text2,'Visible','on');
    temp=false(size(mask_models));
    for j=1:size(mask_models,3)
        set(handles.text2,'String',['Mask:',num2str(j)]);
        pause(0.0001)
        imaget=imfilter(double(mask_models(:,:,j)),fspecial('gauss',[10 10]));
       % for tt=1:2
            D = -bwdist(~imaget);
            mask = imextendedmin(D,2);
            D2 = imimposemin(D,mask);
            Ld2 = watershed(D2);
            imaget(Ld2 == 0) = 0;
        %end
        imaget(imaget>0.74)=1;
        imaget(imaget<=0.74)=0;
        bwtemp(:,:,j)=imaget;
        imaget=abs(imaget-imfilter(double(mask_models(:,:,j)),fspecial('gauss',[10 10])));
        imaget(imaget<0.74)=0;
        temp(:,:,j)=imaget;
    end
     axes(menu.mainax), imshow((mask_models(:,:,sel)));
    hold on; contour(temp(:,:,sel),[0,0],'r'); hold off; drawnow;
    set(handles.text2,'Visible','off');
    set(handles.text2,'String','Mask:');
else
    temp=false(size(mask_models));
    imaget=imfilter(double(mask_models(:,:,sel)),fspecial('gauss',[10 10]));
   % for tt=1:2
        D = -bwdist(~imaget);
        mask = imextendedmin(D,2);
        D2 = imimposemin(D,mask);
        Ld2 = watershed(D2);
        imaget(Ld2 == 0) = 0;
    %end
    imaget(imaget>0.75)=1;
    imaget(imaget<=0.75)=0;
    bwtemp(:,:,sel)=imaget;
    imaget=abs(imaget-imfilter(double(mask_models(:,:,sel)),fspecial('gauss',[10 10])));
    imaget(imaget<0.9)=0;
    temp(:,:,sel)=imaget;
    axes(menu.mainax), imshow((mask_models(:,:,sel)));
    hold on; contour(temp(:,:,sel),[0,0],'r'); hold off; drawnow;
end
set(handles.ok,'enable','on')
set(splitg,'Selected','on');
set(handles.text1,'Visible','off');
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
close(splitg)

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp 
resp='cancel';
close(splitg)

% --- Executes on button press in before.
function before_Callback(hObject, eventdata, handles)
% hObject    handle to before (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bwtemp sel menu Ic temp  mask_models
if sel-1>0
    sel=sel-1;
end
axes(menu.mainax)
if get(handles.radiobutton2,'value')==1
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
    if ~isempty(temp)
        axes(menu.mainax), imshow((mask_models(:,:,sel)));
        hold on; contour(temp(:,:,sel),[0,0],'r'); hold off; drawnow;
    else
        imshow(bwtemp(:,:,sel))
    end
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
global bwtemp sel menu Ic temp  mask_models
lim=size(bwtemp,3);
if sel+1<=lim
    sel=sel+1;
end
axes(menu.mainax)
if get(handles.radiobutton2,'value')==1
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
    if ~isempty(temp)
        axes(menu.mainax), imshow((mask_models(:,:,sel)));
        hold on; contour(temp(:,:,sel),[0,0],'r'); hold off; drawnow;
    else
        imshow(bwtemp(:,:,sel))
    end
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

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
