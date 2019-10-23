function heyitsaGUI
% Set up a basic GUI
h.mainwindow = figure( ... % Main figure window
    'Units','pixels', ...
    'Position',[100 100 800 800], ...
    'MenuBar','none', ...
    'ToolBar','none' ...
    );

h.myaxes = axes( ...
    'Parent', h.mainwindow, ...
    'Position', [0.1 0.15 0.8 0.8] ...
    );

h.zoomtoggle = uicontrol( ...
    'Style', 'togglebutton', ...
    'Parent', h.mainwindow, ...
    'Units', 'Normalized', ...
    'Position', [0.4 0.05 0.2 0.05], ...
    'String', 'Toggle Zoom', ...
    'Callback', {@myzoombutton, h} ... % Pass along the handle structure as well as the default source and eventdata values
    );

% Plot some data
plot(1:10);
end

function myzoombutton(source, ~, h)
% Callbacks pass 2 arguments by default: the handle of the source and a
% structure called eventdata. Right now we don't need eventdata so it's
% ignored.
% I've also passed the handles structure so we can easily address
% everything in our GUI
% Get toggle state: 1 is on, 0 is off
togglestate = 1;

switch togglestate
    case 1
        % Toggle on, turn on zoom
        zoom(h.myaxes, 'on')
    case 0
        % Toggle off, turn off zoom
        zoom(h.myaxes, 'off')
end
end