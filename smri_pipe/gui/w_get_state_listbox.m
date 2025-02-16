function VarStruct=w_get_state_listbox(ListboxObj, VarStruct)
ListboxPos=get(ListboxObj, 'Value');
ListboxStr=get(ListboxObj, 'String');
if ListboxPos==0
    VarStruct=[];
    return
end

if strcmpi(VarStruct.VarType, 'bool')
    if ListboxPos==1 % True
        VarStruct.VarVal=1;
    elseif ListboxPos==2 % False
        VarStruct.VarVal=0;
    else
        error('Invalid Listbox Postion')
    end
elseif strcmpi(VarStruct.VarType, 'str')
    Prompt='Set Current Option:';
    DlgTitle='Please Set Your Option';
    if numel(VarStruct.VarVal)<35
        DlgLen=[1, 35];
    else
        DlgLen=[1, numel(VarStruct.VarVal)];
    end
    OldVarVal=VarStruct.VarVal;
    DlgAns=inputdlg({Prompt}, DlgTitle, DlgLen, {OldVarVal});
    if isempty(DlgAns)
        return
    else
        VarStruct.VarVal=DlgAns{1};
    end
elseif strcmpi(VarStruct.VarType, 'file')
    if ~isfield(VarStruct, 'VarFilter') || isempty(VarStruct.VarFilter)
        FileFilter={'*.*', 'All Files (*.*)'};
    else
        FileFilter=VarStruct.VarFilter;        
    end
    Title='Please Select Your File';
    if iscell(VarStruct.VarVal)
        DefaultFile=VarStruct.VarVal{1};
    else
        DefaultFile=VarStruct.VarVal;
    end
    [File, Path]=uigetfile(FileFilter, Title, DefaultFile);
    if File==0
        return
    else
        VarStruct.VarVal=fullfile(Path, File);
    end
elseif strcmpi(VarStruct.VarType, 'enum')
    VarStruct.VarVal=ListboxPos;
else
    error('Invalid Var Type!');
end
