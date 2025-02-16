function w_RunVBMIndiNetStepOne(T1Dir, T1Key, UserOpt)

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
if IsDEBUG
    w_PrintOpt(RunOpt, 'Running VBM Individual Network Step 1');
end
PerformVBMIndiNetStepOne(RunOpt);

function PerformVBMIndiNetStepOne(Opt)
T1ImgPath=Opt.T1ImgPath;
[SubjPath, T1Name, T1Ext]=fileparts(T1ImgPath);

SPMPath=fileparts(which('spm.m'));
DPSMRIPath=fileparts(which('dpsmri.m'));
B1Dir = fullfile(DPSMRIPath, 'bl_ind');
warning('off');
rmpath(genpath(B1Dir));
warning('on');
%%% Step 1: batch extract network
% Get content of all_dirs.txt files ( this file contains all the dirs of the cube template for all possible off set values)
CN_a2 =textread(fullfile(B1Dir, 'all_dirs.txt'),'%s');

% Go to the directory where you want to store your output (i.e., networks)
result_dir=fullfile(SubjPath, 'networks');
if exist(result_dir, 'dir')==0 
    mkdir(result_dir);
end 

% FILL IN THE FULL PATH of the directory where the resliced images should live.
reslice_dir=fullfile(SubjPath, 'reslice');
if exist(reslice_dir, 'dir')==0 
    mkdir(reslice_dir)
end

% number of dimensions
n=3;
s=n^3;

% FILL IN THE FILE NAME with full path that contains the text file with all the grey matter segmentations 
cd(result_dir)

% Loop through all the grey matter segmentations listed in CN_a1 and extract network. Takes ~25 minutes per scan.
t1_scan=T1ImgPath;
this_scan=fullfile(SubjPath, 'mri', sprintf('p1%s.nii', T1Name));
   
rotation_dir=fullfile(result_dir, 'data', 'rotation');
if exist(rotation_dir, 'dir')==0
    mkdir(rotation_dir);
end
images_dir=fullfile(result_dir, 'images');
if exist(images_dir, 'dir')==0
    mkdir(images_dir)
end
	
% make a temporary copy of the grey matter segmentation in this directory
copyfile(this_scan, fullfile(result_dir, 'temp_grey.nii'));
	
% Make sure that the native image realigns with MNI images
P1= fullfile(SPMPath,'canonical', 'avg305T1.nii');
coreg_est = spm_coreg(P1, t1_scan);
M = inv(spm_matrix(coreg_est));
MM = spm_get_space('temp_grey.nii'); % adjust the header of the grey matter image to store these realigned parameters
spm_get_space('temp_grey.nii', M *MM);
	
% save the reorientation paramters
save(fullfile(result_dir, 'images', 'coreg_est.mat'), 'coreg_est');

% Next reslice the scan to 2x2x2 mm isotropic voxels to reduce amount of data.
P = strvcat(P1, 'temp_grey.nii');
    
ResliceT1ImgPath=fullfile(reslice_dir, sprintf('iso2mm_%s.nii', T1Name));    
Q = ResliceT1ImgPath;
f = 'i2';
flags = {[],[],[],[]};
R = spm_imcalc(P,Q,f,flags); % Note if you use SPM12: change spm_imcalc_ui into --> spm_imcalc
%  
%  	%close the figure window
%close

% remove the temporary grey matter image
delete(fullfile(result_dir, 'temp_grey.nii'))

% Now extract Sa and Va --> Va contains all the info from the .hrd file, Sa is the actual image, it contains the grey matter intensity values.
Va=spm_vol(ResliceT1ImgPath);
Sa=spm_read_vols(Va);

% Save them in the current directory
save Va.mat Va
save Sa.mat Sa

% clear variables that aren't needed anymore
clear this_scan P Q R f flags

%% Get the off_set bl_ind (this corresponds to the indices that make up the 3d cubes)  with the minimum number if cubes (min. nz).
[nz, nan_count, off_set] = determine_rois_with_minimumNZ(CN_a2, B1Dir, n, Sa);

% Store nz.m : the number of cubes, this is the size of the network
save(fullfile(result_dir, 'data', 'nz.mat'), 'nz');

% nan_count = number of cubes that have a variance of 0, these are excluded because cannot compute correlation coefficient for these cubes.
save(fullfile(result_dir, 'data', 'nan_count.mat'), 'nan_count');
% off_set indicates which specific template was used to get the cubes.
save(fullfile(result_dir, 'data', 'off_set.mat'), 'off_set');

% Get bind and store bind too. Bind contains the indices of the cubes, so we can efficiently do computations later. It is a long vector of which every 27 consecutive voxels are a cube.
%tt=strcat(bl_dir, off_set, '/data/bind.m');
load(fullfile(result_dir, 'data', 'bind.m'));
	
% Convert to single, for memory reasons
bind=single(bind);
delete(fullfile(result_dir, 'data', 'bind.m'));
save data/bind.mat bind
save(fullfile(result_dir, 'data', 'bind.mat'), 'bind');

% Now create:
% - the rois: This is a matrix of which each column corresponds to a cube, we will compute use this to compute the correlations
% - lookup table --> to lookup the cubes that correspond to the correlations.

lb=length(bind); % End point for loop
col=1;		% iteration counter

rois=zeros(s,nz, 'single');	% Create variable to store the rois (i.e., cubes)
lookup=zeros(s,nz, 'single');	% Create variable to store the lookup table --> this table links the cubes to the indices in the original iso2mm image.

% The next loop gos through bind for indices of voxels that belong to each ROI (i.e. cube)
% lb is the last voxel that belongs to a roi
%lookup is lookup table to go from corr index to bind to Sa

for i=1:s:lb
    rois(:,col)=Sa(bind(i:(i+(s-1))));
    lookup(:,col)=i:(i+(s-1));
    col=col+1;
end

% Save the rois and lookup table
save(fullfile(result_dir, 'data', 'rois.mat'), 'rois');

% look up table --> to go from corr index to bind to Sa
save(fullfile(result_dir, 'data', 'lookup.mat'), 'lookup');

%clear unneeded variables
clear lookup lb

%	%% Randomise ROIS: Create a 'random brain' to estimate the threshold with for later stages
[rrois, rlookup]= create_rrois(rois, n, Sa, Va, off_set, bind, B1Dir, nz);

% save rrois and rlookup
save(fullfile(result_dir, 'data', 'rrois.mat'), 'rrois');
save(fullfile(result_dir, 'data', 'rlookup.mat'), 'rlookup');

% Remove all variables that take space and aren't needed anymore
clear bind lookup rlookup Sa Va

% Set the following variable to 2 when correlation is maximised for rotation with angle multiples of 45degrees.
forty=2;

[rotcorr, rrcorr] = fast_cross_correlation(rois, rrois, n,forty);

% Save it
save(fullfile(result_dir, 'data', 'rotation', 'rotcorr.mat'), 'rotcorr');
save(fullfile(result_dir, 'data', 'rotation', 'rrcorr.mat'), 'rrcorr');

%% Now get the threshold and save it
[th, fp, sp] = auto_threshold(rotcorr, rrcorr, nz);

% Add this threshold to all_th
%all_th(im,:)=[th,fp,sp];
%save this and get later
save(fullfile(result_dir, 'data', 'th.mat'), 'th');
save(fullfile(result_dir, 'data', 'fp.mat'), 'fp');
save(fullfile(result_dir, 'data', 'sp.mat'), 'sp');

% Clear all variables
clear rotcorr rrcorr th fp sp
