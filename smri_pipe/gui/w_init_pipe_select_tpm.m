function DisplayStruct=w_init_pipe_select_tpm(Opt)
if exist('Opt', 'var')==0
    Opt=[];
end

if isempty(Opt)
    Opt=w_init_pipe_select_opt;
end

% Col-1: LeftStr, Col-2: RightStr, Col-3: OptStateFlag
Tpm=cell(0);
Tpm{1, 1}='Voxel-based Morphometry'; Tpm{1, 3}='CcVBMDisplay';
Tpm{2, 1}=' . Perform:'; Tpm{2, 2}='CcVBM'; Tpm{2, 3}='CcVBMDisplay';
Tpm{3, 1}='Surface-based Morphometry'; Tpm{3, 3}='CcSBMDisplay';
Tpm{4, 1}=' . Perform:'; Tpm{4, 2}='CcSBM'; Tpm{4, 3}='CcSBMDisplay';
Tpm{5, 1}='Cerebellum Segmentation'; Tpm{5, 3}='CbVBMDisplay'; 
Tpm{6, 1}=' . Perform:'; Tpm{6, 2}='CbVBM'; Tpm{6, 3}='CbVBMDisplay';
Tpm{7, 1}='VBM Indi Networks'; Tpm{7, 3}='CcVBMIndiNetDisplay'; 
Tpm{8, 1}=' . Perform:'; Tpm{8, 2}='CcVBMIndiNet'; Tpm{8, 3}='CcVBMIndiNetDisplay';

DisplayStruct.Opt=Opt;
DisplayStruct.Tpm=Tpm;