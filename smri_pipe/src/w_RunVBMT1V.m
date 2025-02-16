function w_RunVBMT1V(T1Dir, AffKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
% Input T1 Affine XML
T1AffCell=w_ParseFile(T1Dir, AffKey);
T1AffPath=T1AffCell{1};
% Output T1V
T1VDir=fullfile(T1Dir, 'vmetric');
if exist(T1VDir, 'dir')~=7
    mkdir(T1VDir);
end
T1VOutPath=fullfile(T1VDir, 'TIV.txt');

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.T1AffPath=T1AffPath;
RunOpt.T1VOutPath=T1VOutPath;

SPMBatch=GenVBMT1VBatch(RunOpt);
if IsDEBUG
    w_PrintOpt(RunOpt, 'Running VBM T1V');
end

% Run VBM Batch
spm_jobman('run',SPMBatch);

function matlabbatch=GenVBMT1VBatch(Opt)
%% Input Data
if isfield(Opt, 'T1AffPath') && exist(Opt.T1AffPath, 'file')==2
    T1AffPath=Opt.T1AffPath;
else
    error('Invalid Opt.T1AffPath! Please set T1 Affine XML path in Opt Struct!');
end

%% Output T1V Name
if isfield(Opt, 'T1VOutPath') && exist(fileparts(Opt.T1VOutPath), 'dir')==7
    T1VOutPath=Opt.T1VOutPath;
else
    error('Invalid Opt.T1AffPath! Please set T1 Affine XML path in Opt Struct!');
end

matlabbatch{1}.spm.tools.cat.tools.calcvol.data_xml = {T1AffPath};
matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_TIV = 0;
matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_name = T1VOutPath;