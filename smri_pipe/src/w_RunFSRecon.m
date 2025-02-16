function w_RunFSRecon(T1Dir, T1Key, UserOpt)
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

FSDir=fullfile(T1Dir, 'fsresults');
if exist(FSDir, 'dir')~=7
    mkdir(FSDir);
end

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.Cmd=sprintf('recon-all -i %s -subjid fsresults -sd %s', T1ImgPath, FSDir);

if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CB Segmentation');
end

% Run CB Segmentation
[RunStatus, RunLog]=system(RunOpt.Cmd);
if RunStatus
    error('Running Freesurfer Recon-all failed!');
else
    fid=fopen(fullfile(FSDir, 'Recon-all.log'), 'w');
    fprintf(fid, '%s', RunLog);
    fclose(fid);    
end