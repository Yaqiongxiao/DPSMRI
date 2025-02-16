function SBMPipe(DataDir, T1Name, AllOpt, RunSBMAfterVBM)
[Path, Key, Ext]=fileparts(T1Name);
if exist('RunSBMAfterVBM', 'var')==0
    RunSBMAfterVBM=0;
end
%% Run Pipeline
if ~RunSBMAfterVBM
    Opt=[];
    % SPMPath=fileparts(which('spm.m'));
    % Opt.TPMPath=fullfile(SPMPath, 'tpm', 'TPM.nii');
    % Opt.ShootingTPMPath=fullfile(SPMPath, 'toolbox', 'cat12', 'templates_MNI152NLin2009cAsym',...
    %         'Template_0_GS.nii');
    % Opt.DoReconSurf=1;
    Opt.TPMPath=AllOpt.TPMPath;
    Opt.ShootingTPMPath=AllOpt.ShootingTPMPath;
    Opt.DoReconSurf=1;
    w_RunCCSeg(DataDir, T1Name, Opt);
end

Opt=[];
w_RunSBMMetric(DataDir, {'surf', sprintf('lh.central.%s.gii', Key)}, Opt);

Opt=[];
% Opt.IsMergeHemi=1;
% Opt.IsMesh32k=1;
% Opt.SurfFWHM=12;
Opt.IsMergeHemi=AllOpt.IsMergeHemi;
Opt.IsMesh32k=AllOpt.IsMesh32k;
if ischar(AllOpt.SurfFWHM)
    Opt.SurfFWHM=str2double(AllOpt.SurfFWHM);
else
    Opt.SurfFWHM=AllOpt.SurfFWHM;
end
w_RunSBMMetricSmooth(DataDir,...
    {{'surf', sprintf('lh.thickness.%s', Key)};...
        {'surf', sprintf('lh.depth.%s', Key)};...
        {'surf', sprintf('lh.fractaldimension.%s', Key)};...
        {'surf', sprintf('lh.gyrification.%s', Key)}...
    }, Opt);