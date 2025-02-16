function [SubjPrefixList, ListboxStr]=w_set_data_listbox(ListboxObj, ParentDir, Key)
SubjStruct=dir(fullfile(ParentDir, '*'));
SubjList={SubjStruct.name}';
SubjFlag=cell2mat({SubjStruct.isdir}');

SubjList=SubjList(SubjFlag, 1);
SubjList=SubjList(3:end);

set(ListboxObj, 'String', '', 'Value', 1);
drawnow;

ListboxStr=cell(0);
SubjPrefixList=cell(0);
for i=1:numel(SubjList)
    SubjName=SubjList{i};
    Prefix=SubjName;
    ImgStruct=dir(fullfile(ParentDir, SubjName, Key));
    if isempty(ImgStruct)
        ImgStruct=dir(fullfile(ParentDir, SubjName, 'anat', Key));
        if isempty(ImgStruct)
            continue
        end
        ImgFlag=~cell2mat({ImgStruct.isdir}');
        ImgList={ImgStruct.name}';
        ImgList=ImgList(ImgFlag, 1);
        Prefix=fullfile(Prefix, 'anat');
    else
        ImgFlag=~cell2mat({ImgStruct.isdir}');
        ImgList={ImgStruct.name}';
        ImgList=ImgList(ImgFlag, 1);
        if isempty(ImgList)
            ImgStruct=dir(fullfile(ParentDir, SubjName, 'anat', Key));
            if isempty(ImgStruct)
                continue
            end
            ImgFlag=~cell2mat({ImgStruct.isdir}');
            ImgList={ImgStruct.name}';
            ImgList=ImgList(ImgFlag, 1);
            Prefix=fullfile(Prefix, 'anat');
        end
    end
    if isempty(ImgList)
        continue
    end
    ImgName=ImgList{1};
    OldLen=numel(ListboxStr);
    ListboxStr{OldLen+1}=fullfile(Prefix, ImgName);
    SubjPrefixList{OldLen+1, 1}=Prefix;
    SubjPrefixList{OldLen+1, 2}=ImgName;
    set(ListboxObj, 'String', ListboxStr, 'Value', OldLen+1);
    drawnow;
    pause(0.05)
end