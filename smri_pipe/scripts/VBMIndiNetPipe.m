function VBMIndiNetPipe(DataDir, T1Name, AllOpt, RunVBMIndiNetAfterVBM)
[Path, Key, Ext]=fileparts(T1Name);
if exist('RunVBMIndiNetAfterVBM', 'var')==0
    RunVBMIndiNetAfterVBM=0;
end
%% Run Pipeline
if ~RunVBMIndiNetAfterVBM % Perform VBM first
    Opt=[];
    Opt.DoReconSurf=0;
    Opt.TPMPath=AllOpt.TPMPath;
    Opt.RegMethod=AllOpt.RegMethod;
    Opt.ShootingTPMPath=AllOpt.ShootingTPMPath;
    Opt.DartelTPMPath=AllOpt.DartelTPMPath;
    
    w_RunCCSeg(DataDir, T1Name, Opt);
end

Opt=[];
fprintf('Performing VBM Individual Network Step 1.\n');
w_RunVBMIndiNetStepOne(DataDir, T1Name, Opt);
fprintf('Performing VBM Individual Network Step 2/3.\n');
Opt=[];
Opt.NumRandNet=AllOpt.NumRandNet;
w_RunVBMIndiNetStepTwoThree(DataDir, T1Name, Opt);
fprintf('Performing VBM Individual Network Step 4.\n');
w_RunVBMIndiNetStepFour(DataDir, T1Name, Opt);
fprintf('VBM Individual Network Finished!\n');