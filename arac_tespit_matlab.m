function varargout = arac_tespit_matlab(varargin)
% ARAC_TESPIT_MATLAB MATLAB code for arac_tespit_matlab.fig
%      ARAC_TESPIT_MATLAB, by itself, creates a new ARAC_TESPIT_MATLAB or raises the existing
%      singleton*.
%
%      H = ARAC_TESPIT_MATLAB returns the handle to a new ARAC_TESPIT_MATLAB or the handle to
%      the existing singleton*.
%
%      ARAC_TESPIT_MATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARAC_TESPIT_MATLAB.M with the given input arguments.
%
%      ARAC_TESPIT_MATLAB('Property','Value',...) creates a new ARAC_TESPIT_MATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arac_tespit_matlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arac_tespit_matlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help arac_tespit_matlab

% Last Modified by GUIDE v2.5 05-Apr-2021 19:25:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arac_tespit_matlab_OpeningFcn, ...
                   'gui_OutputFcn',  @arac_tespit_matlab_OutputFcn, ...
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


% --- Executes just before arac_tespit_matlab is made visible.
function arac_tespit_matlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arac_tespit_matlab (see VARARGIN)

% Choose default command line output for arac_tespit_matlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arac_tespit_matlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = arac_tespit_matlab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes during object creation, after setting all properties.
function userInput_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    
    set(hObject,'BackgroundColor','white');
    
end


% --- Executes on button press in pushbutton3.
function calistir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cleanForeground;
global foreground;
global filename;

videoReader = vision.VideoFileReader(filename); 
videoPlayer = vision.VideoPlayer;
fgPlayer = vision.VideoPlayer;


foregroundDetector = vision.ForegroundDetector('NumGaussians', 3,'NumTrainingFrames', 50);
 
for i = 1:150
    videoFrame = step(videoReader);
    foreground = step(foregroundDetector,videoFrame);
end

%figure;
%imshow(videoFrame);
%title('Input Frame');
%figure;
%imshow(foreground);
%title('Foreground');
 
%cleanForeground = imopen(foreground, strel('Disk',1));
figure;
subplot(1,2,1);imshow(foreground);title('Original Foreground');
subplot(1,2,2);imshow(cleanForeground);title('Clean Foreground');


blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 150);
 

global aracSay preNumcars
aracSay=0;
preNumcars=0;

while  ~isDone(videoReader)
    global aracSay preNumcars
    videoFrame = step(videoReader);
    foreground = step(foregroundDetector,videoFrame);
    cleanForeground = imopen(foreground, strel('Disk',1));
    bbox = step(blobAnalysis, cleanForeground);
 
    result = insertShape(videoFrame, 'Rectangle', bbox, 'Color', 'green');
   
    numCars = size(bbox, 1);
    if (numCars > preNumcars)
        aracSay=aracSay+(numCars-preNumcars);
    end
    preNumcars = numCars;
    
    
    text = sprintf('Anl�k Ara� Say�s� : %d',numCars);
    
    result = insertText(result, [10 10], text, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
    
    text2 = sprintf('Toplam Ara� Say�s� : %d',aracSay);
    result = insertText(result, [10 40], text2, 'BoxOpacity', 1, ...
        'FontSize', 14);
 
     step(videoPlayer, result);
     %step(fgPlayer,cleanForeground);
 
    
end
release(videoPlayer);
%release(videoReader);
%release(fgPlayer);
set(handles.toplamSayi,'String',aracSay);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global cleanForeground;
axes(handles.axes1)
imshow(cleanForeground);




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global filename;
[filename pathname]=uigetfile({'*'},'File Selector');
fullpathname=strcat(pathname,filename);
set(handles.userInput,'String',filename);




% --- Executes during object creation, after setting all properties.
function toplamSayi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toplamSayi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
