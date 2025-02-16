function DisplayStruct=w_init_pipe_cc_vbm_tpm(Opt)
if exist('Opt', 'var')==0
    Opt=[];
end

if isempty(Opt)
    Opt=w_init_pipe_cc_vbm_opt;
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

Tpm{3, 1}='Atlas Neuromophoometrics:     '; Tpm{3, 2}='DoAtlasNeuromophoometrics';
Tpm{4, 1}='Atlas Lpba40:     '; Tpm{4, 2}='DoAtlasLpba40';
Tpm{5, 1}='Atlas Cobra:     '; Tpm{5, 2}='DoAtlasCobra';
Tpm{6, 1}='Atlas Hammers:     '; Tpm{6, 2}='DoAtlasHammers';
Tpm{7, 1}='Atlas Thalamus:     '; Tpm{7, 2}='DoAtlasThalamus';
Tpm{8, 1}='Atlas Suit:     '; Tpm{8, 2}='DoAtlasSuit';
Tpm{9, 1}='Atlas Ibsr:     '; Tpm{9, 2}='DoAtlasIbsr';
Tpm{10, 1}='User-Defined Atlas:     '; Tpm{10, 2}='AtlasOwnPaths';

DisplayStruct.Opt=Opt;
DisplayStruct.Tpm=Tpm;