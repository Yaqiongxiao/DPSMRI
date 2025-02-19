function w_set_config_listbox(ListboxObj, DisplayStruct)
Opt=DisplayStruct.Opt;
Tpm=DisplayStruct.Tpm;
if isempty(Tpm)
    set(ListboxObj, 'String', '', 'Value', 1);
    return
end

[LeftStr, RightStr]=GenLeftRightStr(Tpm, Opt);
ListboxStr=w_fill_listtext(ListboxObj, LeftStr, RightStr, true);
%set(ListboxObj, 'String', ListboxStr, 'Value', 1);
set(ListboxObj, 'String', ListboxStr);

function [LeftStr, RightStr]=GenLeftRightStr(Tpm, Opt)
NumRow=size(Tpm, 1);
LeftStr=cell(0);
OptFlag=Tpm(:, 2);
RightStr=cell(0);

for i=1:NumRow
    LeftStr=[LeftStr; Tpm(i, 1)];
    SubKey=OptFlag{i, 1};
    if isempty(SubKey)
        RightStr=[RightStr; {''}];
    else
        VarStruct=Opt.(SubKey);
        if strcmpi(VarStruct.VarType, 'bool')
            if VarStruct.VarVal==1
                VarStr='Yes';
            elseif VarStruct.VarVal==0
                VarStr='No';
            else
                error('Invalid Bool Var')
            end
        elseif strcmpi(VarStruct.VarType, 'file') || strcmpi(VarStruct.VarType, 'str')
            VarStr=VarStruct.VarVal;
            if iscell(VarStr)
                VarStr=VarStr{1};
            end
            if isempty(VarStr)
                VarStr='<-X';
            end
        elseif strcmpi(VarStruct.VarType, 'enum')
            VarStr=VarStruct.VarEnum{VarStruct.VarVal}; 
        else
            error('Invalid Var Type');
        end
        RightStr=[RightStr; {VarStr}];
        
        if strcmpi(VarStruct.VarType, 'enum')
            if size(Tpm, 2)==3 && ~isempty(Tpm{i, 3}) && iscell(Tpm{i, 3})
                SubTpm=Tpm{i, 3}{VarStruct.VarVal};
                [SubLeftStr, SubRightStr]=GenLeftRightStr(SubTpm, Opt);
                LeftStr=[LeftStr; SubLeftStr];
                RightStr=[RightStr; SubRightStr];
            end            
        end
    end
end
