function Opt=w_init_pipe_cc_vbm_opt
SPMPath=fileparts(which('spm.m'));
Opt=[];
Opt.TPMPath.VarType='file';
Opt.TPMPath.VarFilter={'*.nii', 'NIfTI Files'; '*.*', 'All Files (*.*)'};
Opt.TPMPath.VarVal=fullfile(SPMPath, 'tpm', 'TPM.nii');
Opt.RegMethod.VarType='enum';
Opt.RegMethod.VarEnum={'Shooting'; 'Dartel'};
Opt.RegMethod.VarVal=1;
Opt.ShootingTPMPath.VarType='file';
Opt.ShootingTPMPath.VarFilter={'*.nii', 'NIfTI Files'; '*.*', 'All Files (*.*)'};
Opt.ShootingTPMPath.VarVal=fullfile(SPMPath, 'toolbox', 'cat12', 'templates_MNI152NLin2009cAsym',...
        'Template_0_GS.nii');
Opt.DartelTPMPath.VarType='file';
Opt.DartelTPMPath.VarFilter={'*.nii', 'NIfTI Files'; '*.*', 'All Files (*.*)'};
Opt.DartelTPMPath.VarVal=fullfile(SPMPath, 'toolbox', 'cat12', 'templates_MNI152NLin2009cAsym',...
        'Template_1_Dartel.nii');

Opt.DoAtlasNeuromophoometrics.VarType='bool';
Opt.DoAtlasNeuromophoometrics.VarVal=0;
Opt.DoAtlasLpba40.VarType='bool';
Opt.DoAtlasLpba40.VarVal=0;
Opt.DoAtlasCobra.VarType='bool';
Opt.DoAtlasCobra.VarVal=0;
Opt.DoAtlasHammers.VarType='bool';
Opt.DoAtlasHammers.VarVal=0;
Opt.DoAtlasThalamus.VarType='bool';
Opt.DoAtlasThalamus.VarVal=0;
Opt.DoAtlasSuit.VarType='bool';
Opt.DoAtlasSuit.VarVal=0;
Opt.DoAtlasIbsr.VarType='bool';
Opt.DoAtlasIbsr.VarVal=0;
Opt.AtlasOwnPaths.VarType='file';
Opt.AtlasOwnPaths.VarFilter={'*.nii', 'NIfTI Files'; '*.*', 'All Files (*.*)'};
Opt.AtlasOwnPaths.VarVal={''};
