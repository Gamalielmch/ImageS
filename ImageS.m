function varargout = ImageS(varargin)
% IMAGES MATLAB code for ImageS.fig
%      IMAGES, by itself, creates a new IMAGES or raises the existing
%      singleton*.
%
%      H = IMAGES returns the handle to a new IMAGES or the handle to
%      the existing singleton*.
%
%      IMAGES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGES.M with the given input arguments.
%
%      IMAGES('Property','Value',...) creates a new IMAGES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI next ImageS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageS

% Last Modified by GUIDE v2.5 11-Nov-2016 10:16:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageS_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageS_OutputFcn, ...
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


% --- Executes just next ImageS is made visible.
function ImageS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageS (see VARARGIN)

% Choose default command line output for ImageS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

javaFrame = get(hObject,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));




global  menu resp  status  previous_point original_xlim original_ylim mover zoomto sel zo
sel=1;
mover=0;
zoomto=0;
% UIWAIT makes ImageS wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%%%%%%%%%%%%%%%%%%%%Menu File %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mf = uimenu(hObject,'Label','File','ForegroundColor',[0 0 0],'backgroundColor',[0 0 0]);

opci = uimenu(mf,'Label','Open color image',...
    'Callback',{@loadimagecolor_Callback,handles});

opbi = uimenu(mf,'Label','Open binary image',...
    'Callback',{@loadimagebinary_Callback,handles});

opbci = uimenu(mf,'Label','Open binary and color image',...
    'Callback',{@loadimagecolandbin_Callback,handles});

menu.savecolor= uimenu(mf,'Label','Save color image',...
    'Enable','off','Callback',{@savecolor_Callback,handles},'Separator','on');

menu.savecurren = uimenu(mf,'Label','Save current binary image',...
    'Enable','off','Callback',{@savecurrent_Callback,handles});

menu.savebinary = uimenu(mf,'Label','Save all binary images',...
    'Enable','off','Callback',{@savebinary_Callback,handles});

menu.savebinaryandcolor = uimenu(mf,'Label','Save binary and color image',...
    'Enable','off','Callback',{@savebinancol_Callback,handles});

menu.saveall = uimenu(mf,'Label','Save all images',...
    'Enable','off','Callback',{@saveall_Callback,handles});

     uimenu(mf,'Label','Exit',...
    'Callback',@exit_Callback,'Separator','on');

%%%%%%%%%%%%%%%%%%%%%Menu preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
menu.mpr = uimenu(hObject,'Label','Preprocessing','ForegroundColor',[0 0 0]);

menu.roi = uimenu(menu.mpr,'Label','ROI',...
    'Enable','off');
menu.roiellipse = uimenu(menu.roi,'Label','Ellipse',...
    'Enable','off','Callback',{@roi_Callback,handles,1});
menu.roipolygon = uimenu(menu.roi,'Label','Polygon',...
    'Enable','off','Callback',{@roi_Callback,handles,2});
menu.roirectangular = uimenu(menu.roi,'Label','Rectangular',...
    'Enable','off','Callback',{@roi_Callback,handles,3});
menu.roifreehand = uimenu(menu.roi,'Label','Freehand',...
    'Enable','off','Callback',{@roi_Callback,handles,4});

menu.resize = uimenu(menu.mpr,'Label','Resize',...
    'Enable','off','Callback',{@resize_Callback,handles});
menu.rgbtogray = uimenu(menu.mpr,'Label','RGB to Gray',...
    'Enable','off','Callback',{@rgbtogray_Callback,handles});
menu.Adjuts = uimenu(menu.mpr,'Label','Autoadjuts hist',...
    'Enable','off','Callback',{@Adjuts_Callback,handles});
menu.equalization = uimenu(menu.mpr,'Label','Histogram equalization',...
    'Enable','off','Callback',{@equalization_Callback,handles});
menu.Deblurring  = uimenu(menu.mpr,'Label','Deblurring',...
    'Enable','off','Callback',{@Deblurring_Callback,handles});


menu.filtering = uimenu(menu.mpr,'Label','Filtering',...
    'Enable','off');

menu.flineal = uimenu(menu.filtering,'Label','Lineal',...
    'Enable','off');
menu.average = uimenu(menu.flineal,'Label','Average',...
    'Enable','off','Callback',{@filtering_Callback,handles,1});
menu.gaussian = uimenu(menu.flineal,'Label','Gaussian',...
    'Enable','off','Callback',{@filtering_Callback,handles,2});
menu.log = uimenu(menu.flineal,'Label','Log',...
    'Enable','off','Callback',{@filtering_Callback,handles,3});
menu.prewitt = uimenu(menu.flineal,'Label','Prewitt',...
    'Enable','off','Callback',{@filtering_Callback,handles,4});
menu.sobel = uimenu(menu.flineal,'Label','Sobel',...
    'Enable','off','Callback',{@filtering_Callback,handles,5});


menu.fnonlineal = uimenu(menu.filtering,'Label','Non lineal',...
    'Enable','off');
menu.kuwahara = uimenu(menu.fnonlineal,'Label','Kuwahara',...
    'Enable','off','Callback',{@filtering_Callback,handles,7});
% menu.bilateral = uimenu(menu.fnonlineal,'Label','Bilateral',...
%     'Enable','off','Callback',{@filtering_Callback,handles,8});
menu.beltrami = uimenu(menu.fnonlineal,'Label','Beltrami',...
    'Enable','off','Callback',{@filtering_Callback,handles,6});


%%%%%%%%%%%%%%%%%%%%%Menu segmentation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
menu.ms = uimenu(hObject,'Label','Segmentation','ForegroundColor',[0 0 0]);
menu.qmmf = uimenu(menu.ms ,'Label','E-CQMMF',...
    'Enable','off','Callback',{@QMMF_Callback,handles});
menu.activecontour  = uimenu(menu.ms ,'Label','Active contours',...
    'Enable','off','Callback',{@activecontour_Callback,handles});
menu.fuzzylogic = uimenu(menu.ms ,'Label','Fuzzy GMM',...
    'Enable','off','Callback',{@fuzzy_Callback,handles});
menu.gmm = uimenu(menu.ms ,'Label','GMM',...
    'Enable','off','Callback',{@GMM_Callback,handles});


%%%%%%%%%%%%%%%%%%%%%Menu Editing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
menu.editing = uimenu(hObject,'Label','Editing','ForegroundColor',[0 0 0]);
menu.morpho = uimenu(menu.editing,'Label','Morphological operations',...
     'Enable','off','Callback',{@morpho_Callback,handles});
menu.split = uimenu(menu.editing,'Label','Split operation',...
     'Enable','off','Callback',{@split_Callback,handles});
menu.manual = uimenu(menu.editing,'Label','Manual editing',...
     'Enable','off','Callback',{@manualediting_Callback,handles});
menu.operations = uimenu(menu.editing,'Label','Logical operations',...
     'Enable','off','Callback',{@operation_Callback,handles});
 
%%%%%%%%%%%%%%%%%%%%%Menu help%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
help = uimenu(hObject,'Label','Help','ForegroundColor',[0 0 0]);
menu.doc = uimenu(help,'Label','Documentation',...
    'Callback',{@documentation_Callback,handles});
menu.aboutus = uimenu(help,'Label','About us',...
    'Callback',{@webpage_Callback,handles});
menu.colaboration = uimenu(help,'Label','Colaboration',...
    'Callback',{@colaboration_Callback,handles});
menu.version = uimenu(help,'Label','License software',...
    'Callback',{@license_Callback,handles},'Separator','on');

%%%%%%%%%%%%%%%%%%%%%AXES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ha = axes('units','normalized', ...
    'position',[0 0 1 1]);


% Move the background axes to the bottom
uistack(ha,'bottom');
% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox.  If you do not have %access to this toolbox, you can use another image file instead.
I=imread('backn.jpg');
hi = imagesc(I);
colormap gray
set(hi,'alphadata',.8)
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
            'visible','off')

axes(handles.axessec) 
I=imread('temp.jpg');
hi = imagesc(I);
colormap gray
set(hi,'alphadata',.4)
set(handles.axessec,'handlevisibility','off', ...
            'visible','off')
        
axes(handles.axesmain) 
menu.mainax=handles.axesmain;
hi = imagesc(I);
set(hi,'alphadata',.4)
set(handles.axesmain,'handlevisibility','off', ...
            'visible','off')

       
        
        
        
status = '';  previous_point = [];
  if ~is2D(handles.axesmain) % is2D might disappear in a future release...
    error('mouse_figure:plot3D_not_supported', ...
                'MOUSE_FIGURE() only works for 2-D plots.');
  end
        
        
original_xlim = get(handles.axesmain, 'xlim');
original_ylim = get(handles.axesmain, 'ylim');           
        
axes(handles.axespanel) 
hi = imagesc(I);
set(hi,'alphadata',.4)
set(handles.axespanel,'handlevisibility','off', ...
            'visible','off')
        
axes(handles.axes6) 
hi = imagesc(I);
set(hi,'alphadata',.4)
set(handles.axes6,'handlevisibility','off', ...
            'visible','off') 

axes(handles.axes7) 
hi = imagesc(I);
set(hi,'alphadata',.4)
set(handles.axes7,'handlevisibility','off', ...
            'visible','off') 
        
menu.gen=text(.5,.8,'Proccesing...','color',[0 1 0],'backgroundcolor','none','parent',handles.axespanel); 
set(menu.gen,'units','normalized','Position',[.2 .09 0],'Fontunits','normalized','Fontsize',0.12,'Visible','off')

t=text(.5,.8,'Image Features','color',[0.3 1 0.1],'backgroundcolor','none','parent',handles.axespanel); 
set(t,'units','normalized','Position',[0.5 .95 0],'Fontunits','normalized','Fontsize',0.12,'HorizontalAlignment','center')
% 
% t=text(.5,.8,'Preprocessing','color',[0.3 1 0.1],'backgroundcolor','none','parent',handles.axespanel); 
% set(t,'units','normalized','Position',[0.5 .82 0],'Fontunits','normalized','Fontsize',0.04,'HorizontalAlignment','center')
% 
% t=text(.5,.8,'Segmentation','color',[0.3 1 0.1],'backgroundcolor','none','parent',handles.axespanel); 
% set(t,'units','normalized','Position',[0.5 .6 0],'Fontunits','normalized','Fontsize',0.04,'HorizontalAlignment','center')
% 
% t=text(.5,.8,'Manual Editing','color',[0.3 1 0.1],'backgroundcolor','none','parent',handles.axespanel); 
% set(t,'units','normalized','Position',[0.5 .35 0],'Fontunits','normalized','Fontsize',0.04,'HorizontalAlignment','center')

menu.imagepath=text(.5,.8,'File:','color',[0 1 1],'backgroundcolor','none','parent',handles.axespanel); 
set(menu.imagepath,'units','normalized','Position',[0.05 .75 0],'Fontunits','normalized','Fontsize',0.1,'HorizontalAlignment','left')

menu.imagesize=text(.5,.8,'Image size:','color',[0 1 1],'backgroundcolor','none','parent',handles.axespanel); 
set(menu.imagesize,'units','normalized','Position',[0.05 .55 0],'Fontunits','normalized','Fontsize',0.1,'HorizontalAlignment','left')

menu.imagetype=text(.5,.8,'Image type:','color',[0 1 1],'backgroundcolor','none','parent',handles.axespanel); 
set(menu.imagetype,'units','normalized','Position',[0.05 .35 0],'Fontunits','normalized','Fontsize',0.1,'HorizontalAlignment','left')

resp='cancel';

[i_t,~]=imread('next.jpg');
i_t=imresize(i_t,[22,29]);
set(handles.before,'CData',i_t);
[i_t,~]=imread('before.jpg');
i_t=imresize(i_t,[22,29]);
set(handles.next,'CData',i_t);
[i_t,~]=imread('but.jpg');
i_t=imresize(i_t,[22,69]);
set(handles.colorimage,'CData',i_t);
set(handles.overlap,'CData',i_t);
set(handles.mask,'CData',i_t);
set(handles.falsecolor,'CData',i_t);
[i_t,~]=imread('move.png');
i_t=imresize(i_t,[25,25]);
set(handles.move,'CData',i_t);
zo=0;
menu.zoomt = uicontrol( ...
    'Style', 'togglebutton', ...
    'Parent', hObject, ...
    'Units', 'Normalized', ...
    'Position', [0.187 0.74 0.025 0.034], ...
    'String', '', ...
    'Callback', {@myzoom, handles} ... % Pass along the handle structure as well as the default source and eventdata values
    );

[i_t,~]=imread('zoomi.png');
i_t=imresize(i_t,[25,25]);
set(menu.zoomt,'CData',i_t);

t=text(.5,.8,'mask of','color',[0.3 1 0.1],'backgroundcolor','none','parent',handles.axes6); 
set(t,'units','normalized','Position',[0.48 0.21 0],'Fontunits','normalized','Fontsize',0.09,'HorizontalAlignment','center')

t=text(.5,.8,'Visualization tools','color',[0.3 1 0.1],'backgroundcolor','none','parent',handles.axes6); 
set(t,'units','normalized','Position',[0.5 .95 0],'Fontunits','normalized','Fontsize',0.1,'HorizontalAlignment','center')



% --- Outputs from this function are returned to the command line.
function varargout = ImageS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function for loading color image %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadimagecolor_Callback(hObject, eventdata, handles)

global Ic FileName Path type menu mask_models image_segmented 

if isempty(Path)
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'COLOR IMAGE');
    if Path==0
        Path=[];
        return;
    end
else
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'COLOR IMAGE',Path);
    if Path==0
        Path=[];
        return;
    end
end

type='rgb';
Ic=imread(strcat(Path,FileName));
if size(Ic,3)>3
    Ic=Ic(:,:,1:3);
end
if size(Ic,3)==1
    type='gray';
end
image_segmented=[];
Ic=uint8(mat2gray((Ic))*255);
set(handles.axesmain,'handlevisibility','on', ...
    'visible','on')
cla(handles.axesmain)
axes(handles.axesmain)
imshow(imresize(Ic,0.5))

axes(handles.axessec)
set(handles.axessec,'handlevisibility','on', ...
            'visible','on')
cla(handles.axessec) 
maxr=250/max(size(Ic));
imshow(imresize(Ic,maxr))
mask_models=[];
set(menu.saveall,'Enable','on')
set(menu.savecolor,'Enable','on')
set(menu.qmmf,'Enable','on')
set(menu.gmm,'Enable','on')
set(menu.activecontour,'Enable','on')
set(menu.fuzzylogic,'Enable','on')
set(menu.resize,'Enable','on')
set(menu.Adjuts,'Enable','on')
set(menu.equalization,'Enable','on')
set(menu.Deblurring,'Enable','on')
set(menu.rgbtogray,'Enable','on')
set(findall(menu.roi, '-property','Enable'),'Enable','on')
set(findall(menu.filtering, '-property','Enable'),'Enable','on')
set(findall(menu.editing, '-property','Enable'),'Enable','off')

temp=string([Path FileName]);
if length(temp)>20
set(menu.imagepath,'String',['File:...  ' temp(end-19:end)])
else
set(menu.imagepath,'String',['File:...  ' temp])
end
set(menu.imagetype,'String',['Image type:     ' type])
set(menu.imagesize,'String',['Image size:     ' num2str(size(Ic,1)) 'x' num2str(size(Ic,2))])
set(findall(menu.ms, '-property','Enable'),'Enable','on')
set(handles.colorimage,'Enable','on')
set(handles.mask,'Enable','inactive')
set(handles.overlap,'Enable','inactive')
set(handles.falsecolor,'Enable','inactive')
set(handles.before,'Enable','off')
set(handles.next,'Enable','off')
set(handles.currentmask,'String','-')
set(handles.kmask,'String','-')
set(handles.axes7,'handlevisibility','on', ...
            'visible','on')
axes(handles.axes7)
cla(handles.axes7)
I=imread('temp.jpg');
hi = imagesc(I);
colormap gray
set(hi,'alphadata',.4)
set(handles.axes7,'handlevisibility','off', ...
            'visible','off') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function for loading binary image %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadimagebinary_Callback(hObject, eventdata, handles)
%function for loading image
global mask_models FileName Path menu Ic image_segmented sel

if isempty(Path)
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'BINARY IMAGE','MultiSelect','on');
    if Path==0
        Path=[];
        return;
    end
else
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'BINARY IMAGE',Path,'MultiSelect','on');
    if Path==0
        Path=[];
        return;
    end
end

image_segmented=[];
if  ~iscell(FileName)
    mask_models=imread(strcat(Path,FileName));
    mask_models=im2bw(mask_models);
    set(handles.currentmask,'String','-')
    set(handles.kmask,'String','-')
    set(handles.before,'Enable','off')
    set(handles.next,'Enable','off')
else
    mask_models=im2bw(imread(strcat(Path,FileName{1})));
    for i=2:size(FileName,2)
        mask_models(:,:,i)= im2bw(imread(strcat(Path,FileName{i})));
    end
    set(handles.currentmask,'string','1')
    set(handles.kmask,'string',num2str(size(FileName,2)))
    set(handles.before,'enable','on')
    set(handles.next,'enable','on')
end

axes(handles.axes7)
set(handles.axes7,'handlevisibility','on', ...
    'visible','on')
cla(handles.axes7)
imshow(imresize(mask_models(:,:,1),0.5))


set(handles.axesmain,'handlevisibility','on', ...
    'visible','on')
cla(handles.axesmain)
axes(handles.axesmain)
imshow(mask_models(:,:,1))

set(handles.axessec,'handlevisibility','on', ...
            'visible','on')
axes(handles.axessec)
cla(handles.axessec)
I=imread('temp.jpg');
hi = imagesc(I);
colormap gray
set(hi,'alphadata',.4)
set(handles.axessec,'handlevisibility','off', ...
            'visible','off')

set(menu.savebinary,'Enable','on')
set(menu.savecurren,'Enable','on')
set(menu.saveall,'Enable','on')
set(menu.roi,'Enable','on')
set(findall(menu.mpr, '-property','Enable'),'Enable','off')
set(findall(menu.editing, '-property','Enable'),'Enable','on')
set(menu.mpr,'Enable','on')
set(findall(menu.roi, '-property','Enable'),'Enable','on')
set(findall(menu.ms, '-property','Enable'),'Enable','off')

Ic=[];
set(handles.overlap,'Enable','inactive')
set(handles.colorimage,'Enable','inactive')
set(handles.falsecolor,'Enable','inactive')
set(menu.resize,'Enable','on')
set(handles.mask,'Enable','on')
sel=1;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function for loading binary and color image %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadimagecolandbin_Callback(hObject, eventdata, handles)
%function for loading image
global mask_models FileName Path Ic menu type image_segmented sel


if isempty(Path)
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'BINARY IMAGE','MultiSelect','on');
    if Path==0
        Path=[];
        return;
    end
else
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'BINARY IMAGE',Path,'MultiSelect','on');
    if Path==0
        Path=[];
        return;
    end
end

if  ~iscell(FileName)
    mask_models=imread(strcat(Path,FileName));
    mask_models=im2bw(mask_models);
    set(handles.currentmask,'String','-')
    set(handles.kmask,'String','-')
    set(handles.before,'Enable','off')
    set(handles.next,'Enable','off')
else
    mask_models=im2bw(imread(strcat(Path,FileName{1})));
    for i=2:size(FileName,2)
        mask_models(:,:,i)= im2bw(imread(strcat(Path,FileName{i})));
    end
    set(handles.currentmask,'string','1')
    set(handles.kmask,'string',num2str(size(FileName,2)))
    set(handles.before,'enable','on')
    set(handles.next,'enable','on')
end

axes(handles.axes7)
set(handles.axes7,'handlevisibility','on', ...
            'visible','on')
cla(handles.axes7) 
maxr=250/max(size(mask_models(:,:,1)));
imshow(imresize(mask_models(:,:,1),maxr))

if isempty(Path)
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'COLOR IMAGE');
    if Path==0
        Path=[];
        return;
    end
else
    [FileName, Path]=uigetfile({'*.png;*.tiff;*.tif;*.jpg;*.bmp'},'COLOR IMAGE',Path);
    if Path==0
        Path=[];
        return;
    end
end

type='rgb';
Ic=imread(strcat(Path,FileName));
if size(Ic,3)>3
    Ic=Ic(:,:,1:3);
end
if size(Ic,3)==1
    type='gray';
end
Ic=uint8(mat2gray((Ic))*255);
set(handles.axessec,'handlevisibility','on', ...
            'visible','on')
cla(handles.axessec) 
axes(handles.axessec)
maxr=250/max(size(Ic));
imshow(imresize(Ic,maxr))


set(handles.axesmain,'handlevisibility','on', ...
            'visible','on')
set(findall(menu.editing, '-property','Enable'),'Enable','on')

cla(handles.axesmain) 
axes(handles.axesmain)

[a,b,~]=size(Ic);
[c,d,~]=size(mask_models(:,:,1));
if a~=c || b~=d
    Ic=imresize(Ic,[c,d]);
end
Ict=Ic;
peri=bwperim(mask_models(:,:,1));
l=find(peri==1);
if strcmp(type,'gray')
Ict(l)=255;
else
Ict(l)=255;
Ict(l+(size(Ic,1)*size(Ic,2)))=0;
Ict(l+2*(size(Ic,1)*size(Ic,2)))=0;
end
imshow(Ict)
image_segmented=Ic;
if size(mask_models,3)>1
    for i=1:size(mask_models,3)
        l=find(mask_models(:,:,i)==1);
        image_segmented(l)=mean(mean(Ic(l)));
        image_segmented(l+(c*d))=mean(mean(Ic(l+(c*d))));
        image_segmented(l+(2*c*d))=mean(mean(Ic(l+(2*c*d))));
    end
else
    l=find(mask_models==1);
    image_segmented(l)=mean(mean(Ic(l)));
    image_segmented(l+(c*d))=mean(mean(Ic(l+(c*d))));
    image_segmented(l+(2*c*d))=mean(mean(Ic(l+(2*c*d))));
    l=find(imcomplement(mask_models)==1);
    image_segmented(l)=mean(mean(Ic(l)));
    image_segmented(l+(c*d))=mean(mean(Ic(l+(c*d))));
    image_segmented(l+(2*c*d))=mean(mean(Ic(l+(2*c*d))));
end
sel=1;
set(findall(menu.ms, '-property','Enable'),'Enable','off')
set(menu.savebinary,'Enable','on')
set(menu.savecurren,'Enable','on')
set(menu.savecolor,'Enable','on')
set(menu.saveall,'Enable','on')
set(menu.savebinaryandcolor,'Enable','on')
set(findall(menu.mpr, '-property','Enable'),'Enable','off')
set(menu.mpr,'Enable','on')
set(handles.overlap,'Enable','on')
set(findall(menu.roi, '-property','Enable'),'Enable','on')
set(handles.colorimage,'Enable','on')
set(handles.falsecolor,'Enable','on')
set(menu.resize,'Enable','on')
set(handles.mask,'Enable','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          function to exit         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exit_Callback(hObject, eventdata, handles)
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to select ROI  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function roi_Callback(hObject, eventdata, handles,typeroi)
global Ic mask_models type image_segmented
cla(handles.axesmain)
axes(handles.axesmain)
rr=figure('Name','Selecting ROI','NumberTitle','off');
javaFrame = get(rr,'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.JPG'));
set(gcf, 'MenuBar', 'None')
if ~isempty(Ic) && isempty(mask_models)
    [a,b,~]=size(Ic);
    entro=1; imshow(Ic)
elseif ~isempty(Ic) && ~isempty(mask_models)
    [a,b,~]=size(Ic);
    entro=2; imshow(Ic)
else
    [a,b,~]=size(mask_models(:,:,1));
    entro=3; imshow(mask_models(:,:,1))
end

switch typeroi
    case 1
        h = imellipse(gca, [round(b*0.25) round(a*0.25) round(b*0.5) round(a*0.5)]);
        wait(h);
        try
            bw=createMask(h);
        catch
            if entro==1 || entro==2
                imshow(Ic)
            else
                imshow(mask_models(:,:,1))
            end
            return
        end
    case 2
        try
            bw = roipoly;
        catch
            if entro==1 || entro==2
                imshow(Ic)
            else
                imshow(mask_models(:,:,1))
            end
            return
        end
    case 3
        h = imrect(gca, [round(b*0.25) round(a*0.25) round(b*0.5) round(a*0.5)]);
        wait(h);
        try
            bw=createMask(h);
        catch
            if entro==1 || entro==2
                imshow(Ic)
            else
                imshow(mask_models(:,:,1))
            end
            return
        end
    otherwise
        h = imfreehand;
        wait(h);
        try
            bw=createMask(h);
        catch
            if entro==1 || entro==2
                imshow(Ic)
            else
                imshow(mask_models(:,:,1))
            end
            return
        end
end
if ishandle(rr)
    close(rr)
else
    if entro==1 || entro==2
        imshow(Ic)
    else
        imshow(mask_models(:,:,1))
    end
    return
end
new=regionprops(bw,'BoundingBox');
new.BoundingBox=round(new.BoundingBox);
if entro==1 ||  entro==2
    if strcmp(type,'rgb')
        for k=1:3
            Ic(:,:,k)=Ic(:,:,k).*uint8(bw);
        end
    else
        Ic=Ic.*uint8(bw);
    end
    Ic=Ic(new.BoundingBox(2):new.BoundingBox(2)+new.BoundingBox(4),new.BoundingBox(1):new.BoundingBox(1)+new.BoundingBox(3),:);
end
if entro==2 ||  entro==3
    for i=1:size(mask_models,3)
        mask_models(:,:,i)=mask_models(:,:,i).*bw;
    end
    mask_models=mask_models(new.BoundingBox(2):new.BoundingBox(2)+new.BoundingBox(4),new.BoundingBox(1):new.BoundingBox(1)+new.BoundingBox(3),:);
end
if ~isempty(image_segmented)
    for k=1:3
        image_segmented(:,:,k)=image_segmented(:,:,k).*uint8(bw);
    end
    image_segmented=image_segmented(new.BoundingBox(2):new.BoundingBox(2)+new.BoundingBox(4),new.BoundingBox(1):new.BoundingBox(1)+new.BoundingBox(3),:);
end
if entro==1
    axes(handles.axesmain)
    imshow(Ic)
    axes(handles.axessec)
    maxr=250/max(size(Ic));
    imshow(imresize(Ic,maxr))
elseif entro==2
    Ict=Ic;
    peri=bwperim(mask_models(:,:,1));
    l=find(peri==1);
    if strcmp(type,'gray')
        Ict(l)=255;
    else
        Ict(l)=255;
        Ict(l+(size(Ic,1)*size(Ic,2)))=0;
        Ict(l+2*(size(Ic,1)*size(Ic,2)))=0;
    end
    axes(handles.axesmain)
    imshow(Ict)
    axes(handles.axessec)
    maxr=250/max(size(Ic));
    imshow(imresize(Ic,maxr))
    axes(handles.axes7)
    imshow(mask_models(:,:,1))
else
    axes(handles.axesmain)
    imshow(mask_models(:,:,1))
    axes(handles.axes7)
    imshow(mask_models(:,:,1))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to converted rgb to gray  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rgbtogray_Callback(hObject, eventdata, handles)
global Ic type menu resp
set(menu.gen,'visible','on');
sal=rgbtogray();
uiwait(sal);
if strcmp(resp,'ok')
Ic=rgb2gray(Ic);
type='gray';
end
set(menu.gen,'visible','off');
axes(handles.axesmain)
imshow(Ic)
%% function to resize image %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function resize_Callback(hObject, eventdata, handles)
global Ic menu resp ynew xnew resiz trac mask_models image_segmented
if ~isempty(Ic)
resiz=[ size(Ic,1) size(Ic,2)];
else
resiz=[ size(mask_models,1) size(mask_models,2)];
end
set(menu.gen,'visible','on');
pause(0.1)
trac=1;
ynew=resiz(1);
xnew=resiz(2);
sal=resizeg();
uiwait(sal);
if strcmp(resp,'ok')
    if ~isempty(Ic)
       Ic=imresize(Ic,[ynew,xnew]);
       axes(handles.axesmain)
       imshow(Ic)
       set(menu.imagesize,'String',['Image size:     ' num2str(size(Ic,1)) 'x' num2str(size(Ic,2))])
    end
    if ~isempty(mask_models)
        mask_models=imresize(mask_models,[ynew,xnew]);
        if isempty(Ic)
        axes(handles.axesmain)
        imshow(mask_models(:,:,1))
        else
         axes(handles.axes7)
        imshow(mask_models(:,:,1))  
        end
    end
     if ~isempty(image_segmented)
         image_segmented=imresize(image_segmented,[ynew,xnew]);
     end
else
 axes(handles.axesmain)
    if ~isempty(Ic)
        imshow(Ic)
    else
        imshow(mask_models(:,:,1))
    end
    
end

set(menu.gen,'visible','off');
resp='cancel';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to enhance image  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Adjuts_Callback(hObject, eventdata, handles)
global Ic menu type mask_models resp
set(menu.gen,'visible','on');
pause(0.1)
sal=autoadjuts();
uiwait(sal);
if strcmp(resp,'ok')

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
        Ic = applycform(LAB, cform2srgb);
        Ic=uint8(Ic*256);
    else
        Ic = imadjust(Ic);
    end
    axes(handles.axesmain)
    imshow(Ic)

else
    axes(handles.axesmain)
    if ~isempty(Ic)
        imshow(Ic)
    else
        imshow(mask_models(:,:,1))
    end
end
resp='cancel';
set(menu.gen,'visible','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to enhance image  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function equalization_Callback(hObject, eventdata, handles)
global Ic menu type resp mask_models
set(menu.gen,'visible','on');
pause(0.1)
sal=equalization();
uiwait(sal);
if strcmp(resp,'ok')
    if strcmp(type,'rgb')
        for j=1:3
            Ic(:,:,j)= histeq(Ic(:,:,j));
        end
        
    else
        Ic= histeq(Ic);
    end
    axes(handles.axesmain)
    imshow(Ic)
else
    axes(handles.axesmain)
    if ~isempty(Ic)
        imshow(Ic)
    else
        imshow(mask_models(:,:,1))
    end
end

set(menu.gen,'visible','off');
resp='cancel';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to enhance image  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Deblurring_Callback(hObject, eventdata, handles)
global Ic menu resp answer
answer=[21 11 0.2];
set(menu.gen,'visible','on');
pause(0.1)
sal=Tunning_parameters();
uiwait(sal);
if strcmp(resp,'ok')
        fil = fspecial('motion',answer(1),answer(2));
        Ic= deconvwnr(Ic, fil, answer(3));
end
axes(handles.axesmain)
imshow(Ic)
set(menu.gen,'visible','off');
resp='cancel';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to filter image         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filtering_Callback(hObject, eventdata, handles,fil)
global Ic menu type filt resp answe
set(menu.gen,'visible','on');
pause(0.1)
if fil<6
answe=[8 0.5 0];
elseif fil==6
answe=[30 0.015 0];  
elseif fil==7
answe=[5 0.5 0];  
else
 answe=[5 0.1 0];    
end
filt=fil;

sal=linealfilter();
uiwait(sal);
if strcmp(resp,'ok')
    switch fil
        case 1
            Ic=imfilter(Ic,fspecial('average',[answe(1) answe(1)]));
        case 2
            Ic=imfilter(Ic,fspecial('gaussian',[answe(1) answe(1)],answe(2)));
        case 3
            Ic=uint8(mat2gray(imfilter(Ic,fspecial('log',[answe(1) answe(1)],answe(2))))*256);
        case 4
            Ic=imfilter(Ic,fspecial('prewitt'));
        case 5
            Ic=imfilter(Ic,fspecial('sobel'));
        case 6
            if strcmp(type,'rgb')
                for i=1:3
                    Ic(:,:,i)=uint8(beltrami2D(double(Ic(:,:,i)), answe(1), answe(2)));
                end
            else
                Ic=uint8(beltrami2D(double(Ic), answe(1), answe(2)));
            end
        case 7
            if strcmp(type,'rgb')
                for i=1:3
                    Ic(:,:,i)=uint8(Kuwahara(double(Ic(:,:,i)),answe(1)));
                end
            else
                Ic=uint8(Kuwahara(double(Ic),answe(1)));
            end
            
        otherwise
%             Ic=imresize(Ic,0.5);
%             if strcmp(type,'rgb')
%                 for i=1:3
%                     Ic(:,:,i) =  bif(Ic(:,:,i),answe(1),answe(2));
%                 end
%             else
%                 Ic=bif(Ic,answe(1),answe(2));
%             end
%             Ic=imresize(Ic,2);
    end
end
resp='cancel';
axes(handles.axesmain)
imshow(Ic)
set(menu.gen,'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to segmented image by QMMF  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function QMMF_Callback(hObject, eventdata, handles)
global Ic mode_models lambda miu ni nm resp menu medias sgm fore back mask_models sel type colm
set(menu.gen,'visible','on');
pause(0.1)
ni=50;
miu=0.5;
lambda=5;
mode_models=1;
medias=[];
sgm=[];
nm=0;
fore=[];
back=[];
colm=[];
axes(handles.axesmain)
imshow(Ic)
if ~strcmp(type,'rgb')
Ic(:,:,2)=Ic(:,:,1);
Ic(:,:,3)=Ic(:,:,2);
end
sal=qmmf();
uiwait(sal);

if strcmp(resp,'ok')
    imshow(mask_models(:,:,1))
    sel=1;
    set(handles.currentmask,'String','1')
    set(handles.kmask,'String',num2str(size(mask_models,3)))
    set(handles.next,'Enable','on')
    set(handles.before,'Enable','on')
    set(handles.falsecolor,'Enable','on')
    set(findall(menu.editing, '-property','Enable'),'Enable','on')
    set(handles.overlap,'Enable','on')
    set(handles.mask,'Enable','on')
    set(menu.savebinary,'Enable','on')
    set(menu.savecurren,'Enable','on')
    set(menu.savebinaryandcolor,'Enable','on')

else
    Ic=uint8(Ic);
    imshow(Ic)
    set(findall(menu.editing, '-property','Enable'),'Enable','off')
end
if ~strcmp(type,'rgb')
Ic=Ic(:,:,1);
end
resp='cancel';
set(menu.gen,'visible','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% function to segmented image by active contours  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function activecontour_Callback(hObject, eventdata, handles)
global Ic  force ni  resp menu mask_models sel type i_regions
set(menu.gen,'visible','on');
pause(0.1)
sel=1;
ni=100;
i_regions=5;
force=[0.5, .1];
axes(handles.axesmain)
imshow(Ic)
if ~strcmp(type,'rgb')
Ic(:,:,2)=Ic(:,:,1);
Ic(:,:,3)=Ic(:,:,2);
end
sal=activecontour();
uiwait(sal);

if strcmp(resp,'ok')
    sel=1;
    imshow(mask_models(:,:,1))
    set(handles.currentmask,'String','1')
    set(handles.kmask,'String',num2str(size(mask_models,3)))
    set(handles.next,'Enable','on')
    set(handles.before,'Enable','on')
    set(handles.falsecolor,'Enable','on')
    set(handles.falsecolor,'Enable','on')
    set(findall(menu.editing, '-property','Enable'),'Enable','on')
    set(handles.overlap,'Enable','on')
    set(handles.mask,'Enable','on')
    set(menu.savebinary,'Enable','on')
    set(menu.savecurren,'Enable','on')
    set(menu.savebinaryandcolor,'Enable','on')

    
else
    imshow(Ic)
    set(findall(menu.editing, '-property','Enable'),'Enable','off')
end
if ~strcmp(type,'rgb')
Ic=Ic(:,:,1);
end
resp='cancel';
set(menu.gen,'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  function to segmented image by GMM  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fuzzy_Callback(hObject, eventdata, handles)
global Ic   ni nm resp menu medias sgm fore back mask_models sel type mode_models
set(menu.gen,'visible','on');
pause(0.1)
ni=20;
medias=[];
sgm=[];
nm=0;
fore=[];
back=[];
mode_models=1;
axes(handles.axesmain)
imshow(Ic)
sal=fexmaxgmm();
uiwait(sal);
Ic=uint8(Ic);
if strcmp(resp,'ok')
    imshow(mask_models(:,:,1))
    sel=1;
    set(handles.currentmask,'String','1')
    set(handles.kmask,'String',num2str(size(mask_models,3)))
    set(handles.next,'Enable','on')
    set(handles.before,'Enable','on')
    set(handles.colorimage,'Enable','on')
    set(handles.overlap,'Enable','on')
    set(handles.falsecolor,'Enable','on')
    set(handles.mask,'Enable','on')
    set(findall(menu.editing, '-property','Enable'),'Enable','on')
    set(menu.savebinary,'Enable','on')
    set(menu.savecurren,'Enable','on')
    set(menu.savebinaryandcolor,'Enable','on')

else
    set(findall(menu.editing, '-property','Enable'),'Enable','off')
    imshow(Ic)
end
if ~strcmp(type,'rgb')
Ic=Ic(:,:,1);
end
resp='cancel';
set(menu.gen,'visible','off');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  function to segmented image by GMM  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GMM_Callback(hObject, eventdata, handles)
global Ic coeh miu ni nm resp menu medias sgm fore back mask_models sel type mode_models
set(menu.gen,'visible','on');
pause(0.1)
ni=10;
miu=0.5;
medias=[];
sgm=[];
nm=0;
fore=[];
back=[];
coeh=6;
mode_models=1;
axes(handles.axesmain)
imshow(Ic)
sal=gmm();
uiwait(sal);
Ic=uint8(Ic);
if strcmp(resp,'ok')
    imshow(mask_models(:,:,1))
    sel=1;
    set(handles.currentmask,'String','1')
    set(handles.kmask,'String',num2str(size(mask_models,3)))
    set(handles.next,'Enable','on')
    set(handles.before,'Enable','on')
    set(handles.colorimage,'Enable','on')
    set(handles.overlap,'Enable','on')
    set(handles.falsecolor,'Enable','on')
    set(handles.mask,'Enable','on')
    set(findall(menu.editing, '-property','Enable'),'Enable','on')
    set(menu.savebinary,'Enable','on')
    set(menu.savecurren,'Enable','on')
    set(menu.savebinaryandcolor,'Enable','on')

else
    set(findall(menu.editing, '-property','Enable'),'Enable','off')
    imshow(Ic)
end
if ~strcmp(type,'rgb')
Ic=Ic(:,:,1);
end
resp='cancel';
set(menu.gen,'visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  function to apply morphological operation   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function morpho_Callback(hObject, eventdata, handles)
global resp menu mask_models sel mode_models operation list thrs image_segmented Ic type
set(menu.gen,'visible','on');
pause(0.1)
mode_models=1;
axes(handles.axesmain)
imshow(mask_models(:,:,sel))
operation={};
operation{1,1}='clean';
operation{1,2}=1;
thrs={};
thrs{1}=0;
thrs{2}=-1;
list={};
list{1}=['clean  ', '1'];
list{2}=[];
list{3}=[];
sal=morphol();
uiwait(sal);
imshow(mask_models(:,:,sel))
if strcmp(resp,'ok')
    [m,n,~]=size(Ic);
    if ~isempty(image_segmented)
        image_segmented=Ic;
        if strcmp(type,'rgb')
            for i=1:size(mask_models,3)
                l=find(mask_models(:,:,i)==1);
                image_segmented(l)=mean(mean(Ic(l)));
                image_segmented(l+(m*n))=mean(mean(Ic(l+(m*n))));
                image_segmented(l+(2*m*n))=mean(mean(Ic(l+(2*m*n))));
            end
        else
            for i=1:size(mask_models,3)
                l=find(mask_models(:,:,i)==1);
                image_segmented(l)=mean(mean(Ic(l)));
            end
        end
    end
end
set(handles.currentmask,'String',num2str(sel))
resp='cancel';
set(menu.gen,'visible','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  function to separate object   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function split_Callback(hObject, eventdata, handles)
global resp menu mask_models sel image_segmented Ic type
set(menu.gen,'visible','on');
pause(0.1)
axes(handles.axesmain)
imshow(mask_models(:,:,sel))
sal=splitg();
uiwait(sal);
imshow(mask_models(:,:,sel))
if strcmp(resp,'ok')
    [m,n,~]=size(Ic);
    if ~isempty(image_segmented)
        image_segmented=Ic;
        if strcmp(type,'rgb')
            for i=1:size(mask_models,3)
                l=find(mask_models(:,:,i)==1);
                image_segmented(l)=mean(mean(Ic(l)));
                image_segmented(l+(m*n))=mean(mean(Ic(l+(m*n))));
                image_segmented(l+(2*m*n))=mean(mean(Ic(l+(2*m*n))));
            end
        else
            for i=1:size(mask_models,3)
                l=find(mask_models(:,:,i)==1);
                image_segmented(l)=mean(mean(Ic(l)));
            end
        end
    end
end

set(handles.currentmask,'String',num2str(sel))

resp='cancel';
set(menu.gen,'visible','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   function to manual editing   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function manualediting_Callback(hObject, eventdata, handles)
global mask_models sel seleccion bwtemp  image_segmented Ic type
%set(menu.gen,'visible','on');
pause(0.1)

seleccion=0;
bwtemp=mask_models;
axes(handles.axesmain)
imshow(mask_models(:,:,sel))
sal=editing();
uiwait(sal);

[m,n,~]=size(Ic);
if ~isempty(image_segmented)
    image_segmented=Ic;
    if strcmp(type,'rgb')
        for i=1:size(mask_models,3)
            l=find(mask_models(:,:,i)==1);
            image_segmented(l)=mean(mean(Ic(l)));
            image_segmented(l+(m*n))=mean(mean(Ic(l+(m*n))));
            image_segmented(l+(2*m*n))=mean(mean(Ic(l+(2*m*n))));
        end
    else
        for i=1:size(mask_models,3)
            l=find(mask_models(:,:,i)==1);
            image_segmented(l)=mean(mean(Ic(l)));
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Navigation       button     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask_models sel
lim=size(mask_models,3);
if sel+1<=lim
    sel=sel+1;
end
set(handles.currentmask,'String',num2str(sel))
axes(handles.axesmain)
imshow(mask_models(:,:,sel))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      Navigation       button       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in before.
function before_Callback(hObject, eventdata, handles)
% hObject    handle to before (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask_models sel
if sel-1>0
    sel=sel-1;
end
set(handles.currentmask,'String',num2str(sel))
axes(handles.axesmain)
imshow(mask_models(:,:,sel))


% --- Executes on button press in falsecolor.
function falsecolor_Callback(hObject, eventdata, handles)
% hObject    handle to falsecolor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  image_segmented
axes(handles.axesmain)
imshow(image_segmented)



% --- Executes on button press in colorimage.
function colorimage_Callback(hObject, eventdata, handles)
% hObject    handle to colorimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  Ic 
axes(handles.axesmain)
imshow(Ic)


 function scroll_zoom(hObject, eventdata, handles)
% global zoomto
% if zoomto
%         % get the amount of scolls
%         scrolls = eventdata.VerticalScrollCount;
%         % get the axes' x- and y-limits
%         xlim = get(handles.axesmain, 'xlim');  ylim = get(handles.axesmain, 'ylim');
%         % get the current camera position, and save the [z]-value
%         cam_pos_Z = get(handles.axesmain, 'cameraposition');  cam_pos_Z = cam_pos_Z(3);
%         % get the current point
%         old_position = get(handles.axesmain, 'CurrentPoint'); old_position(1,3) = cam_pos_Z;
%         % calculate zoom factor
%         zoomfactor = 1 - scrolls/50;
%         % adjust camera position
% %         set(handles.axesmain, 'cameratarget', [old_position(1, 1:2), 0],...
% %             'cameraposition', old_position(1, 1:3));
%         % adjust the camera view angle (equal to zooming in)
%         camzoom(zoomfactor);
%         % zooming with the camera has the side-effect of
%         % NOT adjusting the axes limits. We have to correct for this:
%         x_lim1 = (old_position(1,1) - min(xlim))/zoomfactor;
%         x_lim2 = (max(xlim) - old_position(1,1))/zoomfactor;
%         xlim   = [old_position(1,1) - x_lim1, old_position(1,1) + x_lim2];
%         y_lim1 = (old_position(1,2) - min(ylim))/zoomfactor;
%         y_lim2 = (max(ylim) - old_position(1,2))/zoomfactor;
%         ylim   = [old_position(1,2) - y_lim1, old_position(1,2) + y_lim2];
%         set(handles.axesmain, 'xlim', xlim), set(handles.axesmain, 'ylim', ylim)
%         % set new camera position
%         new_position = get(handles.axesmain, 'CurrentPoint');
%         old_camera_target =  get(handles.axesmain, 'CameraTarget');
%         old_camera_target(3) = cam_pos_Z;
%         new_camera_position = old_camera_target - ...
%             (new_position(1,1:3) - old_camera_target(1,1:3));
%         % adjust camera target and position
% %         set(handles.axesmain, 'cameraposition', new_camera_position(1, 1:3),...
% %             'cameratarget', [new_camera_position(1, 1:2), 0]);
%         % we also have to re-set the axes to stretch-to-fill mode
%         set(handles.axesmain, 'cameraviewanglemode', 'auto',...
%             'camerapositionmode', 'auto',...
%             'cameratargetmode', 'auto');
% end 
        
function pan_click(hObject, eventdata, handles)
global status previous_point original_ylim original_xlim mover
if mover
    % double check if these axes are indeed the current axes
    switch lower(get(hObject, 'selectiontype'))
        % start panning on left click
        case 'normal'
            status = 'down';
            previous_point = get(handles.axesmain, 'CurrentPoint');
            % reset view on double click
        case 'open' % double click (left or right)
            set(handles.axesmain, 'Xlim', original_xlim,...
                'Ylim', original_ylim);
            % right click - set new reset state
        case 'alt'
            original_xlim = get(handles.axesmain, 'xlim');
            original_ylim = get(handles.axesmain, 'ylim');
    end
end


% release mouse button
function pan_release(hObject, eventdata, handles)
global status mover
if mover
    % double check if these axes are indeed the current axes
    status = '';
end

function pan_motion(hObject, eventdata, handles)
global status previous_point mover
if mover
    % double check if these axes are indeed the current axes
    % return if there isn't a previous point
    if isempty(previous_point), return, end
    % return if mouse hasn't been clicked
    if isempty(status), return, end
    % get current location (in pixels)
    current_point = get(handles.axesmain, 'CurrentPoint');
    % get current XY-limits
    xlim = get(handles.axesmain, 'xlim');  ylim = get(handles.axesmain, 'ylim');
    % find change in position
    delta_points = current_point - previous_point;
    % adjust limits
    new_xlim = xlim - delta_points(1);
    new_ylim = ylim - delta_points(3);
    % set new limits
    set(handles.axesmain, 'Xlim', new_xlim); set(handles.axesmain, 'Ylim', new_ylim);
    % save new position
    previous_point = get(handles.axesmain, 'CurrentPoint');
end


% --- Executes on button press in move.
function move_Callback(hObject, eventdata, handles)
% hObject    handle to move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mover 
mover=1-mover;
if mover==1
[i_t,~]=imread('move2.png');
else  
[i_t,~]=imread('move.png');
end
i_t=imresize(i_t,[25,25]);
set(handles.move,'CData',i_t);  


% % --- Executes on button press in zoomt.
 function zoomt_Callback(hObject, eventdata, handles)
% % hObject    handle to zoomt (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global zoomto
% zoomto=1-zoomto;
% if zoomto==1
% [i_t,~]=imread('zoomi2.png');
% else  
% [i_t,~]=imread('zoomi.png');
% end
% i_t=imresize(i_t,[25,25]);
% set(handles.zoomt,'CData',i_t);  


% --- Executes on button press in overlap.
function overlap_Callback(hObject, eventdata, handles)
% hObject    handle to overlap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mask_models Ic sel type
Ict=Ic;
peri=bwperim(mask_models(:,:,sel));
l=find(peri==1);
if strcmp(type,'gray')
Ict(l)=255;
else
Ict(l)=255;
Ict(l+(size(Ic,1)*size(Ic,2)))=0;
Ict(l+2*(size(Ic,1)*size(Ic,2)))=0;
end
axes(handles.axesmain)
imshow(Ict)


% --- Executes on button press in mask.
function mask_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mask_models sel
axes(handles.axesmain)
imshow(mask_models(:,:,sel))


function savecolor_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  Ic FileName Path
if ~isempty(Path)
    [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as',[Path 'color image.tiff']);
    if Path==0
        Path=[];
        return;
    end
else
   [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as');
    if Path==0
        Path=[];
        return;
    end
end

if ~isempty(Ic)
    imwrite(Ic,[Path FileName]); 
end

function savebinary_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mask_models FileName Path
if ~isempty(Path)
    [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as',[Path 'binary image.tiff']);
    if Path==0
        Path=[];
        return;
    end
else
   [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as');
    if Path==0
        Path=[];
        return;
    end
end
k = strfind(FileName,'.');
k=k(end);
if ~isempty(mask_models)
    for i=1:size(mask_models,3)
    imwrite(mask_models(:,:,i),[Path FileName(1:k-1) num2str(i) FileName(k) FileName(k+1:end) ]);
    end
end

function savecurrent_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mask_models FileName Path sel
if ~isempty(Path)
    [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as',[Path 'binary image.tiff']);
    if Path==0
        Path=[];
        return;
    end
else
   [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as');
    if Path==0
        Path=[];
        return;
    end
end
k = strfind(FileName,'.');
k=k(end);
if ~isempty(mask_models)
    imwrite(mask_models(:,:,sel),[Path FileName(1:k-1) num2str(sel) FileName(k) FileName(k+1:end) ]);
end

function savebinancol_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mask_models FileName Path Ic 
if ~isempty(Path)
    [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as',Path);
    if Path==0
        Path=[];
        return;
    end
else
   [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as');
    if Path==0
        Path=[];
        return;
    end
end

if ~isempty(Ic)
    imwrite(Ic,[Path FileName]); 
end
k = strfind(FileName,'.');
k=k(end);
if ~isempty(mask_models)
    for i=1:size(mask_models,3)
    imwrite(mask_models(:,:,i),[Path FileName(1:k-1) num2str(i) FileName(k) FileName(k+1:end) ]);
    end
end

function saveall_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  mask_models FileName Path Ic image_segmented
if ~isempty(Path)
    [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as',Path);
    if Path==0
        Path=[];
        return;
    end
else
   [FileName, Path]=uiputfile({'*.tiff';'*.jpg';'*.bmp';'*.png'},'Save as');
    if Path==0
        Path=[];
        return;
    end
end

if ~isempty(Ic)
    imwrite(Ic,[Path FileName]); 
end
k = strfind(FileName,'.');
k=k(end);

if ~isempty(image_segmented)
    imwrite(image_segmented,[Path FileName(1:k-1) 'False color' FileName(k) FileName(k+1:end) ]); 
end


if ~isempty(mask_models)
    for i=1:size(mask_models,3)
    imwrite(mask_models(:,:,i),[Path FileName(1:k-1) num2str(i) FileName(k) FileName(k+1:end) ]);
    end
end


function operation_Callback(hObject, eventdata, handles)
% hObject    handle to mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resp menu mask_models sel operation list thrs image_segmented Ic type selec
set(menu.gen,'visible','on');
pause(0.1)
axes(handles.axesmain)
imshow(mask_models(:,:,sel))
operation={};
thrs=0;
list=cell(size(mask_models,3),1);
for i=1:size(mask_models,3)
list{i}=['Mask ',num2str(i)];
end
selec=1;
sal=operations();
uiwait(sal);
imshow(mask_models(:,:,sel))
if strcmp(resp,'ok')
    set(handles.kmask,'String',num2str(size(mask_models,3)))
    [m,n,~]=size(Ic);
    if ~isempty(image_segmented)
        image_segmented=Ic;
        if strcmp(type,'rgb')
            for i=1:size(mask_models,3)
                l=find(mask_models(:,:,i)==1);
                image_segmented(l)=mean(mean(Ic(l)));
                image_segmented(l+(m*n))=mean(mean(Ic(l+(m*n))));
                image_segmented(l+(2*m*n))=mean(mean(Ic(l+(2*m*n))));
            end
        else
            for i=1:size(mask_models,3)
                l=find(mask_models(:,:,i)==1);
                image_segmented(l)=mean(mean(Ic(l)));
            end
        end
    end
    axes(handles.axesmain)
    imshow(mask_models(:,:,sel))
end
set(handles.currentmask,'String',num2str(sel))
resp='cancel';
set(menu.gen,'visible','off');

function documentation_Callback(hObject, eventdata, handles)
 winopen('Users guide ImageS.pdf')
 function license_Callback(hObject, eventdata, handles)
 winopen('licencia.pdf')
function webpage_Callback(hObject, eventdata, handles)
 web('http://www.laima-uaslp.org/researchers.html','-new','-notoolbar','-browser')
 
function colaboration_Callback(hObject, eventdata, handles)
 web('http://www.laima-uaslp.org/contact.html','-new','-notoolbar','-browser')
 
 
 
function myzoom(hObject, eventdata, handles)
% Callbacks pass 2 arguments by default: the handle of the source and a
% structure called eventdata. Right now we don't need eventdata so it's
% ignored.
% I've also passed the handles structure so we can easily address
% everything in our GUI
% Get toggle state: 1 is on, 0 is off
global zo menu
zo=1-zo;
if zo==1
[i_t,~]=imread('zoomi2.png');
else  
[i_t,~]=imread('zoomi.png');
end
i_t=imresize(i_t,[25,25]);
set(menu.zoomt,'CData',i_t);  

switch zo
    case 1
        % Toggle on, turn on zoom
        zoom(handles.axesmain, 'on')
    case 0
        % Toggle off, turn off zoom
        zoom(handles.axesmain, 'off')
end
