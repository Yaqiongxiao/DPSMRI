function w_BuildBIDSFromImgs(T1PathCell, TargetPDir, SubjPrefix)
SubjNameCell=cell(numel(T1PathCell), 1);
for i=1:numel(T1PathCell)
    [Path, Name, Ext]=fileparts(T1PathCell{i});
    TargetSubjDir=fullfile(TargetPDir, [SubjPrefix, '-', Name], 'anat');
    if exist(TargetSubjDir, 'dir')~=7
        mkdir(TargetSubjDir)
    end
    T1Name=[SubjPrefix, '-', Name, '_t1w', Ext];
    SubjNameCell{i}=fullfile(TargetSubjDir, T1Name);
end

for i=1:numel(T1PathCell)
    copyfile(T1PathCell{i}, SubjNameCell{i});
end

