function Opt=w_init_pipe_cb_vbm_opt
Opt=[];
SUITPath=fileparts(which('spm_suit.m'));
Opt.CBAtlasPath.VarType='file';
Opt.CBAtlasPath.VarFilter={'*.nii', 'NIfTI Files'; '*.*', 'All Files (*.*)'};
Opt.CBAtlasPath.VarVal=fullfile(SUITPath, 'cerebellar_atlases-1.0', 'Buckner_2011',...
    'atl-Buckner7_space-SUIT_dseg.nii');