function w_RunVBMIndiNetStepTwoThree(T1Dir, T1Key, UserOpt)
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
PerformVBMIndiNetStepTwoThree(RunOpt);

function PerformVBMIndiNetStepTwoThree(Opt)
T1ImgPath=Opt.T1ImgPath;
[SubjPath, T1Name, T1Ext]=fileparts(T1ImgPath);

SPMPath=fileparts(which('spm.m'));
DPSMRIPath=fileparts(which('dpsmri.m'));
B1Dir = fullfile(DPSMRIPath, 'bl_ind');

im=1;
if ~isfield(Opt, 'NumRandNet')
    nrandnets = 20;
else
    nrandnets = str2num(Opt.NumRandNet);
end
result_dir=fullfile(SubjPath, 'networks');
cd(result_dir);
% Step 2: Small world analyses
load(fullfile(result_dir, 'data', 'th.mat'));
load(fullfile(result_dir, 'data', 'rotation', 'rotcorr.mat'));
% Threshold & binarize
bin_all=rotcorr>th;
rot_bin_all_degree=sum(bin_all);

% Save so this doesn't need to be computed again
save(fullfile(result_dir, 'data', 'rotation', 'rot_bin_all_degree.mat'), 'rot_bin_all_degree');
save(fullfile(result_dir, 'data', 'rotation', 'bin_all.mat'), 'bin_all');
clear rot_bin_all_degree
	
st=length(bin_all(:,1));

% NOTE NOTE Possibly necessary to switch this to rows instead of columns,
% although don't see why since the matrix is symmetric.
% --> why can thereby negative values? --? in the k_i part --> if k_i =0 00>

[rot_c_i inf_check discon_check]=clustering(bin_all, st);
if ~all(inf_check)
    save(fullfile(result_dir, 'data', 'inf_check.mat'), 'inf_check');
    clear inf_check
end

if ~all(discon_check==0)
    save(fullfile(result_dir, 'data', 'discon_check.mat'), 'discon_check');
    clear discon_check
end
save(fullfile(result_dir, 'data', 'rotation', 'rot_c_i.mat'), 'rot_c_i');
clear rot_c_i
	
%% Get characteristic short pathlength
%	[rotR, rotD]=reachdist(bin_all);
[rotR, rotD]=reachdist(bin_all);
all_L=sum(rotD);
% compute lamba
rotL=sum(sum(rotD(rotD~=Inf)))/length(nonzeros(rotD~=Inf));

%check if there are unconnected components: If so store indices --> to check which ones

infcount=find(rotD==inf);

if ~isempty(infcount)
    save(fullfile(result_dir, 'data', 'rotation', 'infcount.mat'), 'infcount');
end

save(fullfile(result_dir, 'data', 'rotation', 'rotR.mat'), 'rotR');
save(fullfile(result_dir, 'data', 'rotation', 'rotD.mat'), 'rotD');
save(fullfile(result_dir, 'data', 'rotation', 'all_L.mat'), 'all_L');
save(fullfile(result_dir, 'data', 'rotation', 'rotL.mat'), 'rotL');
clear ('rotR', 'rotD','all_L')

%% Step 3: batch_random_network
%loop through the dirs and create
%	1. binarized matrix
%	2. degree
%	3. cluster coefficient
%	4. R and D distance matrices
%	5. average characteristic pathlength per node in all_L

% number of random networks

%go to appriopriate directory
rand_sw=zeros(nrandnets, 7);
load(fullfile(result_dir, 'data', 'rotation', 'rot_c_i.mat'), '-mat');
load(fullfile(result_dir, 'data', 'rotation', 'rotD.mat'), '-mat');

m_rot_c_i=mean(rot_c_i);

rotL=mean(rotD(rotD~=Inf));

% Make a orary directory to store the random networks in. This will be deleted later.
temp_dir=fullfile(result_dir, 'temp');
if exist(temp_dir, 'dir')==0
    mkdir(temp_dir)
end
cd(temp_dir)
% Make 20 random versions of the network --> compute for all the network properties --> save these in a matrix for this person.
% It is not necessary to save the whole rot_c_i --> just the mean and standard deviation.
for r=1:nrandnets
    load(fullfile(result_dir, 'data', 'rotation', 'rot_bin_all_degree.mat'), '-mat');
    %Make a directory for the random network
    r_temp_dir=fullfile(temp_dir, int2str(r));
    if exist(r_temp_dir)==0
        mkdir(r_temp_dir);
    end
    cd(r_temp_dir);
    
    rand_bin=makerandCIJdegreesfixed(rot_bin_all_degree',rot_bin_all_degree');
    
    %save data/rotation/rand_bin.m rand_bin
    save(fullfile(r_temp_dir, 'rand_bin.mat'), 'rand_bin');
    clear rot_bin_all_degree
    
    %% clustering: The degree of connectivity between the direct neighbors of a
    %given node --> is a ratio of actual existing connections between them, and
    %the maximum number of possible connections (k_i*(k_i -1) /2 )
    
    %compute c_i per node and then average over nodes
    %c_i per node --> 1. get direct neighbours (nodes with which direct
    %connection (Bassett & Bullmore 2006)). Note k_i = degree!
    %           2. Count whether these neighbours are connected with each other
    
    st=length(rand_bin(:,1));
    
    rand_c_i=clustering(rand_bin,st);
    
    %load(strcat(char(CN_a2(im)),'/data/rotation/rot_c_i.m'),'-mat')
    %load(strcat(char(CN_a2(im)),'/data/rotation/rot_L.m'),'-mat')
    if any(isnan(rand_c_i))
        rand_c_i(isnan(rand_c_i))=0;
    end
    
    gamma=m_rot_c_i/mean(rand_c_i);
    
    %clear rot_c_i
    rand_sw(r, 1)= mean(rand_c_i);
    rand_sw(r, 2)= std(rand_c_i);
    rand_sw(r, 3)= gamma;
    
    clear rand_c_i
    %clear sigma
    
    %% Get characteristic short pathlength
    [rR, rD]=reachdist(rand_bin);
    rall_L=sum(rD);
    % compute lamba
    %rL=sum(sum(rD(rD~=Inf)))/length(nonzeros(rD~=Inf));
    rL=mean(rD(rD~=Inf));
    std_rL=std(single(rD(rD~=Inf)));
    
    rand_sw(r,4)=rL;
    rand_sw(r,5)=std_rL;
    
    %gamma=mean(rot_c_i)/mean(rand_c_i);
    lambda=rotL/rL;
    sigma= gamma/lambda;
    rand_sw(r,6)=lambda;
    rand_sw(r,7)=sigma;
    
    clear ('rR', 'rD','rall_L', 'rL')
end
cd(result_dir);
rmdir(temp_dir,'s');

save(fullfile(result_dir, 'rand_sw.mat'), 'rand_sw');


% %% Step4: get small world properties
% sw_mat=zeros(1, 22);
% 
% load(fullfile(result_dir, 'rand_sw.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'th.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'rotation', 'rot_bin_all_degree.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'rotation', 'rotcorr.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'rotation', 'rot_c_i.mat'), '-mat');
% 
% %load (strcat(char(CN_a2(im)), '/data/rotation/BC.m'), '-mat');
% load(fullfile(result_dir, 'data', 'nz.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'inf_check.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'rotation', 'rotL.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'rois.mat'), '-mat');
% load(fullfile(result_dir, 'data', 'fp.mat'), '-mat');
% 
% sw_mat(1,1)=nz;	% The number of cubes = number of nodes = size of the network
% sw_mat(1,2)=mean(rot_bin_all_degree);	% The average degree of the network (average of all the degrees of the nodes, degree = number of connections a node has).
% sw_mat(1,3)=mean(rot_c_i);	% Average clustering coefficient of the network, averaged over all the nodal clustering values
% sw_mat(1,4)=fp;	% false positive rate --> to check if threshold was set correctly. Then it should be around 5% for everyone
% sw_mat(1, 5)=rotL;	% Average minimum path length
% 
% sw_mat(1, 11)=mean(rois(:));	% The average intensity value for every roi
% sw_mat(1, 12)=std(rois(:));	% Standard deviation of the above
% sw_mat(1,13)=std(rot_bin_all_degree);	% Standard diviation ofthe degree in a network
% sw_mat(1,14)=std(rot_c_i);	% standard deviation of the clustering coefficient
% 
% sw_mat(1,16)= sum(rot_bin_all_degree)/(nz*(nz-1))*100;	% sparsity of the network = connection density.
% 
% % Load rotD to get std(rotL)
% load(fullfile(result_dir, 'data', 'rotation', 'rotD.mat'), '-mat');
% 
% % Cees measure of Hierarchy : C * kappa ; kappa = <k2>/<k>
% sw_mat(1,19) = sw_mat(1, 3)* (mean(rot_bin_all_degree.^2)/mean(rot_bin_all_degree));
% 
% sw_mat(1, 20) = sum(inf_check);
% 
% % First Fisher transform the variables --> NOTE : subtract 0.00001 to avoid issues at extremes
% zrotcorr = rotcorr - 0.00001;
% zrotcorr = 0.5 .* log( (1+zrotcorr)./(1-zrotcorr) );
% meanZ = mean(zrotcorr(:));
% 
% sw_mat(1, 21) = (exp(meanZ)- exp(-meanZ) ) / (exp(meanZ)+exp(-meanZ));	%mean(zrotcorr(:));
% 
% % Also check th value
% sw_mat(1, 22) = th;
% 
% % parameters for random network
% mean_random_sw=zeros(1, 7);
% 
% % Load random_sw.m -mat --> with the clustercoefficient and pathlength from 20 random graphs
% load(fullfile(result_dir, 'rand_sw.mat'), '-mat');
% % Load cluster coefficient from original networks
% load(fullfile(result_dir, 'data', 'rotation', 'rot_c_i.mat'), '-mat');
% % Load pathlength coefficient from original networks
% load(fullfile(result_dir, 'data', 'rotation', 'rotD.mat'), '-mat');
% 
% rotL=mean(rotD(rotD~=Inf));
% 
% mean_random_sw(1,1)=mean(rand_sw(:,1));	% Clustercoefficient
% mean_random_sw(1,2)=std(rand_sw(:,1));
% mean_random_sw(1,3)=mean(rand_sw(:,4));	%Path_length
% mean_random_sw(1,4)=std(rand_sw(:,4));
% mean_random_sw(1,5)= mean(rot_c_i)/mean(rand_sw(:,1));	% compute gamma from average
% mean_random_sw(1,6)= rotL/mean(rand_sw(:,4));	% compute lambda from average
% mean_random_sw(1,7)= mean_random_sw(1,5)/mean_random_sw(1,6); % compute sigma from above
% 
% sw_mat(:, 6) = mean_random_sw(:,3); % rL
% sw_mat(:,7)= mean_random_sw(:,5); % gamma
% sw_mat(:,8)=mean_random_sw(:,6); % lambda
% sw_mat(:,9)=mean_random_sw(:,7); % sigma
% sw_mat(:,10)=mean_random_sw(:,1);% mean rand_c_i
% sw_mat(:,15)=mean_random_sw(:,2);% std rand_c_i
% sw_mat(:,17)=mean_random_sw(:,4); % std rL
% 
% save(fullfile(result_dir, 'sw_mat_MCI.mat'), 'sw_mat');
% %save(fullfile(result_dir, 'sw_mat_MCI.txt', 'sw_mat', '-ASCII'));