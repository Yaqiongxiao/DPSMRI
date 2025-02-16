function w_RunCBSeg(T1Dir, T1Key, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
T1ImgCell=w_ParseFile(T1Dir, T1Key);
T1ImgPath=T1ImgCell{1};

CBDir=fullfile(T1Dir, 'cerebellum');
if exist(CBDir, 'dir')~=7
    mkdir(CBDir);
end
[Path, Name, Ext]=fileparts(T1ImgPath);
UseT1ImgPath=fullfile(CBDir, [Name, Ext]);
copyfile(T1ImgPath, UseT1ImgPath);

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.RawT1ImgPath=T1ImgPath;
RunOpt.UseT1ImgPath=UseT1ImgPath;

if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CB Segmentation');
end

% Run CB Segmentation
suit_isolate_seg({RunOpt.UseT1ImgPath});
