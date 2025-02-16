function w_RunVBMIndiNetStepFour(T1Dir, T1Key, UserOpt)
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
    w_PrintOpt(RunOpt, 'Running VBM Individual Network Step 2&3');
end
PerformVBMIndiNetStepFour(RunOpt);

function PerformVBMIndiNetStepFour(Opt)
T1ImgPath=Opt.T1ImgPath;
[SubjPath, T1Name, T1Ext]=fileparts(T1ImgPath);

SPMPath=fileparts(which('spm.m'));
DPSMRIPath=fileparts(which('dpsmri.m'));
B1Dir = fullfile(DPSMRIPath, 'bl_ind');

result_dir=fullfile(SubjPath, 'networks');
cd(result_dir);

%% Step4: get small world properties
sw_mat=zeros(1, 22);

load(fullfile(result_dir, 'rand_sw.mat'), '-mat');
load(fullfile(result_dir, 'data', 'th.mat'), '-mat');
load(fullfile(result_dir, 'data', 'rotation', 'rot_bin_all_degree.mat'), '-mat');
load(fullfile(result_dir, 'data', 'rotation', 'rot_c_i.mat'), '-mat');

%load (strcat(char(CN_a2(im)), '/data/rotation/BC.m'), '-mat');
load(fullfile(result_dir, 'data', 'nz.mat'), '-mat');
load(fullfile(result_dir, 'data', 'inf_check.mat'), '-mat');
load(fullfile(result_dir, 'data', 'rotation', 'rotL.mat'), '-mat');
load(fullfile(result_dir, 'data', 'rotation', 'rotcorr.mat'), '-mat');
load(fullfile(result_dir, 'data', 'rois.mat'), '-mat');
load(fullfile(result_dir, 'data', 'fp.mat'), '-mat');

sw_mat(1,1)=nz;	% The number of cubes = number of nodes = size of the network
sw_mat(1,2)=mean(rot_bin_all_degree);	% The average degree of the network (average of all the degrees of the nodes, degree = number of connections a node has).
sw_mat(1,3)=mean(rot_c_i);	% Average clustering coefficient of the network, averaged over all the nodal clustering values
sw_mat(1,4)=fp;	% false positive rate --> to check if threshold was set correctly. Then it should be around 5% for everyone
sw_mat(1, 5)=rotL;	% Average minimum path length

sw_mat(1, 11)=mean(rois(:));	% The average intensity value for every roi
sw_mat(1, 12)=std(rois(:));	% Standard deviation of the above
sw_mat(1,13)=std(rot_bin_all_degree);	% Standard diviation ofthe degree in a network
sw_mat(1,14)=std(rot_c_i);	% standard deviation of the clustering coefficient

sw_mat(1,16)= sum(rot_bin_all_degree)/(nz*(nz-1))*100;	% sparsity of the network = connection density.

% Load rotD to get std(rotL)
load(fullfile(result_dir, 'data', 'rotation', 'rotD.mat'), '-mat');

% Cees measure of Hierarchy : C * kappa ; kappa = <k2>/<k>
sw_mat(1,19) = sw_mat(1, 3)* (mean(rot_bin_all_degree.^2)/mean(rot_bin_all_degree));

sw_mat(1, 20) = sum(inf_check);

% First Fisher transform the variables --> NOTE : subtract 0.00001 to avoid issues at extremes
zrotcorr = rotcorr - 0.00001;
zrotcorr = 0.5 .* log( (1+zrotcorr)./(1-zrotcorr) );
meanZ = mean(zrotcorr(:));

sw_mat(1, 21) = (exp(meanZ)- exp(-meanZ) ) / (exp(meanZ)+exp(-meanZ));	%mean(zrotcorr(:));

% Also check th value
sw_mat(1, 22) = th;

% parameters for random network
mean_random_sw=zeros(1,7);

% Load random_sw.m -mat --> with the clustercoefficient and pathlength from 20 random graphs
load(fullfile(result_dir, 'rand_sw.mat'), '-mat');
% Load cluster coefficient from original networks
load(fullfile(result_dir, 'data', 'rotation', 'rot_c_i.mat'), '-mat');
% Load pathlength coefficient from original networks
load(fullfile(result_dir, 'data', 'rotation', 'rotD.mat'), '-mat');

rotL=mean(rotD(rotD~=Inf));

mean_random_sw(1,1)=mean(rand_sw(:,1));	% Clustercoefficient
mean_random_sw(1,2)=std(rand_sw(:,1));
mean_random_sw(1,3)=mean(rand_sw(:,4));	%Path_length
mean_random_sw(1,4)=std(rand_sw(:,4));
mean_random_sw(1,5)= mean(rot_c_i)/mean(rand_sw(:,1));	% compute gamma from average
mean_random_sw(1,6)= rotL/mean(rand_sw(:,4));	% compute lambda from average
mean_random_sw(1,7)= mean_random_sw(1,5)/mean_random_sw(1,6); % compute sigma from above

sw_mat(:, 6) = mean_random_sw(:,3); % rL
sw_mat(:,7)= mean_random_sw(:,5); % gamma
sw_mat(:,8)=mean_random_sw(:,6); % lambda
sw_mat(:,9)=mean_random_sw(:,7); % sigma
sw_mat(:,10)=mean_random_sw(:,1);% mean rand_c_i
sw_mat(:,15)=mean_random_sw(:,2);% std rand_c_i
sw_mat(:,17)=mean_random_sw(:,4); % std rL

save(fullfile(result_dir, 'sw_mat_MCI.mat'), 'sw_mat');
%save sw_mat_MCI.mat sw_mat