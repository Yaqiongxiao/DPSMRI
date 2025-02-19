function VBMPipe(DataDir, T1Name, AllOpt, RunSBMAfterVBM)
[Path, Key, Ext]=fileparts(T1Name);
if exist('RunSBMAfterVBM', 'var')==0
    RunSBMAfterVBM=0;
end
%% Run Pipeline
Opt=[];
%SPMPath=fileparts(which('spm.m'));
%Opt.TPMPath=fullfile(SPMPath, 'tpm', 'TPM.nii');
%Opt.ShootingTPMPath=fullfile(SPMPath, 'toolbox', 'cat12', 'templates_MNI152NLin2009cAsym',...
%        'Template_0_GS.nii');
%Opt.DoReconSurf=0;
% Opt.DoAtlasNeuromophoometrics=0;
% Opt.DoAtlasLpba40=0;
% Opt.DoAtlasCobra=0;
% Opt.DoAtlasHammers=0;
% Opt.DoAtlasThalamus=0;
% Opt.DoAtlasSuit=0;
% Opt.DoAtlasIbsr=0;
% Opt.AtlasOwnPaths={''};
if RunSBMAfterVBM
    Opt.DoReconSurf=1;
else
    Opt.DoReconSurf=0;
end
Opt.TPMPath=AllOpt.TPMPath;
Opt.RegMethod=AllOpt.RegMethod;
Opt.ShootingTPMPath=AllOpt.ShootingTPMPath;
Opt.DartelTPMPath=AllOpt.DartelTPMPath;

Opt.DoAtlasNeuromophoometrics=AllOpt.DoAtlasNeuromophoometrics;
Opt.DoAtlasLpba40=AllOpt.DoAtlasLpba40;
Opt.DoAtlasCobra=AllOpt.DoAtlasCobra;
Opt.DoAtlasHammers=AllOpt.DoAtlasHammers;
Opt.DoAtlasThalamus=AllOpt.DoAtlasThalamus;
Opt.DoAtlasSuit=AllOpt.DoAtlasSuit;
Opt.DoAtlasIbsr=AllOpt.DoAtlasIbsr;
Opt.AtlasOwnPaths=AllOpt.AtlasOwnPaths;

w_RunCCSeg(DataDir, T1Name, Opt);

Opt=[];
w_RunVBMT1V(DataDir, {'report', sprintf('cat_%s.xml', Key)}, Opt);