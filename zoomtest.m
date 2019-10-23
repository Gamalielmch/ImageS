function varargout = zoomtest(varargin)
  gui_Singleton = 1;
% % gui_State = struct('gui_Name',       mfilename, ...
% %                    'gui_Singleton',  gui_Singleton, ...
% %                    'gui_OpeningFcn', @zoomtest_OpeningFcn, ...
% %                    'gui_OutputFcn',  @zoomtest_OutputFcn, ...
% %                    'gui_LayoutFcn',  [] , ...
% %                    'gui_Callback',   []);
% % if nargin && ischar(varargin{1})
% %     gui_State.gui_Callback = str2func(varargin{1});
% % end
% %  if nargout
% %     [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% %  else
% %     gui_mainfcn(gui_State, varargin{:});
% %  end
 function zoomtest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zoomtest (see VARARGIN)
 % Choose default command line output for zoomtest
 handles.output = hObject;
 % Read in standard MATLAB demo image.
 grayImage = imread('football.jpg');
 axes(handles.axesImage);
 imshow(grayImage, []);
 title('Original Grayscale Image');
 % Set up zoom slider
 minZoom = get(handles.sldZoom, 'min')
 maxZoom = get(handles.sldZoom, 'max')
 set(handles.sldZoom, 'value', minZoom);
 % set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
 % Update handles structure
 guidata(hObject, handles);
 function sldZoom_Callback(hObject, eventdata, handles)
 % hObject    handle to sldZoom (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    structure with handles and user data (see GUIDATA) 
 % Hints: get(hObject,'Value') returns position of slider
 % get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 zoomFactor = get(hObject,'Value');
 axes(handles.axesImage);
 zoom('out');
 zoom(zoomFactor);
 txtInfo = sprintf('Zoom Factor = %.2f (%d %%)\n\nOnce zoomed, you can pan  by clicking and dragging in the image.', zoomFactor, round(zoomFactor * 100));
 set(handles.txtInfo, 'String', txtInfo);
 txtInfo = sprintf('Zoom Factor = %.2f\n\nOnce zoomed, you can pan by   clicking and dragging in the image.', zoomFactor); 
 set(handles.sldZoom, 'TooltipString', txtInfo);
 txtZoom = sprintf('Zoom Factor = %.2f (%d %%)',     zoomFactor,round(zoomFactor * 100));
 set(handles.txtZoom, 'String', txtZoom);
 set(handles.axesImage, 'ButtonDownFcn', 'disp(''This executes'')');
 set(handles.axesImage, 'Tag', 'DoNotIgnore');
 h = pan;
 set(h, 'ButtonDownFilter', @myPanCallbackFunction);
 set(h, 'Enable', 'on');
 return;
 function [flag] = myPanCallbackFunction(obj, eventdata)
 % If the tag of the object is 'DoNotIgnore', then return true.
 % Indicate what the target is
 disp(['In myPanCallbackFunction, you clicked on a ' get(obj,'Type')  'object.'])
 objTag = get(obj, 'Tag');
 if strcmpi(objTag, 'DoNotIgnore')
 flag = true;
 else
 flag = false;
 end
 return;
 % --- Executes during object creation, after setting all properties.
 function sldZoom_CreateFcn(hObject, eventdata, handles)
 % hObject    handle to sldZoom (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    empty - handles not created until after all CreateFcns called
 % Hint: slider controls usually have a light gray background. 
 if isequal(get(hObject,'BackgroundColor'),  get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
 end