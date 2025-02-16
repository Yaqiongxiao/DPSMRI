function varargout = smri(varargin)
% SMRI_MAIN_GUI MATLAB code for smri_main_gui.fig
%      SMRI_MAIN_GUI, by itself, creates a new SMRI_MAIN_GUI or raises the existing
%      singleton*.
%
%      H = SMRI_MAIN_GUI returns the handle to a new SMRI_MAIN_GUI or the handle to
%      the existing singleton*.
%
%      SMRI_MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMRI_MAIN_GUI.M with the given input arguments.
%
%      SMRI_MAIN_GUI('Property','Value',...) creates a new SMRI_MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smri_main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smri_main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smri_main_gui

% Last Modified by GUIDE v2.5 05-Nov-2023 16:58:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smri_OpeningFcn, ...
                   'gui_OutputFcn',  @smri_OutputFcn, ...
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


% --- Executes just before smri_main_gui is made visible.
function smri_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smri_main_gui (see VARARGIN)

handles.PipeSelectDisplay=w_init_pipe_select_tpm;
handles.PipeOptDisplays.CcVBMDisplay=w_init_pipe_cc_vbm_tpm;
handles.PipeOptDisplays.CcSBMDisplay=w_init_pipe_cc_sbm_tpm;
handles.PipeOptDisplays.CbVBMDisplay=w_init_pipe_cb_vbm_tpm;
handles.PipeOptDisplays.CcVBMIndiNetDisplay=w_init_pipe_cc_vbm_indinet_tpm;
handles.DataWorkDir=[];
handles.SubjPrefixList=[];
handles.DataListboxStr=[];

% Choose default command line output for smri_main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

UpdateAllListbox(hObject, 1);
% UIWAIT makes smri_main_gui wait for user response (see UIRESUME)
% uiwait(handles.MainFig);


% --- Outputs from this function are returned to the command line.
function varargout = smri_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in PipeSelectListbox.
function PipeSelectListbox_Callback(hObject, eventdata, handles)
% hObject    handle to PipeSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateAllListbox(hObject);
% Hints: contents = cellstr(get(hObject,'String')) returns PipeSelectListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PipeSelectListbox


% --- Executes during object creation, after setting all properties.
function PipeSelectListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PipeSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PipeStateListbox.
function PipeStateListbox_Callback(hObject, eventdata, handles)
% hObject    handle to PipeStateListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~strcmpi(get(handles.MainFig, 'SelectionType'), 'normal')
    return
end

PipeSelectPos=get(handles.PipeSelectListbox, 'Value');
PipeSelectDisplay=handles.PipeSelectDisplay;
PipeStateKey=PipeSelectDisplay.Tpm{PipeSelectPos, 2};
if isempty(PipeStateKey)
    return
end
VarStruct=handles.PipeSelectDisplay.Opt.(sprintf('%s', PipeStateKey));
VarStruct=w_get_state_listbox(hObject, VarStruct);

handles.PipeSelectDisplay.Opt.(sprintf('%s', PipeStateKey))=VarStruct;
guidata(hObject, handles);

UpdateAllListbox(hObject);

% Hints: contents = cellstr(get(hObject,'String')) returns PipeStateListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PipeStateListbox


% --- Executes during object creation, after setting all properties.
function PipeStateListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PipeStateListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OptSelectListbox.
function OptSelectListbox_Callback(hObject, eventdata, handles)
% hObject    handle to OptSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateAllListbox(hObject);
% Hints: contents = cellstr(get(hObject,'String')) returns OptSelectListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OptSelectListbox


% --- Executes during object creation, after setting all properties.
function OptSelectListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OptSelectListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OptStateListbox.
function OptStateListbox_Callback(hObject, eventdata, handles)
% hObject    handle to OptStateListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmpi(get(handles.MainFig, 'SelectionType'), 'open')
    return
end

if ~strcmpi(get(handles.MainFig, 'SelectionType'), 'normal')
    return
end

PipeSelectPos=get(handles.PipeSelectListbox, 'Value');
PipeSelectDisplay=handles.PipeSelectDisplay;
PipeOptKey=PipeSelectDisplay.Tpm{PipeSelectPos, 3};
OptSelectPos=get(handles.OptSelectListbox, 'Value');
OptSelectDisplay=handles.PipeOptDisplays.(sprintf('%s', PipeOptKey));
RealKeyList=GenRealKeyList(OptSelectDisplay.Tpm, OptSelectDisplay.Opt);
OptSelectKey=RealKeyList{OptSelectPos};

%if isempty(OptSelectDisplay.Tpm{OptSelectPos, 2})
%    return
%end
VarStruct=OptSelectDisplay.Opt.(sprintf('%s', OptSelectKey));
VarStruct=w_get_state_listbox(hObject, VarStruct);
%w_set_state_listbox(hObject, VarStruct);

OptSelectDisplay.Opt.(sprintf('%s', OptSelectKey))=VarStruct;
handles.PipeOptDisplays.(sprintf('%s', PipeOptKey))=OptSelectDisplay;

PipeList={'CcVBMDisplay', 'CcSBMDisplay', 'CcVBMIndiNetDisplay'};
OptList={'RegMethod', 'TPMPath', 'ShootingTPMPath', 'DartelTPMPath'};
if any(strcmp(OptSelectKey, OptList))
    PipeList(strcmp(PipeOptKey, PipeList))=[];
    for i=1:numel(PipeList)
        for j=1:numel(OptList)
            handles.PipeOptDisplays.(sprintf('%s', PipeList{i})).Opt.(sprintf('%s', OptList{j}))=...
                handles.PipeOptDisplays.(sprintf('%s', PipeOptKey)).Opt.(sprintf('%s', OptList{j}));
        end
    end
end

guidata(hObject, handles);
UpdateAllListbox(hObject);

% Hints: contents = cellstr(get(hObject,'String')) returns OptStateListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OptStateListbox


% --- Executes during object creation, after setting all properties.
function OptStateListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OptStateListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunBtn.
function RunBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RunBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PipeSelect=handles.PipeSelectDisplay.Opt;
OptDisplays=handles.PipeOptDisplays;

WorkDir=handles.DataWorkDir;
SubjPrefixList=handles.SubjPrefixList;
if exist(WorkDir, 'dir')==0
    warndlg('Work directory not exist!');
    return
end

PipeLists=fieldnames(PipeSelect);
PipeOpts=[];
for i=1:numel(PipeLists)
    PipeName=PipeLists{i};
    if PipeSelect.(PipeName).VarVal
        PipeOpts.(PipeName)=[];
        OptDetails=OptDisplays.(sprintf('%sDisplay', PipeName)).Opt;
        OptLists=fieldnames(OptDetails);
        for j=1:numel(OptLists)
            OptName=OptLists{j};
            VarType=OptDetails.(OptName).VarType;
            if strcmpi(VarType, 'enum')
                VarEnum=OptDetails.(OptName).VarEnum;
                VarVal=OptDetails.(OptName).VarVal;
                PipeOpts.(PipeName).(OptName)=VarEnum{VarVal};
            else
                PipeOpts.(PipeName).(OptName)=OptDetails.(OptName).VarVal;
            end
        end
    end
end

if isempty(PipeOpts)
    warndlg('There is no pipelines selected!');
    return
end

for i=1:size(SubjPrefixList, 1)
    SubjDir=fullfile(WorkDir, SubjPrefixList{i, 1});
    T1Name=SubjPrefixList{i, 2};
    w_run_single_subject_wf(SubjDir, T1Name, PipeOpts);
end

function DataDirEty_Callback(hObject, eventdata, handles)
% hObject    handle to DataDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataDirEty as text
%        str2double(get(hObject,'String')) returns contents of DataDirEty as a double


% --- Executes during object creation, after setting all properties.
function DataDirEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataDirEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DataDirBtn.
function DataDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to DataDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ParentDir=handles.DataWorkDir;
if isempty(ParentDir)
    ParentDir=pwd;
end
ParentDir=uigetdir(ParentDir, 'Please Set Data Directory');
if ParentDir==0
    return
end
handles.DataWorkDir=ParentDir;
Key=get(handles.DataPrefixEty, 'String');

[SubjPrefixList, DataListboxStr]=w_set_data_listbox(handles.DataListbox, ParentDir, Key);
handles.SubjPrefixList=SubjPrefixList;
handles.DataListboxStr=DataListboxStr;
guidata(hObject, handles);
set(handles.DataDirEty, 'String', ParentDir);
    
function DataPrefixEty_Callback(hObject, eventdata, handles)
% hObject    handle to DataPrefixEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Key=get(handles.DataPrefixEty, 'String');
ParentDir=handles.DataWorkDir;
if exist(ParentDir, 'dir')~=0
    [SubjPrefixList, DataListboxStr]=w_set_data_listbox(handles.DataListbox, ParentDir, Key);
    handles.SubjPrefixList=SubjPrefixList;
    handles.DataListboxStr=DataListboxStr;
    guidata(hObject, handles);
end
% Hints: get(hObject,'String') returns contents of DataPrefixEty as text
%        str2double(get(hObject,'String')) returns contents of DataPrefixEty as a double


% --- Executes during object creation, after setting all properties.
function DataPrefixEty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataPrefixEty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DataListbox.
function DataListbox_Callback(hObject, eventdata, handles)
% hObject    handle to DataListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DataListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataListbox


% --- Executes during object creation, after setting all properties.
function DataListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateAllListbox(hObj, InitFlag)
handles=guidata(hObj);
if exist('InitFlag', 'var')==0
    InitFlag=0;
end
if InitFlag
    PipeSelectPos=1;
else
    PipeSelectPos=get(handles.PipeSelectListbox, 'Value');
end

% Update Pipe Select Listbox
w_set_config_listbox(handles.PipeSelectListbox, handles.PipeSelectDisplay)
set(handles.PipeSelectListbox, 'Value', PipeSelectPos);

% Update Pipe State Listbox
PipeStateKey=handles.PipeSelectDisplay.Tpm{PipeSelectPos, 2};
if isempty(PipeStateKey)
    PipeStateStruct=[];
else
    PipeStateStruct=handles.PipeSelectDisplay.Opt.(sprintf('%s', PipeStateKey));
end
w_set_state_listbox(handles.PipeStateListbox, PipeStateStruct);

% Update Pipe Opt Listbox
if InitFlag
    OptSelectPos=2;
else
    OptSelectPos=get(handles.OptSelectListbox, 'Value');
end

PipeOptKey=handles.PipeSelectDisplay.Tpm{PipeSelectPos, 3};
if isempty(PipeOptKey)
    OptSelectDisplay=[];
else
    OptSelectDisplay=handles.PipeOptDisplays.(sprintf('%s', PipeOptKey));
end

RealKeyList=GenRealKeyList(OptSelectDisplay.Tpm, OptSelectDisplay.Opt);
if size(RealKeyList, 1)<OptSelectPos
    OptSelectPos=1;
end

w_set_config_listbox(handles.OptSelectListbox, OptSelectDisplay);
set(handles.OptSelectListbox, 'Value', OptSelectPos);

if isempty(OptSelectDisplay.Tpm)
    OptStateStruct=[];
else
    RealKeyList=GenRealKeyList(OptSelectDisplay.Tpm, OptSelectDisplay.Opt);
    OptStateKey=RealKeyList{OptSelectPos};
    if isempty(OptStateKey)
        OptStateStruct=[];
    else
        OptStateStruct=OptSelectDisplay.Opt.(sprintf('%s', OptStateKey));
    end
end
w_set_state_listbox(handles.OptStateListbox, OptStateStruct);

function RealKeyList=GenRealKeyList(Tpm, Opt)
RealKeyList=cell(0);

NumRow=size(Tpm, 1);
NumCol=size(Tpm, 2);
for i=1:NumRow
    real_key=Tpm{i, 2};
    RealKeyList=[RealKeyList; {Tpm{i, 2}}];
    real_struct=Opt.(real_key);
    if strcmpi(real_struct.VarType, 'enum')
        if NumCol==3 && ~isempty(Tpm{i, 3}) && iscell(Tpm{i, 3})
            SubRealKeyList=GenRealKeyList(Tpm{i, 3}{real_struct.VarVal}, Opt);
            RealKeyList=[RealKeyList; SubRealKeyList];
        end
    end
end

% --- Executes on button press in RmSubjBtn.
function RmSubjBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RmSubjBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurInd=get(handles.DataListbox, 'Value');
SubjPrefixList=handles.SubjPrefixList;
DataListboxStr=handles.DataListboxStr;
SubjPrefixList(CurInd, :)=[];
DataListboxStr(CurInd)=[];

if CurInd>numel(DataListboxStr)
    CurInd=numel(DataListboxStr);
end
handles.SubjPrefixList=SubjPrefixList;
handles.DataListboxStr=DataListboxStr;
guidata(hObject, handles);
set(handles.DataListbox, 'String', DataListboxStr, 'Value', CurInd);
