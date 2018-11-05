function varargout = window(varargin)
% WINDOW MATLAB code for window.fig
%      WINDOW, by itself, creates a new WINDOW or raises the existing
%      singleton*.
%
%      H = WINDOW returns the handle to a new WINDOW or the handle to
%      the existing singleton*.
%
%      WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WINDOW.M with the given input arguments.
%
%      WINDOW('Property','Value',...) creates a new WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help window

% Last Modified by GUIDE v2.5 11-Sep-2018 10:37:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @window_OpeningFcn, ...
                   'gui_OutputFcn',  @window_OutputFcn, ...
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

% --- Executes just before window is made visible.
function window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to window (see VARARGIN)

% Choose default command line output for window
handles.output = hObject;

set(0, 'currentfigure', hObject); 

setappdata(0, 'labelledImageTemp', getappdata(0, 'labelledImage'));

% Update handles structure
guidata(hObject, handles);
resizeImg = getappdata(0,'resizeImg');
outputDir = getappdata(0,'outputDir');
imageSequenceFiles = dir(fullfile(outputDir, 'ImageSequence/*.tif'));
NoValidFiles = startsWith({imageSequenceFiles.name},'._','IgnoreCase',true);
imageSequenceFiles = imageSequenceFiles(~NoValidFiles);
imageSequence = [];

tipValue = getappdata(0, 'tipValue');
setappdata(0, 'selectedZ', 1+tipValue+1);
setappdata(0, 'cellId', 1);
%glandOrientation = getappdata(0, 'glandOrientation');

for numImg = 1:size(imageSequenceFiles, 1)
    actualFile = imageSequenceFiles(numImg);
    actualImg = imread(fullfile(actualFile.folder, actualFile.name));
    %actualImg = flip(actualImg);
    %actualImg = imrotate(actualImg, glandOrientation);
    %imageSequence(end+1) = {imresize(fliplr(flip(actualImg')), resizeImg, 'nearest')};
    %imageSequence(end+1) = {imresize(actualImg, resizeImg, 'nearest')};
    imageSequence(:, :, numImg) = imresize(actualImg, resizeImg, 'nearest');
end

imageSequence = addTipsImg3D(tipValue+1, double(imageSequence));

orientationGland = regionprops3(imageSequence>0, 'Orientation');
glandOrientation = -orientationGland.Orientation(1);
imageSequence = flip(imrotate(imageSequence, glandOrientation));

setappdata(0,'imageSequence',imageSequence);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using window.
if strcmp(get(hObject,'Visible'),'off')
    showSelectedCell()
end

% UIWAIT makes window wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
roiMask = getappdata(0, 'roiMask');
if roiMask ~= -1
    delete(roiMask);
    roiMask = -1;
    setappdata(0, 'roiMask', roiMask);
    newCellRegion = getappdata(0, 'newCellRegion');
    selectCellId = getappdata(0, 'cellId');
    labelledImage = getappdata(0, 'labelledImageTemp');
    selectedZ = getappdata(0, 'selectedZ');
    lumenImage = getappdata(0, 'lumenImage');

    if sum(newCellRegion(:)) > 0
        [x, y] = find(newCellRegion);

        newCellRegion = zeros(size(newCellRegion));
        newIndices = sub2ind(size(labelledImage), x, y, ones(length(x), 1)*selectedZ);

        labelledImage(newIndices) = selectCellId;
        labelledImage(lumenImage>0) = 0;

        %Smooth surface of next and previos Z
        labelledImage = smoothCellContour3D(labelledImage, selectCellId, (selectedZ-3):(selectedZ+3), lumenImage);

        setappdata(0, 'labelledImageTemp', labelledImage);
        showSelectedCell();
    end
end


% --- Executes during object creation, after setting all properties.
function tbCellId_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbCellId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tbCellId_Callback(hObject, eventdata, handles)
% hObject    handle to tbZFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbZFrame as text
%        str2double(get(hObject,'String')) returns contents of tbZFrame as a double
setappdata(0,'cellId',str2double(get(hObject,'String')));
showSelectedCell();


function tbZFrame_Callback(hObject, eventdata, handles)
% hObject    handle to tbZFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbZFrame as text
%        str2double(get(hObject,'String')) returns contents of tbZFrame as a double
tipValue = getappdata(0, 'tipValue');
labelledImage = getappdata(0, 'labelledImageTemp');
newFrameValue = str2double(get(hObject,'String'));
if newFrameValue > 0 && newFrameValue + tipValue + 1 <= size(labelledImage, 3)
    setappdata(0, 'selectedZ', newFrameValue + (tipValue + 1));
    showSelectedCell();
end


% --- Executes during object creation, after setting all properties.
function tbZFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbZFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in insertROI.
function insertROI_Callback(hObject, eventdata, handles)
% hObject    handle to insertROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
roiMask = getappdata(0, 'roiMask');
if roiMask ~= -1
    delete(roiMask);
end
roiMask = impoly(gca);
newCellRegion = createMask(roiMask);
setappdata(0,'roiMask', roiMask);
setappdata(0,'newCellRegion', newCellRegion);


% --- Executes on button press in increaseID.
function increaseID_Callback(hObject, eventdata, handles)
% hObject    handle to increaseID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newValue = getappdata(0, 'cellId')+1;
labelledImage = getappdata(0, 'labelledImageTemp');

if newValue <= max(labelledImage(:))
    setappdata(0, 'cellId', newValue);
    set(handles.tbCellId,'string',num2str(newValue));
    showSelectedCell();
end

% --- Executes on button press in decreaseID.
function decreaseID_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newValue = getappdata(0, 'cellId')-1;
if newValue > 0
    setappdata(0, 'cellId', newValue);
    set(handles.tbCellId,'string',num2str(newValue));
    showSelectedCell();
end

% --- Executes on button press in increaseZ.
function increaseZ_Callback(hObject, eventdata, handles)
% hObject    handle to increaseZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newValue = getappdata(0, 'selectedZ')+1;
labelledImage = getappdata(0, 'labelledImageTemp');
tipValue = getappdata(0, 'tipValue');

if newValue <= (size(labelledImage, 3)-(tipValue+1))
    setappdata(0, 'selectedZ', newValue);
    set(handles.tbZFrame,'string',num2str(newValue-(tipValue+1)));
    showSelectedCell();
end

% --- Executes on button press in decreaseZ.
function decreaseZ_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newValue = getappdata(0, 'selectedZ')-1;
tipValue = getappdata(0, 'tipValue');
if newValue >= (tipValue+2)
    tipValue = getappdata(0, 'tipValue');
    setappdata(0, 'selectedZ', newValue);
    set(handles.tbZFrame,'string',num2str(newValue-(tipValue+1)));
    showSelectedCell();
end
