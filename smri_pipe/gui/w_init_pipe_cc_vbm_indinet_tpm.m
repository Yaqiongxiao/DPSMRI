function DisplayStruct=w_init_pipe_cc_vbm_indinet_tpm(Opt)
if exist('Opt', 'var')==0
    Opt=[];
end

if isempty(Opt)
    Opt=w_init_pipe_cc_vbm_indinet_opt;
end

% Col-1: LeftStr, Col-2: RightStr, Col-3: OptStateFlag
Tpm=cell(0);
Tpm{1, 1}='Tissue Probability  Map:     '; Tpm{1, 2}='TPMPath'; 
% Registration Method
Tpm{2, 1}='Registration Method:     '; Tpm{2, 2}='RegMethod';
RegMethodTpm=cell(0);
RegMethodTpm{1, 1}={'. Shooting Template:     ', 'ShootingTPMPath'};
RegMethodTpm{2, 1}={'. Dartel Template:     ', 'DartelTPMPath'};
Tpm{2, 3}=RegMethodTpm;

Tpm{3, 1}='Number Of Random Network:     '; Tpm{3, 2}='NumRandNet';

DisplayStruct.Opt=Opt;
DisplayStruct.Tpm=Tpm;