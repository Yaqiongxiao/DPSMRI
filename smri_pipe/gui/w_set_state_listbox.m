function w_set_state_listbox(ListboxObj, VarStruct)
if isempty(VarStruct)
    set(ListboxObj, 'String', '', 'Value', 1);
    return
end
if strcmpi(VarStruct.VarType, 'bool')
    if VarStruct.VarVal==1
        ListboxStr={...
            '* Yes';...
            'No'...
            };
        ListboxPos=1;
    elseif VarStruct.VarVal==0
        ListboxStr={...
            'Yes';...
            '* No'...
            };
        ListboxPos=2;        
    else
        error('Invalid Bool Value!')
    end
elseif strcmpi(VarStruct.VarType, 'str') ||...
       strcmpi(VarStruct.VarType, 'file')
    ListboxPos=1;
    if ~(ischar(VarStruct.VarVal) || iscell(VarStruct.VarVal))
        error('Invalid String Value!');
    end
    if iscell(VarStruct.VarVal)
        if numel(VarStruct.VarVal)==1
            ListboxStr=VarStruct.VarVal{1};
        end
    else
        ListboxStr=VarStruct.VarVal;
    end
elseif strcmpi(VarStruct.VarType, 'enum')
    if numel(VarStruct.VarEnum)<VarStruct.VarVal
        error('Invalid Enum Value!');
    end
    ListboxStr=VarStruct.VarEnum;
    ListboxPos=VarStruct.VarVal;
    ListboxStr{ListboxPos}=sprintf('* %s', ListboxStr{ListboxPos});
end

set(ListboxObj, 'String', ListboxStr, 'Value', ListboxPos);