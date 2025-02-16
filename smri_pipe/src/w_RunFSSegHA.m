function w_RunFSSegHA(T1Dir, FSKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
FSDirCell=w_ParseFile(T1Dir, FSKey);
FSDirPath=FSDirCell{1};
[~,FSRealKey]=fileparts(FSDirPath);

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.Cmd=sprintf('segmentHA_T1.sh %s %s', FSRealKey, T1Dir);

if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CB Segmentation');
end

% Run CB Segmentation
[RunStatus, RunLog]=system(RunOpt.Cmd);
if RunStatus
    error('Running Freesurfer Recon-all failed!');
else
    fid=fopen(fullfile(FSDir, 'SegmentHA-T1.log'), 'w');
    fprintf(fid, '%s', RunLog);
    fclose(fid);
end