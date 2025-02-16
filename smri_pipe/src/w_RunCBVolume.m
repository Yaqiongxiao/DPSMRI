function w_RunCBVolume(T1Dir, CBProbKey, CBAffMatKey, CBFlowFieldKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
CBProbCell=w_ParseFile(T1Dir, CBProbKey);
CBProbPath=CBProbCell{1};

CBAffMatCell=w_ParseFile(T1Dir, CBAffMatKey);
CBAffMatPath=CBAffMatCell{1};

CBFlowFieldCell=w_ParseFile(T1Dir, CBFlowFieldKey);
CBFlowFieldPath=CBFlowFieldCell{1};

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.CBProbPath=CBProbPath;
RunOpt.CBAffMatPath=CBAffMatPath;
RunOpt.CBFlowFieldPath=CBFlowFieldPath;

SUITPath=fileparts(which('spm_suit.m'));
if ~( isfield(RunOpt, 'CBAtlasPath') && exist(RunOpt.CBAtlasPath, 'file')==2 )
    RunOpt.CBAtlasPath=fullfile(SUITPath, 'cerebellar_atlases-1.0', 'Buckner_2011', 'atl-Buckner7_space-SUIT_dseg.nii');
end

if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CB Extract Volume');
end

Vol=[];
Vol.CBAtlasPath=RunOpt.CBAtlasPath;
CBV=suit_vol({RunOpt.CBProbPath});
Vol.CBVox=CBV.vox;
Vol.CBVmm=CBV.vmm;
Vol.VoxSize=CBV.Vsize;

ResliceBatch.Affine={RunOpt.CBAffMatPath};
ResliceBatch.flowfield={RunOpt.CBFlowFieldPath};
ResliceBatch.resample = {RunOpt.CBAtlasPath};
ResliceBatch.ref = {RunOpt.CBProbPath}; 
suit_reslice_dartel_inv(ResliceBatch);

[AtlasPath, AtlasName, AtlasExt]=fileparts(RunOpt.CBAtlasPath);
CBPath=fileparts(RunOpt.CBAffMatPath);
ResliceAtlasKey=['iw_*', AtlasName, '*', AtlasExt];
ResliceAtlasCell=w_ParseFile(CBPath, ResliceAtlasKey);
ResliceAtlasPath=ResliceAtlasCell{1};

CBAtlasV=suit_vol({ResliceAtlasPath},'Atlas');

Vol.ROIReg=CBAtlasV.reg;
Vol.ROIVox=CBAtlasV.vox;
Vol.ROIVmm=CBAtlasV.vmm;

OutVolMat=fullfile(CBPath, 'CerebellumVolume.mat');
save(OutVolMat, '-struct', 'Vol');