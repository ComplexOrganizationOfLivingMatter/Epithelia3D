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

% Last Modified by GUIDE v2.5 06-Sep-2018 16:59:12

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

% Update handles structure
guidata(hObject, handles);
resizeImg = getappdata(0,'resizeImg');
outputDir = getappdata(0,'outputDir');
imageSequenceFiles = dir(fullfile(outputDir, 'ImageSequence'));
imageSequence = {};

for numImg = 3:size(imageSequenceFiles, 1)
    actualFile = imageSequenceFiles(numImg);
    actualImg = imread(fullfile(actualFile.folder, actualFile.name));
    imageSequence(end+1) = {imresize3(actualImg, resizeImg)};
end

setappdata(0,'imageSequence',imageSequence);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using window.
if strcmp(get(hObject,'Visible'),'off')
    imshow(imageSequence{1});
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
selectCellId = str2double(get(hObject,'String'));
labelledImage = getappdata(0, 'labelledImage');
selectedZ = getappdata(0, 'selectedZ');

perimImg = bwperim(labelledImage(:, :,  selectedZ) == selectCellId)';
%imshow(perimImg);
imageSequence = getappdata(0, 'imageSequence');

tipValue = 5;

imgToShow = imageSequence{selectedZ};
differenceOfSize = size(imgToShow) - size(perimImg) - tipValue;
imgToShow = imgToShow(differenceOfSize(1)+1:size(imgToShow, 1), differenceOfSize(2)+1:size(imgToShow, 2), :);

[xOld, yOld, zOld] = ind2sub(size(perimImg),find(perimImg == 1));
newIndices = sub2ind(size(imgToShow), xOld, yOld, zOld);

imgToShow(newIndices) = 65536;
imshow(labelledImage(:, :,  selectedZ)');
imshow(imgToShow);


function tbZFrame_Callback(hObject, eventdata, handles)
% hObject    handle to tbZFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbZFrame as text
%        str2double(get(hObject,'String')) returns contents of tbZFrame as a double
imageSequence = getappdata(0, 'imageSequence');
setappdata(0, 'selectedZ', str2double(get(hObject,'String')));
imshow(imageSequence{str2double(get(hObject,'String'))});


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
newCellRegion = roipoly;
