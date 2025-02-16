function w_RunSBMMetricSmooth(T1Dir, SurfKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject SBM Metric Smooth
% Input T1 Affine XML
SurfMetricPaths=w_ParseFile(T1Dir, SurfKey);

% Generate SBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.SurfMetricPaths=SurfMetricPaths;

[SPMBatch, RunOpt]=GenSBMMetricSmoothBatch(RunOpt);
if IsDEBUG
    w_PrintOpt(RunOpt, 'Running SBM Metric');
end

% Run VBM Batch
spm_jobman('run',SPMBatch);

function [matlabbatch, Opt]=GenSBMMetricSmoothBatch(Opt)
%% Input Data
if ~isfield(Opt, 'SurfMetricPaths') || any(cellfun(@(p) exist(p, 'file'), Opt.SurfMetricPaths)==0)
    error('Invalid Opt.SurfMetricPaths! Please set Surf File in Opt Struct!');
end

%% Option
if ~isfield(Opt, 'IsMergeHemi') || ~isnumeric(Opt.IsMergeHemi)
    Opt.IsMergeHemi=1;
end

if ~isfield(Opt, 'IsMesh32k') || ~isnumeric(Opt.IsMesh32k)
    Opt.IsMesh32k=1;
end

if ~isfield(Opt, 'SurfFWHM') || ~isnumeric(Opt.SurfFWHM)
    Opt.SurfFWHM=12;
end

%%
matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf=Opt.SurfMetricPaths;

%%
matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi=Opt.IsMergeHemi;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k=Opt.IsMesh32k;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf=Opt.SurfFWHM;

%% Other Option
matlabbatch{1}.spm.tools.cat.stools.surfresamp.lazy=0;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc=0;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.assuregifti=1;