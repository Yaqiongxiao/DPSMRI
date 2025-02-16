function DisplayStruct=w_init_pipe_cb_vbm_tpm(Opt)
if exist('Opt', 'var')==0
    Opt=[];
end

if isempty(Opt)
    Opt=w_init_pipe_cb_vbm_opt;
end

% Col-1: LeftStr, Col-2: RightStr, Col-3: OptStateFlag
Tpm=cell(0);
Tpm{1, 1}='Cerebellum Atlas:     '; Tpm{1, 2}='CBAtlasPath'; 
DisplayStruct.Opt=Opt;
DisplayStruct.Tpm=Tpm;