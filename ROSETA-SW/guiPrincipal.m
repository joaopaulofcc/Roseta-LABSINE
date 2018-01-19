%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#           Script responsible to draw and coordenate the GUI.          #
%#                                                                       #
%#                                                                       #
%# STUDENT                                                               #
%#                                                                       #
%#     João Paulo Fernanades de Cerqueira César                          #
%#                                                                       #
%# ADVISOR                                                               #
%#                                                                       #
%#     Wilian Soares Lacerda                                             #
%#                                                                       #
%#-----------------------------------------------------------------------#
%#                                                                       #
%# File: guiPrincipal.m                                                  #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################


function varargout = guiPrincipal(varargin)

% Edit the above text to modify the response to help guiPrincipal

% Last Modified by GUIDE v2.5 22-Nov-2017 00:44:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiPrincipal_OpeningFcn, ...
                   'gui_OutputFcn',  @guiPrincipal_OutputFcn, ...
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


% --------------------------------------------------------------------

% Method executed when opening the GUI.
function guiPrincipal_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for guiPrincipal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Calls the script to initialize all script and executable paths that
% will be used throughout the scripts
startPaths;
startPaths;
startPaths;
startPaths;
startPaths;

% Reposition the screen to the middle of the monitor.
movegui(gcf,'center')

% Load the LABSINE image.
axes(handles.axes_imgLABSINE)
logoLABSINE = imread('logoLABSINE.jpg');
imageLogoLABSINE = image(logoLABSINE);
imageLogoLABSINE.ButtonDownFcn = @axes_imgLABSINE_ButtonDownFcn;
axis off
axis image

% Load the UFLA image.
axes(handles.axes_imgUFLA)
logoUFLA = imread('logoUFLA.jpg');
imageLogoUFLA = image(logoUFLA);
imageLogoUFLA.ButtonDownFcn = @axes_imgUFLA_ButtonDownFcn;
axis off
axis image


%% Configures GUI fields with default values, which will be displayed
% as soon as the GUI is opened.

% Generator.
handles.popupGenerator = 'Trivium';

% Path to the image file.
handles.imagePath = [];

% Path to the keystream files.
handles.keystreamPath = [];
handles.keystreamSensitivityPath = [];

% Image resize dimensions.
handles.imgResizeHeight = [];
handles.imgResizeWidth  = [];

% Flag for choice of operation via software or FPGA.
handles.flagFPGA = 0;
handles.flagSoftware = 1;

% Flag for choice between image file or webcam capture.
handles.radioFile = 1;
handles.radioWebcam = 0;

% Flag to enable image resizing.
handles.resize = 'off';

% Flag to enable the csv output file generation.
handles.csv = 1;

% Name of csv file to be generated.
handles.csvFileName = 'outputCSV';

% Flag to enable the verbose output.
handles.verbose = 1;

% Number of pixel samples to be processed in correlation analysis.
handles.samples = 5000;

% Path of random seed file.
handles.seedIN = [];


% Checks if there are webcams installed on the computer, if there are loads
% the list with the supported resolutions, otherwise update flag to 0.
camList = webcamlist;

if isempty(camList)
    
    handles.existsWebcam = 0;
    
else
    
    handles.existsWebcam = 1;
    
    cam = webcam();
    set(handles.popup_imgResolution,'String',cam.AvailableResolutions);
    delete(cam);
    
end

% Axes used as an auxiliar to display images.
axesDummy = axes();
set(axesDummy, 'Visible', 'off');


% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Outputs from this function are returned to the command line.
function varargout = guiPrincipal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on selection change in popup_chooseGenerator.
function popup_chooseGenerator_Callback(hObject, eventdata, handles)
% hObject    handle to popup_chooseGenerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_chooseGenerator contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_chooseGenerator

contents = cellstr(get(hObject,'String'));
handles.popupGenerator = contents{get(hObject,'Value')};

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popup_chooseGenerator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_chooseGenerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in btn_imgOpenFile.
function btn_imgOpenFile_Callback(hObject, eventdata, handles)

% Filter with supported file extensions.
filtros = {'*.jpg'; '*.bmp'; '*.png'};

% Opens file selection dialog.
[fname, pname, findex] =  uigetfile(filtros, 'Escolha uma Imagem');

% If the path is valid, or the user did not close the dialog box.
if findex ~= 0

    % Gets the full path of image.
    filename = fullfile(pname, fname);

    % Shows the path.
    handles.text_imgFilePath.String = fname;

    % Saves the path in handles variable.
    handles.imagePath = filename;
    
    % Opens the selected image to check if it is RGB or grayscale.
    imgRead = imread(filename);
    
    % If image is represented in grayscale mode chenge the color popup
    % to display the "Gray" value.
    if ( size(imgRead, 3) == 1 )

        set(handles.popup_imgColor, 'Value', 2);
        
        handles.panel_resultsRGB.Visible = 'off';
        handles.panel_resultsGray.Visible = 'on';
        
        handles.color = 'gray';
        
    end
    
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in btn_imgWebcam.
function btn_imgWebcam_Callback(hObject, eventdata, handles)

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Procedure triggered when making a change in imgResizeHeight
function edit_imgResizeHeight_Callback(hObject, eventdata, handles)

% Get the new value.
handles.imgResizeHeight = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_imgResizeHeight_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes after any change in the imgResizeWidth Edit Text.
function edit_imgResizeWidth_Callback(hObject, eventdata, handles)

handles.imgResizeWidth = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_imgResizeWidth_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------


% -------------------------------------------------------------------------

% -- Resets all information in the results tab for grayscale image.
function erase_resultsGray(handles)

% Reset the axes for image files (original, cipher and decipher).
cla(handles.axes_grayOriginalImage, 'reset');
set(handles.axes_grayOriginalImage, 'XTick', []);
set(handles.axes_grayOriginalImage, 'YTick', []);

cla(handles.axes_grayCipherImage, 'reset');
set(handles.axes_grayCipherImage, 'XTick', []);
set(handles.axes_grayCipherImage, 'YTick', []);

cla(handles.axes_grayDecipherImage, 'reset');
set(handles.axes_grayDecipherImage, 'XTick', []);
set(handles.axes_grayDecipherImage, 'YTick', []);



% Reset the axes for image histograms (original, cipher and decipher).
cla(handles.axes_grayOriginalHist, 'reset');
set(handles.axes_grayOriginalHist, 'XTick', []);
set(handles.axes_grayOriginalHist, 'YTick', []);

cla(handles.axes_grayCipherHist, 'reset');
set(handles.axes_grayCipherHist, 'XTick', []);
set(handles.axes_grayCipherHist, 'YTick', []);

cla(handles.axes_grayDecipherHist, 'reset');
set(handles.axes_grayDecipherHist, 'XTick', []);
set(handles.axes_grayDecipherHist, 'YTick', []);



% Reset the values of all edit texts.
set(handles.text_valueGrayOriginalEntropy,          'String', []);
set(handles.text_valueGrayOriginalIntensity,        'String', []);
set(handles.text_valueGrayHorzOriginalCorrelation,  'String', []);
set(handles.text_valueGrayVertOriginalCorrelation,  'String', []);
set(handles.text_valueGrayDiagOriginalCorrelation,  'String', []);
set(handles.text_valueGrayCipherEntropy,            'String', []);
set(handles.text_valueGrayCipherIntensity,          'String', []);
set(handles.text_valueGrayHorzCipherCorrelation,    'String', []);
set(handles.text_valueGrayVertCipherCorrelation,    'String', []);
set(handles.text_valueGrayDiagCipherCorrelation,    'String', []);
set(handles.text_valueGrayDecipherEntropy,          'String', []);
set(handles.text_valueGrayDecipherIntensity,        'String', []);
set(handles.text_valueGrayHorzDecipherCorrelation,  'String', []);
set(handles.text_valueGrayVertDecipherCorrelation,  'String', []);
set(handles.text_valueGrayDiagDecipherCorrelation,  'String', []);
set(handles.text_valueGrayUACI,                     'String', []);
set(handles.text_valueGrayNPCR,                     'String', []);
set(handles.text_valueGrayKeySensitivityCipher,     'String', []);
set(handles.text_valueGrayKeySensitivityDecipher,   'String', []);



% -- Resets all information in the results tab for RGB image.
function erase_resultsRGB(handles)

% Reset the axes for image files (original, cipher and decipher).
cla(handles.axes_rgbOriginalImage, 'reset');
set(handles.axes_rgbOriginalImage, 'XTick', []);
set(handles.axes_rgbOriginalImage, 'YTick', []);

cla(handles.axes_rgbCipherImage, 'reset');
set(handles.axes_rgbCipherImage, 'XTick', []);
set(handles.axes_rgbCipherImage, 'YTick', []);

cla(handles.axes_rgbDecipherImage, 'reset');
set(handles.axes_rgbDecipherImage, 'XTick', []);
set(handles.axes_rgbDecipherImage, 'YTick', []);



% Reset the axes for original image histogram.
cla(handles.axes_rgbRedOriginalHist, 'reset');
set(handles.axes_rgbRedOriginalHist,'XTick', []);
set(handles.axes_rgbRedOriginalHist,'YTick', []);

cla(handles.axes_rgbGreenOriginalHist, 'reset');
set(handles.axes_rgbGreenOriginalHist,'XTick', []);
set(handles.axes_rgbGreenOriginalHist,'YTick', []);

cla(handles.axes_rgbBlueOriginalHist, 'reset');
set(handles.axes_rgbBlueOriginalHist,'XTick', []);
set(handles.axes_rgbBlueOriginalHist,'YTick', []);



% Reset the axes for cipher image histogram.
cla(handles.axes_rgbRedCipherHist, 'reset');
set(handles.axes_rgbRedCipherHist,'XTick', []);
set(handles.axes_rgbRedCipherHist,'YTick', []);

cla(handles.axes_rgbGreenCipherHist, 'reset');
set(handles.axes_rgbGreenCipherHist,'XTick', []);
set(handles.axes_rgbGreenCipherHist,'YTick', []);

cla(handles.axes_rgbBlueCipherHist, 'reset');
set(handles.axes_rgbBlueCipherHist,'XTick', []);
set(handles.axes_rgbBlueCipherHist,'YTick', []);



% Reset the axes for decipher image histogram.
cla(handles.axes_rgbRedDecipherHist, 'reset');
set(handles.axes_rgbRedDecipherHist,'XTick', []);
set(handles.axes_rgbRedDecipherHist,'YTick', []);

cla(handles.axes_rgbGreenDecipherHist, 'reset');
set(handles.axes_rgbGreenDecipherHist,'XTick', []);
set(handles.axes_rgbGreenDecipherHist,'YTick', []);

cla(handles.axes_rgbBlueDecipherHist, 'reset');
set(handles.axes_rgbBlueDecipherHist,'XTick', []);
set(handles.axes_rgbBlueDecipherHist,'YTick', []);



% Reset the values of all edit texts.
set(handles.text_valueRGBOriginalEntropy,           'String', []);
set(handles.text_valueRGBCipherEntropy,             'String', []);
set(handles.text_valueRGBDecipherEntropy,           'String', []);
set(handles.text_valueRGBRedOriginalIntensity,      'String', []);
set(handles.text_valueRGBGreenOriginalIntensity,    'String', []);
set(handles.text_valueRGBBlueOriginalIntensity,     'String', []);
set(handles.text_valueRGBRedCipherIntensity,        'String', []);
set(handles.text_valueRGBGreenCipherIntensity,      'String', []);
set(handles.text_valueRGBBlueCipherIntensity,       'String', []);
set(handles.text_valueRGBRedDecipherIntensity,      'String', []);
set(handles.text_valueRGBGreenDecipherIntensity,    'String', []);
set(handles.text_valueRGBBlueDecipherIntensity,     'String', []);
set(handles.text_valueRGBHorzOriginalCorrelation,   'String', []);
set(handles.text_valueRGBVertOriginalCorrelation,   'String', []);
set(handles.text_valueRGBDiagOriginalCorrelation,   'String', []);
set(handles.text_valueRGBHorzCipherCorrelation,     'String', []);
set(handles.text_valueRGBVertCipherCorrelation,     'String', []);
set(handles.text_valueRGBDiagCipherCorrelation,     'String', []);
set(handles.text_valueRGBHorzDecipherCorrelation,   'String', []);
set(handles.text_valueRGBVertDecipherCorrelation,   'String', []);
set(handles.text_valueRGBDiagDecipherCorrelation,   'String', []);
set(handles.text_valueRGBUACI,                      'String', []);
set(handles.text_valueRGBNPCR,                      'String', []);
set(handles.text_valueRGBKeySensitivityCipher,      'String', []);
set(handles.text_valueRGBKeySensitivityDecipher,    'String', []);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%      METHOD RESPONSIBLE FOR SELECTING THE COLOR MODE OF THE IMAGE.      %
%                                                                         %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -- Method responsible for selection the color mode of the image. 
% -- Executes on selection change in popup_imgColor.
function popup_imgColor_Callback(hObject, eventdata, handles)

% Gets the popup selected value
contents = cellstr(get(hObject,'String'));
colorSelected = contents{get(hObject,'Value')};

% According to the selected item displays the appropriate results panel.
if(strcmp(colorSelected,'RGB'))
   
    % Reads the image file you entered to see if you can apply the color 
    % rendering mode change. That is, a grayscale image can not be converted to RGB
    imgRead = imread(handles.imagePath);
    
    % If image is represented in grayscale mode and the user wants to process
    % the correspondent in RGB mode, show an error message.
    if ( size(imgRead, 3) == 1 )

        warndlg('The selected image only allows Grayscale color mode!');
        
        % Keep the settings adjusted for grayscale.
        set(hObject, 'Value', 2);
        
        handles.panel_resultsRGB.Visible = 'off';
        handles.panel_resultsGray.Visible = 'on';
        
        handles.color = 'gray';
    
    % Otherwise chenge the settings to RGB.
    else
        
        handles.panel_resultsRGB.Visible = 'on';
        handles.panel_resultsGray.Visible = 'off';
    
        handles.color = 'rgb';
        
    end

% If the color selected was grayscale, immediately changes the settings to grayscale.
else
    
    handles.panel_resultsRGB.Visible = 'off';
    handles.panel_resultsGray.Visible = 'on';
    
    handles.color = 'gray';
    
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popup_imgColor_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.color = 'rgb';

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------




                                        
% -------------------------------------------------------------------------

function edit_keyValue_Callback(hObject, eventdata, handles)

handles.Key = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_keyValue_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.Key = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

function edit_ivValue_Callback(hObject, eventdata, handles)

handles.IV = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_ivValue_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.IV = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on selection change in popup_baudRate.
function popup_baudRate_Callback(hObject, eventdata, handles)

% Get the value of the selected item position
contents = cellstr(get(hObject,'String'));

handles.baud = str2num(contents{get(hObject,'Value')});

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popup_baudRate_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
% Get the value of the selected item position.
contents = cellstr(get(hObject,'String'));

handles.baud = contents{get(hObject,'Value')};

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in check_verboseActivate.
function check_verboseActivate_Callback(hObject, eventdata, handles)

% Get ckeckbox value.
handles.verbose = get(hObject,'Value');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in check_csvActivate.
function check_csvActivate_Callback(hObject, eventdata, handles)

% Get ckeckbox value.
handles.csv = get(hObject,'Value');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on selection change in popup_comPort.
function popup_comPort_Callback(hObject, eventdata, handles)

% Get popup selected value.
contents = cellstr(get(hObject,'String'));

handles.com = contents{get(hObject,'Value')};

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popup_comPort_CreateFcn(hObject, eventdata, handles)

% Get popup selected value.
contents = cellstr(get(hObject,'String'));

handles.com = contents{get(hObject,'Value')};

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% -- Method responsible for displaying the results, numerical and graphical, 
% -- after processing. The results are displayed on the correct tab according 
% -- to the color representation of the image (grayscale or RGB).
function showResults(handles, paths, entropyOUT, intensityOUT, correlationOUT, diffusionOUT, sensitivityOUT)

    % RGB images.
    if strcmp(handles.color, 'rgb')

        % Image Plots.
        
        % Plain image plot.
        axes(handles.axes_rgbOriginalImage)
        originalImage = imread(fullfile(paths{1}, '/images/imgPlainFull.bmp'));
        image(originalImage)
        axis off
        axis image

        % Cipher image plot.
        axes(handles.axes_rgbCipherImage)
        cipherImage = imread(fullfile(paths{1}, '/images/imgCipherFull.bmp'));
        image(cipherImage)
        axis off
        axis image

        % Decipher image plot.
        axes(handles.axes_rgbDecipherImage)
        decipherImage = imread(fullfile(paths{1}, '/images/imgDecipherFull.bmp'));
        image(decipherImage)
        axis off
        axis image


        % Histogram Plots.
    
        % Plain image - Red channel histogram.
        axes(handles.axes_rgbRedOriginalHist)
        plainRedHist = imread(fullfile(paths{2}, '/plain/histPlainRed.png'));
        image(plainRedHist)
        axis off
        axis image

        
        % Plain image - Green channel histogram.
        axes(handles.axes_rgbGreenOriginalHist)
        plainGreenHist = imread(fullfile(paths{2}, '/plain/histPlainGreen.png'));
        image(plainGreenHist)
        axis off
        axis image

        
        % Plain image - Blue channel histogram.
        axes(handles.axes_rgbBlueOriginalHist)
        plainBlueHist = imread(fullfile(paths{2}, '/plain/histPlainBlue.png'));
        image(plainBlueHist)
        axis off
        axis image



        % Cipher image - Red channel histogram.
        axes(handles.axes_rgbRedCipherHist)
        cipherRedHist = imread(fullfile(paths{2}, '/cipher/histCipherRed.png'));
        image(cipherRedHist)
        axis off
        axis image


        % Cipher image - Green channel histogram.
        axes(handles.axes_rgbGreenCipherHist)
        cipherGreenlHist = imread(fullfile(paths{2}, '/cipher/histCipherGreen.png'));
        image(cipherGreenlHist)
        axis off
        axis image


        % Cipher image - Blue channel histogram.
        axes(handles.axes_rgbBlueCipherHist)
        cipherBlueHist = imread(fullfile(paths{2}, '/cipher/histCipherBlue.png'));
        image(cipherBlueHist)
        axis off
        axis image



        % Decipher image - Red channel histogram.
        axes(handles.axes_rgbRedDecipherHist)
        decipherRedHist = imread(fullfile(paths{2}, '/decipher/histDecipherRed.png'));
        image(decipherRedHist)
        axis off
        axis image


        % Decipher image - Green channel histogram.
        axes(handles.axes_rgbGreenDecipherHist)
        decipherGreenlHist = imread(fullfile(paths{2}, '/decipher/histDecipherGreen.png'));
        image(decipherGreenlHist)
        axis off
        axis image


        % Decipher image - Blue channel histogram.
        axes(handles.axes_rgbBlueDecipherHist)
        decipherBlueHist = imread(fullfile(paths{2}, '/decipher/histDecipherBlue.png'));
        image(decipherBlueHist)
        axis off
        axis image


        % Text Plots.
        
        % Entropy analysis.
        set(handles.text_valueRGBOriginalEntropy, 'String', num2str(entropyOUT(1), ' %.6f'));
        set(handles.text_valueRGBCipherEntropy,   'String', num2str(entropyOUT(2), ' %.6f'));
        set(handles.text_valueRGBDecipherEntropy, 'String', num2str(entropyOUT(3), ' %.6f'));

        
        % Plain intensity analysis.
        set(handles.text_valueRGBRedOriginalIntensity,   'String', num2str(intensityOUT(1), ' %.6f'));
        set(handles.text_valueRGBGreenOriginalIntensity, 'String', num2str(intensityOUT(2), ' %.6f'));
        set(handles.text_valueRGBBlueOriginalIntensity,  'String', num2str(intensityOUT(3), ' %.6f'));

        % Cipher intensity analysis.
        set(handles.text_valueRGBRedCipherIntensity,   'String', num2str(intensityOUT(4), ' %.6f'));
        set(handles.text_valueRGBGreenCipherIntensity, 'String', num2str(intensityOUT(5), ' %.6f'));
        set(handles.text_valueRGBBlueCipherIntensity,  'String', num2str(intensityOUT(6), ' %.6f'));

        % Decipher intensity analysis.
        set(handles.text_valueRGBRedDecipherIntensity,   'String', num2str(intensityOUT(7), ' %.6f'));
        set(handles.text_valueRGBGreenDecipherIntensity, 'String', num2str(intensityOUT(8), ' %.6f'));
        set(handles.text_valueRGBBlueDecipherIntensity,  'String', num2str(intensityOUT(9), ' %.6f'));

        
        % Plain correlation analysis.
        set(handles.text_valueRGBHorzOriginalCorrelation,  'String', num2str(correlationOUT(1), ' %.6f'));
        set(handles.text_valueRGBVertOriginalCorrelation,  'String', num2str(correlationOUT(2), ' %.6f'));
        set(handles.text_valueRGBDiagOriginalCorrelation,  'String', num2str(correlationOUT(3), ' %.6f'));

        % Cipher correlation analysis.
        set(handles.text_valueRGBHorzCipherCorrelation,  'String', num2str(correlationOUT(4), ' %.6f'));
        set(handles.text_valueRGBVertCipherCorrelation,  'String', num2str(correlationOUT(5), ' %.6f'));
        set(handles.text_valueRGBDiagCipherCorrelation,  'String', num2str(correlationOUT(6), ' %.6f'));

        % Decipher correlation analysis.
        set(handles.text_valueRGBHorzDecipherCorrelation,  'String', num2str(correlationOUT(7), ' %.6f'));
        set(handles.text_valueRGBVertDecipherCorrelation,  'String', num2str(correlationOUT(8), ' %.6f'));
        set(handles.text_valueRGBDiagDecipherCorrelation,  'String', num2str(correlationOUT(9), ' %.6f'));


        % Differential analysis.
        set(handles.text_valueRGBUACI, 'String', num2str(diffusionOUT(2), ' %.6f'));
        set(handles.text_valueRGBNPCR, 'String', num2str(diffusionOUT(1), ' %.6f'));


        % Key sensitivity analysis.
        set(handles.text_valueRGBKeySensitivityCipher,   'String', num2str(sensitivityOUT(1), ' %.6f'));
        set(handles.text_valueRGBKeySensitivityDecipher, 'String', num2str(sensitivityOUT(2), ' %.6f'));  

        
    % Grayscale image.
    else

        % Image Plots.
        
        % Plain image plot.
        axes(handles.axes_grayOriginalImage)
        [X,map] = imread(fullfile(paths{1}, '/images/imgPlainFull.bmp'));
        originalImage = ind2rgb(X,map);
        image(originalImage)
        axis off
        axis image

           
        % Cipher image plot.
        axes(handles.axes_grayCipherImage)
        [X,map] = imread(fullfile(paths{1}, '/images/imgCipherFull.bmp'));
        cipherImage = ind2rgb(X,map);
        image(cipherImage)
        axis off
        axis image

        
        % Decipher image plot.
        axes(handles.axes_grayDecipherImage)
        [X,map] = imread(fullfile(paths{1}, '/images/imgDecipherFull.bmp'));
        decipherImage = ind2rgb(X,map);
        image(decipherImage)
        axis off
        axis image


        % Histogram Plots.
    
        % Plain image histogram.
        axes(handles.axes_grayOriginalHist)
        plainHist = imread(fullfile(paths{2}, '/histPlain.png'));
        image(plainHist)
        axis off
        axis image

        
        % Cipher image histogram.
        axes(handles.axes_grayCipherHist)
        cipherHist = imread(fullfile(paths{2}, '/histCipher.png'));
        image(cipherHist)
        axis off
        axis image


        % Decipher image histogram.
        axes(handles.axes_grayDecipherHist);
        decipherHist = imread(fullfile(paths{2}, '/histDecipher.png'));
        image(decipherHist)
        axis off
        axis image


        % Text Plots.
        
        % Plain entropy analysis.
        set(handles.text_valueGrayOriginalEntropy,          'String', num2str(entropyOUT(1), ' %.6f'));
        % Plain intensity analysis.
        set(handles.text_valueGrayOriginalIntensity,        'String', num2str(intensityOUT(1), ' %.6f'));
        % Plain correlation analysis.
        set(handles.text_valueGrayHorzOriginalCorrelation,  'String', num2str(correlationOUT(1), ' %.6f'));
        set(handles.text_valueGrayVertOriginalCorrelation,  'String', num2str(correlationOUT(2), ' %.6f'));
        set(handles.text_valueGrayDiagOriginalCorrelation,  'String', num2str(correlationOUT(3), ' %.6f'));

        
        % Cipher entropy analysis.
        set(handles.text_valueGrayCipherEntropy,            'String', num2str(entropyOUT(2), ' %.6f'));
        % Cipher intensity analysis.
        set(handles.text_valueGrayCipherIntensity,          'String', num2str(intensityOUT(2), ' %.6f'));
        % Cipher correlation analysis.
        set(handles.text_valueGrayHorzCipherCorrelation,    'String', num2str(correlationOUT(4), ' %.6f'));
        set(handles.text_valueGrayVertCipherCorrelation,    'String', num2str(correlationOUT(5), ' %.6f'));
        set(handles.text_valueGrayDiagCipherCorrelation,    'String', num2str(correlationOUT(6), ' %.6f'));


        % Decipher entropy analysis.
        set(handles.text_valueGrayDecipherEntropy,          'String', num2str(entropyOUT(3), ' %.6f'));
        % Decipher intensity analysis.
        set(handles.text_valueGrayDecipherIntensity,        'String', num2str(intensityOUT(3), ' %.6f'));
        % Decipher correlation analysis.
        set(handles.text_valueGrayHorzDecipherCorrelation,  'String', num2str(correlationOUT(7), ' %.6f'));
        set(handles.text_valueGrayVertDecipherCorrelation,  'String', num2str(correlationOUT(8), ' %.6f'));
        set(handles.text_valueGrayDiagDecipherCorrelation,  'String', num2str(correlationOUT(9), ' %.6f'));


        % Differential analysis.
        set(handles.text_valueGrayUACI, 'String', num2str(diffusionOUT(2), ' %.6f'));
        set(handles.text_valueGrayNPCR, 'String', num2str(diffusionOUT(1), ' %.6f'));

        
        % Key sensitivity analysis.
        set(handles.text_valueGrayKeySensitivityCipher, 'String', num2str(sensitivityOUT(1), ' %.6f'));
        set(handles.text_valueGrayKeySensitivityDecipher, 'String', num2str(sensitivityOUT(2), ' %.6f'));  

    end
    
% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in btn_executeScript.
function btn_executeScript_Callback(hObject, eventdata, handles)

% Activate controller flag.
readyToExecute = 1;

% If the user did not choose to use the webcam in the capture of the image 
% to be processed, it stores the path of the selected image file in the OS 
% folders as a variable.
if handles.radioWebcam == 0
    
    imagePath   = handles.imagePath;
    
else
    
    imagePath   = [];

end

% Value 1 is saved as parameter if the webcam is used. If there is more 
% than one webcam connected to the computer, Matlab will select the one
% with index 1.
camIndex    = 1;

% Stores the selected resolution value in the corresponding popup in the
% graphic interface.
resolution  = handles.resolution;

% If the user selected the image resizing option, inserts into a vector the
% height and width values entered in the GUI. If you did not select this option 
% the vector will be empty.
if(handles.resize == 1)
    
    resize = [str2num(handles.imgResizeHeight) str2num(handles.imgResizeWidth)];
    
else
    
    resize = [];
    
end


% Trivium cipher.
if strcmp(handles.popupGenerator, 'Trivium')
    
    % Selects the command-line option for hardware (FPGA) or software processing.
    if handles.flagFPGA == 1
    
        generator = 'triviumFPGA'; 
        
    else
        
        generator = 'trivium'; 
        
    end;
    
    % If the user did not inform the file with an existing keystream.
    if (handles.radioExistentKeystream == 0)
    
        % If you have not entered the desired values for Key or IV, produce
        % an error message and resets the control flag that enables script execution.
        if isempty(handles.Key) || isempty(handles.IV) 

            warndlg('Please enter with the Key and the IV value!');
            readyToExecute = 0;

        % Otherwise check if the size of Key and IV are correct, if they 
        % are not resets the control flag that enables script execution.
        else

            if (length(handles.Key) ~= 20) && (length(handles.IV) ~= 20)
                warndlg('The key and IV must have 80 bits (20 hexa)!');
                readyToExecute = 0;
            else
                if length(handles.Key) ~= 20
                    warndlg('The key must have 80 bits (20 hexa)!');
                    readyToExecute = 0;
                end    

                if length(handles.IV) ~= 20
                    warndlg('The IV must have 80 bits (20 hexa)!');
                    readyToExecute = 0;
                end
            end
        end
    end
    
    
% Grain cipher.
elseif strcmp(handles.popupGenerator, 'Grain')
    
    % Selects the command-line option for hardware (FPGA) or software processing.
    if handles.flagFPGA == 1
    
        generator = 'grainFPGA'; 
        
    else
        
        generator = 'grain'; 
        
    end;
    
    % If the user did not inform the file with an existing keystream.
    if (handles.radioExistentKeystream == 0)
    
        % If you have not entered the desired values for Key or IV, produce
        % an error message and resets the control flag that enables script execution.
        if isempty(handles.Key) || isempty(handles.IV) 

            warndlg('Please enter with the Key and the IV value!');
            readyToExecute = 0;

        % Otherwise check if the size of Key and IV are correct, if they 
        % are not resets the control flag that enables script execution.
        else

            if (length(handles.Key) ~= 20) && (length(handles.IV) ~= 16)
                warndlg('The key must have 80 bits (20 hexa) and the IV must have 64 bits (16 hexa)!');
                readyToExecute = 0;
            else
                if length(handles.Key) ~= 20
                    warndlg('The key must have 80 bits (20 hexa)!');
                    readyToExecute = 0;
                end    

                if length(handles.IV) ~= 16
                    warndlg('The IV must have 64 bits (16 hexa)!');
                    readyToExecute = 0;
                end
            end
        end
    end
    
% MICKEY cipher.
else
    
    % Selects the command-line option for hardware (FPGA) or software processing.
    if handles.flagFPGA == 1
    
        generator = 'mickeyFPGA'; 
        
    else
        
        generator = 'mickey'; 
        
    end;
    
    % If you have not entered the desired values for Key or IV, produce
    % an error message and resets the control flag that enables script execution.
    if (handles.radioExistentKeystream == 0)
    
        if isempty(handles.Key) || isempty(handles.IV) 

            warndlg('Please enter with the Key and the IV value!');
            readyToExecute = 0;

        % Otherwise check if the size of Key and IV are correct, if they 
        % are not resets the control flag that enables script execution.
        else

            if (length(handles.Key) ~= 20) && (length(handles.IV) ~= 20)
                warndlg('The key and IV must have 80 bits (20 hexa)!');
                readyToExecute = 0;
            else
                if length(handles.Key) ~= 20
                    warndlg('The key must have 80 bits (20 hexa)!');
                    readyToExecute = 0;
                end    

                if length(handles.IV) ~= 20
                    warndlg('The IV must have 80 bits (20 hexa)!');
                    readyToExecute = 0;
                end
            end
        end
    end
    
end


% Set string with parameters for execution of the Matlab script in command line.
color                           = handles.color;
baud                            = handles.baud;
com                             = handles.com;
reset                           = 0;
keystreamFileName               = handles.keystreamPath;
keystreamSensitivityFileName    = handles.keystreamSensitivityPath;
Key                             = handles.Key;
IV                              = handles.IV;
samples                         = handles.samples;
verbose                         = handles.verbose;
csv                             = handles.csv;
seedIN                          = handles.seedIN;


% If the user has chosen to export the .csv file and has not given a name 
% to it, it issues an error message and resets the control flag that enables
% script execution.
if (csv == 1) && isempty(handles.csvFileName)
    
    warndlg('Please give a name to ".csv" output file!');
    readyToExecute = 0;
    
else
    
    csvFileName = handles.csvFileName;
    
end

% If the user has not given a name to the project, it emits an error message
% and resets the control flag that enables the execution of the script.
if isempty(handles.name)
    
    warndlg('Please give a name to this project!!');
    readyToExecute = 0;
    
else

    name = handles.name;
    
end

% If the user has selected to upload the image of the computer, and has not
% informed the path to such an image, it sends an error message and resets 
% the control flag that enables script execution.
if ( (handles.radioFile == 1) && isempty(handles.imagePath) )

    warndlg('Please choose a image file to continue!');
    readyToExecute = 0;
     
end

% If the user has selected to load a file with an existing keystream but 
% has not informed the path to such file, it sends an error message and 
% resets the control flag that enables the execution of the script.
if ( (handles.radioExistentKeystream == 1) && (isempty(handles.keystreamSensitivityPath) || isempty(handles.keystreamPath)) )

    warndlg('Please choose a "keystream" and a "keystream sensitivity" files to continue!');
    readyToExecute = 0;
     
end

% If the control flag that enables script execution is enabled.
if readyToExecute == 1
    
    % Clears results from previous executions.
    erase_resultsRGB(handles);
    erase_resultsGray(handles);
    
    % Disables the button to open the exported results folder.
    set(handles.btn_resultsFolder, 'Enable', 'off');
    
    % Disables viewing of Matlab plots.
    set(groot,'defaultFigureVisible','off');
    set(0,'DefaultFigureVisible','off');

    % Disables user interaction with graphical user interface.
    set(hObject, 'Enable', 'off');

    % Change mouse icon to loading.
    set(guiPrincipal, 'pointer', 'watch')
    drawnow;

    % Execute command line script.
    [paths, entropyOUT, intensityOUT, correlationOUT, diffusionOUT, ...
        sensitivityOUT] = runAnalysis(imagePath, camIndex, resolution, ...
        resize, color, generator, baud, com, reset, keystreamFileName, ... 
        keystreamSensitivityFileName, Key, IV, samples, verbose, csv,  ...
        csvFileName, seedIN, name);

    % Saves in global mode the return with the paths to the results.
    handles.paths = paths;
    
    % Returns the mouse pointer to the default.
    set(guiPrincipal, 'pointer', 'arrow')

    % Enables user interaction with graphical user interface.
    set(hObject, 'Enable', 'on');

    % Call method for displaying the results found.
    showResults(handles, paths, entropyOUT, intensityOUT, correlationOUT, diffusionOUT, sensitivityOUT);
    
    % Enables the button to open the folder with the results processed by the script.
    set(handles.btn_resultsFolder, 'Enable', 'on');
    
    axesDummy = axes();
    set(axesDummy, 'Visible', 'off');
   
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% -- Method called when some change occurs in edit_csvFileName component.
function edit_csvFileName_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
handles.csvFileName = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_csvFileName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------


% -------------------------------------------------------------------------

% -- Method called when some change occurs in edit_numberSamplesCorrelation component.
function edit_numberSamplesCorrelation_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
handles.samples = str2double(get(hObject,'String'));

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_numberSamplesCorrelation_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

function edit_pathRandomSeed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pathRandomSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pathRandomSeed as text
%        str2double(get(hObject,'String')) returns contents of edit_pathRandomSeed as a double

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_pathRandomSeed_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in btn_pathRandomSeed.
function btn_pathRandomSeed_Callback(hObject, eventdata, handles)

% Filter with file extensions supported.
filtros = '*.mat';

% Opens file selection window.
[fname, pname, findex] =  uigetfile(filtros, 'Escolha um Arquivo');

% If the user does not cancel the operation and the selected file is valid.
if findex ~= 0

    % Gets full file name (path).
    filename = fullfile(pname, fname);

    handles.edit_pathRandomSeed.String = fname;

    handles.seedIN = filename;

end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% -- Method called when some change occurs in edit_projectName component.
function edit_projectName_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
handles.name = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_projectName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.name = get(hObject,'String');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in check_verboseActivate.
function check_imgResize_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
checkResize = get(hObject,'Value');

handles.resize = checkResize;

% If checkbutton is enabled, that is, the user wants to resize the image, 
% enables edit texts to input the resize values.
if(checkResize == 1)
   
    handles.edit_imgResizeWidth.Enable = 'on';
    handles.edit_imgResizeHeight.Enable = 'on';
    
% Otherwise disable the edit texts.
else
    
    handles.edit_imgResizeWidth.Enable = 'off';
    handles.edit_imgResizeHeight.Enable = 'off';
    
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function check_imgResize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_projectName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in radio_imgInputFile.
function radio_imgInputFile_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
radioFile   = get(hObject,'Value');
radioWebcam = get(handles.radio_imgInputWebcam,'Value');

% User has chosen to upload the image from an existing file.
% According to the user option, enable or disable the GUI components.
if (radioFile == 1)

    handles.check_imgResize.Enable          = 'on';
    handles.edit_imgResizeWidth.Enable      = 'on';
    handles.edit_imgResizeHeight.Enable     = 'on';
    handles.btn_imgOpenFile.Visible         = 'on';
    handles.text_imgFilePath.Visible        = 'on';
    
    handles.popup_imgResolution.Visible     = 'off';
    handles.text_imgResolution.Visible      = 'off';
    
else
    
    handles.check_imgResize.Enable          = 'off';
    handles.edit_imgResizeWidth.Enable      = 'off';
    handles.edit_imgResizeHeight.Enable     = 'off';
    handles.btn_imgOpenFile.Visible         = 'off';
    handles.text_imgFilePath.Visible        = 'off';
    
    handles.popup_imgResolution.Visible     = 'on';
    handles.text_imgResolution.Visible      = 'on';

end

handles.radioFile   = radioFile;
handles.radioWebcam = radioWebcam;

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in radio_imgInputWebcam.
function radio_imgInputWebcam_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
radioWebcam = get(hObject,'Value');
radioFile = get(handles.radio_imgInputFile,'Value');

% User chose to capture a new image using the webcam
% According to the user option, enable or disable the GUI components.
if (radioWebcam == 1)
    
    % Checks if a webcam is installed on the computer. If it does, it changes 
    % the components of the GUI to reflect this mode of operation, otherwise 
    % it changes the option for already existing image loading.
    if handles.existsWebcam == 1
        
        handles.check_imgResize.Enable          = 'off';
        handles.edit_imgResizeWidth.Enable      = 'off';
        handles.edit_imgResizeHeight.Enable     = 'off';
        handles.btn_imgOpenFile.Visible         = 'off';
        handles.text_imgFilePath.Visible        = 'off';

        handles.popup_imgResolution.Visible     = 'on';
        handles.text_imgResolution.Visible      = 'on';
        
    else
        
        radioWebcam = 0;
        radioFile = 1;
        set(handles.radio_imgInputFile, 'Value', 1);
        set(hObject, 'Value', 0);
        
    end
 
else
    
    handles.check_imgResize.Enable          = 'on';
    handles.edit_imgResizeWidth.Enable      = 'on';
    handles.edit_imgResizeHeight.Enable     = 'on';
    handles.btn_imgOpenFile.Visible         = 'on';
    handles.text_imgFilePath.Visible        = 'on';
    
    handles.popup_imgResolution.Visible     = 'off';
    handles.text_imgResolution.Visible      = 'off';

end

handles.radioWebcam = radioWebcam;
handles.radioFile = radioFile;

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in radio_swGenerator.
function radio_swGenerator_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
handles.flagSoftware = get(hObject,'Value');
handles.flagFPGA     = 0;

% Disables GUI components that deal with FPGA operation.
set(handles.popup_comPort, 'Enable', 'off');
set(handles.popup_baudRate, 'Enable', 'off');

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in radio_fpgaGenerator.
function radio_fpgaGenerator_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
handles.flagFPGA = get(hObject,'Value');

% Calls method to list available COM ports.
availableCom = getAvailableComPort();

% If no COM port is connected, it displays an error message and changes the
% selected option to the operating mode via software.
if isempty(availableCom{1})

    warndlg('FPGA is disconnected!');
    
    handles.flagFPGA = 0;
    handles.flagSoftware = 1;
    
    set(hObject, 'Value', 0);
    set(handles.radio_swGenerator, 'Value', 1);
    
    set(handles.popup_comPort, 'Enable', 'off');
    set(handles.popup_baudRate, 'Enable', 'off');

% Otherwise enable GUI components and flags to reflect the mode of operation via FPGA.
else

    set(handles.popup_comPort,'String',getAvailableComPort());
    
    handles.flagSoftware = 0;
    
    set(handles.popup_comPort, 'Enable', 'on');
    set(handles.popup_baudRate, 'Enable', 'on');
    
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

function radio_newKeystream_CreateFcn(hObject, eventdata, handles)

% Retrieves the value entered by the user.
radioNewKeystream = get(hObject,'Value');

handles.radioNewKeystream = radioNewKeystream;

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in radio_newKeystream.
function radio_newKeystream_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
radioNewKeystream = get(hObject,'Value');

% If the user selects the option to use a new keystream, it enables the Key
% and IV edit texts and relative elements of the GUI. Disables path to the 
% existing keystream file.
if (radioNewKeystream == 1)

    handles.edit_keyValue.Enable                    = 'on';
    handles.edit_ivValue.Enable                     = 'on';
    
    handles.btn_openKeystreamFile.Enable            = 'off';
    handles.btn_openKeystreamSensitivityFile.Enable = 'off';
    
    set(handles.edit_pathKeystream, 'String', []);
    set(handles.edit_pathKeystreamSensitivity, 'String', []);
    
    handles.keystreamPath = [];
    handles.keystreamSensitivityPath = [];
    
    handles.radioExistentKeystream = 0;
    
% Otherwise enable buttons to open the existing files.
else
    
    handles.edit_keyValue.Enable                    = 'off';
    handles.edit_ivValue.Enable                     = 'off';
    
    handles.btn_openKeystreamFile.Enable            = 'on';
    handles.btn_openKeystreamSensitivityFile.Enable = 'on';
    
    handles.radioExistentKeystream = 1;

end

handles.radioNewKeystream = radioNewKeystream;

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

function radio_existentKeystream_CreateFcn(hObject, eventdata, handles)

% Retrieves the value entered by the user.
radioExistentKeystream = get(hObject,'Value');

handles.radioExistentKeystream = radioExistentKeystream;

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on button press in radio_existentKeystream.
function radio_existentKeystream_Callback(hObject, eventdata, handles)

% Retrieves the value entered by the user.
radioExistentKeystream = get(hObject,'Value');

% If the user selects the option to use an existent keystream, it disables
% the Key and IV edit texts and relative elements of the GUI. enable buttons 
% to open the existing files.
if (radioExistentKeystream == 1)

    handles.edit_keyValue.Enable = 'off';
    handles.edit_ivValue.Enable = 'off';
    
    handles.btn_openKeystreamFile.Enable = 'on';
    handles.btn_openKeystreamSensitivityFile.Enable = 'on';
    
    set(handles.edit_keyValue, 'String', []);
    set(handles.edit_ivValue, 'String', []);
    
    handles.Key = [];
    handles.IV = [];
    
    
    handles.radioNewKeystream = 0;

% Otherwise enable edit texts to generate new keystream (Key and IV).
else
    
    handles.edit_keyValue.Enable = 'on';
    handles.edit_ivValue.Enable = 'on';
    
    handles.btn_openKeystreamFile.Enable = 'off';
    handles.btn_openKeystreamSensitivityFile.Enable = 'off';
    
    handles.radioNewKeystream = 1;

end

handles.radioExistentKeystream = radioExistentKeystream;

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% -- Method executed by changing the webcam resolution values popup.
function popup_imgResolution_Callback(hObject, eventdata, handles)

    % Retrieves the value entered by the user.
    contents = cellstr(get(hObject,'String'));
    handles.resolution = contents{get(hObject,'Value')};

    disp(handles.resolution)

    % Saves the variables previously updated in the handle so that they can
    % be retrieved in other methods.
    guidata(hObject, handles);
    
% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% Method executed by changing the webcam resolution values popup.
function popup_imgResolution_CreateFcn(hObject, eventdata, handles)

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % Default webcam resolution.
    handles.resolution = '640x480';

    % Saves the variables previously updated in the handle so that they can
    % be retrieved in other methods.
    guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% Callback of click action in open keystream file button.
function btn_openKeystreamFile_Callback(hObject, eventdata, handles)

% Filter with supported file extensions.
filtros = '*.txt';

% Opens file selection window.
[fname, pname, findex] =  uigetfile(filtros, 'Escolha uma Arquivo');

% If the path is valid, or the user did not close the dialog box.
if findex ~= 0

    % Gets full file name (path).
    filename = fullfile(pname, fname);

    % Shows the path in the related Edit Text.
    handles.edit_pathKeystream.String = fname;

    % Saves the path in handles variable.
    handles.keystreamPath = filename;
    
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);
% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% Method executed by changing the edit text of the existing keystream path.
function edit_pathKeystream_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_pathKeystream_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% Method executed by changing the edit text of the existing keystream sensitivity path.
function edit_pathKeystreamSensitivity_Callback(hObject, eventdata, handles)


function edit_pathKeystreamSensitivity_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% Callback of click action in open keystream sensitivity file button.
function btn_openKeystreamSensitivityFile_Callback(hObject, eventdata, handles)

% Filter with supported file extensions.
filtros = '*.txt';

% Opens file selection window.
[fname, pname, findex] =  uigetfile(filtros, 'Escolha uma Arquivo');

% If the path is valid, or the user did not close the dialog box.
if findex ~= 0

    % Gets full file name (path).
    filename = fullfile(pname, fname);

    % Shows the path in the related Edit Text.
    handles.edit_pathKeystreamSensitivity.String = fname;

    % Saves the path in handles variable.
    handles.keystreamSensitivityPath = filename;
    
end

% Saves the variables previously updated in the handle so that they can
% be retrieved in other methods.
guidata(hObject, handles);

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% Callback of click action in open project folder button.
function btn_resultsFolder_Callback(hObject, eventdata, handles)

% Open the Windows explorer in the project folder.
explorer(fullfile([pwd '/' handles.paths{1}]));

% -------------------------------------------------------------------------





% -------------------------------------------------------------------------

% --- Executes on mouse press over axes background.
function axes_imgUFLA_ButtonDownFcn(hObject, eventdata, handles)

% Opens default browser.
system('start www.ufla.br')



% --- Executes on mouse press over axes background.
function axes_imgLABSINE_ButtonDownFcn(hObject, eventdata, handles)

% Opens default browser.
system('start https://www.linkedin.com/company/labsine/')

% -------------------------------------------------------------------------