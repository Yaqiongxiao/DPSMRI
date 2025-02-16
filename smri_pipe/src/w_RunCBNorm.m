function w_RunCBNorm(T1Dir, CBGmKey, CBWmKey, CBIsoKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
% Input Gary Matter CB
CBGmCell=w_ParseFile(T1Dir, CBGmKey);
CBGmPath=CBGmCell{1};

% Input White Matter CB
CBWmCell=w_ParseFile(T1Dir, CBWmKey);
CBWmPath=CBWmCell{1};

% Input Isolation
CBIsoCell=w_ParseFile(T1Dir, CBIsoKey);
CBIsoPath=CBIsoCell{1};

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.CBGmPath=CBGmPath;
RunOpt.CBWmPath=CBWmPath;
RunOpt.CBIsoPath=CBIsoPath;

[NormBatch, RunOpt]=GenCBNormBatch(RunOpt);
if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CB Normalization');
end
% Run CB  Batch
suit_normalize_dartel(NormBatch);
%suit_reslice_dartel(ResliceBatch);

function [NormBatch, Opt]=GenCBNormBatch(Opt)
%% Input Data
if ~isfield(Opt, 'CBGmPath') || exist(Opt.CBGmPath, 'file')==0
    error('Invalid Opt.CBGmPath! Please set CB Gray Matter path in Opt Struct!');
end

if ~isfield(Opt, 'CBWmPath') || exist(Opt.CBWmPath, 'file')==0
    error('Invalid Opt.CBWmPath! Please set Cerebellum White Matter path in Opt Struct!');
end

if ~isfield(Opt, 'CBWmPath') || exist(Opt.CBWmPath, 'file')==0
    error('Invalid Opt.CBWmPath! Please set Cerebellum White Matter path in Opt Struct!');
end

if ~isfield(Opt, 'CBIsoPath') || exist(Opt.CBIsoPath, 'file')==0
    error('Invalid Opt.CBIsoPath! Please set Cerebellum Isolation path in Opt Struct!');
end

%% Parse User-Defined Parameter

%% Generate SPM Batch
% normalisation
NormBatch.subjND.gray={Opt.CBGmPath};
NormBatch.subjND.white={Opt.CBWmPath};
NormBatch.subjND.isolation={Opt.CBIsoPath};