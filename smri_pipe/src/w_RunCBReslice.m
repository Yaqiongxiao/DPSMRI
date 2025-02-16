function w_RunCBReslice(T1Dir, CBT1Key, CBAffMatKey, CBFlowFieldKey, CBMaskKey, UserOpt)
global IsDEBUG
if isempty(IsDEBUG)
    IsDEBUG=0;
end

if exist('UserOpt', 'var')~=1
    UserOpt=[];
end

%% Run Single Subject VBM Segmentation
% Input CB T1
CBT1Cell=w_ParseFile(T1Dir, CBT1Key);
CBT1Path=CBT1Cell{1};

% Input CB Affine Matrix
CBAffMatCell=w_ParseFile(T1Dir, CBAffMatKey);
CBAffMatPath=CBAffMatCell{1};

% Input CB Flow Field
CBFlowFieldCell=w_ParseFile(T1Dir, CBFlowFieldKey);
CBFlowFieldPath=CBFlowFieldCell{1};

% Input CB Flow Field
CBMaskCell=w_ParseFile(T1Dir, CBMaskKey);
CBMaskPath=CBMaskCell{1};

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.CBT1Path=CBT1Path;
RunOpt.CBAffMatPath=CBAffMatPath;
RunOpt.CBFlowFieldPath=CBFlowFieldPath;
RunOpt.CBMaskPath=CBMaskPath;

[ResliceBatch, RunOpt]=GenCBResliceBatch(RunOpt);

if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CB Reslice');
end
% Run CB  Batch
suit_reslice_dartel(ResliceBatch);

function [ResliceBatch, Opt]=GenCBResliceBatch(Opt)
%% Input Data
if ~isfield(Opt, 'CBT1Path') || exist(Opt.CBT1Path, 'file')==0
    error('Invalid Opt.CBT1Path! Please set CB Image path in Opt Struct!');
end

if ~isfield(Opt, 'CBAffMatPath') || exist(Opt.CBAffMatPath, 'file')==0
    error('Invalid Opt.CBAffMatPath! Please set Cerebellum Affine Matrix path in Opt Struct!');
end

if ~isfield(Opt, 'CBFlowFieldPath') || exist(Opt.CBFlowFieldPath, 'file')==0
    error('Invalid Opt.CBFlowFieldPath! Please set Cerebellum Flow Field path in Opt Struct!');
end

if ~isfield(Opt, 'CBMaskPath') || exist(Opt.CBMaskPath, 'file')==0
    error('Invalid Opt.CBMaskPath! Please set Cerebellum Mask path in Opt Struct!');
end

%% Parse User-Defined Parameter

%% Generate SPM Batch
% resliece to dartel and modulate
ResliceBatch.subj.resample = {Opt.CBT1Path};
ResliceBatch.subj.affineTr = {Opt.CBAffMatPath};
ResliceBatch.subj.flowfield = {Opt.CBFlowFieldPath};
ResliceBatch.subj.mask = {Opt.CBMaskPath};
ResliceBatch.subj.jactransf = 1;