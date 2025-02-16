function w_RunCCSeg(T1Dir, T1Key, UserOpt)
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

% Generate VBM Segmentation Batch
RunOpt=UserOpt;
RunOpt.T1ImgPath=T1ImgPath;
[SPMBatch, RunOpt]=GenCCSegBatch(RunOpt);
if IsDEBUG
    w_PrintOpt(RunOpt, 'Running CC Segmentation');
end

% Run VBM Batch
spm_jobman('run',SPMBatch);

function [matlabbatch, Opt]=GenCCSegBatch(Opt)
%% Input Data
if ~isfield(Opt, 'T1ImgPath') || exist(Opt.T1ImgPath, 'file')==0
    error('Invalid Opt.T1ImgPath! Please set T1 image path in Opt Struct!');
end

%% Parse User-Defined Parameter
SPMPath=fileparts(which('spm.m'));
% TMPPath 
% ShootingTPMPath
% IsReconSurf
if ~isfield(Opt, 'TPMPath')
    Opt.TPMPath=fullfile(SPMPath, 'tpm', 'TPM.nii');
end

if ~isfield(Opt, 'RegMethod')
    Opt.RegMethod='Shooting'; % OR Dartel
end

if ~isfield(Opt, 'ShootingTPMPath')
    Opt.ShootingTPMPath=fullfile(SPMPath, 'toolbox', 'cat12', 'templates_MNI152NLin2009cAsym',...
        'Template_0_GS.nii');
end

if ~isfield(Opt, 'DartelTPMPath')
    Opt.DartelTPMPath=fullfile(SPMPath, 'toolbox', 'cat12', 'templates_MNI152NLin2009cAsym',...
        'Template_1_Dartel.nii');    
end

if ~isfield(Opt, 'DoReconSurf')
    Opt.DoReconSurf=0;
end

if ~isfield(Opt, 'DoAtlasNeuromophoometrics')
    Opt.DoAtlasNeuromophoometrics=1;
end

if ~isfield(Opt, 'DoAtlasLpba40')
    Opt.DoAtlasLpba40=1;
end

if ~isfield(Opt, 'DoAtlasCobra')
    Opt.DoAtlasCobra=1;
end

if ~isfield(Opt, 'DoAtlasHammers')
    Opt.DoAtlasHammers=1;
end

if ~isfield(Opt, 'DoAtlasThalamus')
    Opt.DoAtlasThalamus=1;
end

if ~isfield(Opt, 'DoAtlasSuit')
    Opt.DoAtlasSuit=1;
end

if ~isfield(Opt, 'DoAtlasIbsr')
    Opt.DoAtlasIbsr=1;
end

if ~isfield(Opt, 'AtlasOwnPaths')
    Opt.AtlasOwnPaths={''};
end

%% Generate SPM Batch
% User-Defined Parameter
matlabbatch{1}.spm.tools.cat.estwrite.data = {Opt.T1ImgPath};
matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {Opt.TPMPath};
if strcmpi(Opt.RegMethod, 'Shooting')
    matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.shootingtpm ={Opt.ShootingTPMPath};
elseif strcmpi(Opt.RegMethod, 'Dartel')
    matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.dartel.darteltpm={Opt.DartelTPMPath};
else
    error('Invalid Additional TPM Type')
end

if Opt.DoReconSurf
    matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 1;
    matlabbatch{1}.spm.tools.cat.estwrite.output.surf_measures = 1;
else
    matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 0;
    matlabbatch{1}.spm.tools.cat.estwrite.output.surf_measures = 0;
end

matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = Opt.DoAtlasNeuromophoometrics;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = Opt.DoAtlasLpba40;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.cobra = Opt.DoAtlasCobra;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.hammers = Opt.DoAtlasHammers;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.thalamus = Opt.DoAtlasThalamus;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.suit = Opt.DoAtlasSuit;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.ibsr = Opt.DoAtlasIbsr;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.ownatlas = Opt.AtlasOwnPaths;

% Default Parameter
matlabbatch{1}.spm.tools.cat.estwrite.data_wmh = {''};
matlabbatch{1}.spm.tools.cat.estwrite.nproc = 10;
matlabbatch{1}.spm.tools.cat.estwrite.useprior = '';

matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.estwrite.opts.biasacc = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.restypes.optimal = [1 0.3];
matlabbatch{1}.spm.tools.cat.estwrite.extopts.setCOM = 1;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.affmod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.spm_kamap = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASmyostr = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 2;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.WMHC = 2;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.regstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.bb = 12;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.SRP = 22;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.ignoreErrors = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.BIDS.BIDSno = 1;

matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 2;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 2;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.mod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ct.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ct.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ct.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.pp.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.pp.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.pp.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.mod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.SL.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.SL.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.SL.mod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.SL.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.mod = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.atlas.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.label.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.label.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.label.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.labelnative = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.las.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.las.warped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.las.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.jacobianwarped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [1 1];
matlabbatch{1}.spm.tools.cat.estwrite.output.rmat = 0;