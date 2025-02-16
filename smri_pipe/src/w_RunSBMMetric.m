function w_RunSBMMetric(T1Dir, SurfKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
% Input T1 Affine XML
SurfCell=w_ParseFile(T1Dir, SurfKey);
SurfPath=SurfCell{1};

% Generate SBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.SurfPath=SurfPath;

[SPMBatch, RunOpt]=GenSBMMetricBatch(RunOpt);
if IsDEBUG
    w_PrintOpt(RunOpt, 'Running SBM Metric');
end

% Run VBM Batch
spm_jobman('run',SPMBatch);

function [matlabbatch, Opt]=GenSBMMetricBatch(Opt)
%% Input Data
if ~isfield(Opt, 'SurfPath') || exist(Opt.SurfPath, 'file')==0
    error('Invalid Opt.SurfPath! Please set Surf File in Opt Struct!');
end

%%
matlabbatch{1}.spm.tools.cat.stools.surfextract.data_surf={Opt.SurfPath};

%%
matlabbatch{1}.spm.tools.cat.stools.surfextract.area = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.gmv = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.GI = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.SD = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.FD = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.tGI = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.lGI = 0;
matlabbatch{1}.spm.tools.cat.stools.surfextract.GIL = 0;
matlabbatch{1}.spm.tools.cat.stools.surfextract.surfaces.IS = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.surfaces.OS = 1;
matlabbatch{1}.spm.tools.cat.stools.surfextract.norm = 0;
matlabbatch{1}.spm.tools.cat.stools.surfextract.FS_HOME = '<UNDEFINED>';
matlabbatch{1}.spm.tools.cat.stools.surfextract.nproc = 4;
matlabbatch{1}.spm.tools.cat.stools.surfextract.lazy = 0;