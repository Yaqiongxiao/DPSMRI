% Function to plot a lerch like plot with a value 

%x = lerch_plotting(Va, vals )

cd /data/rad10/projects/dementie3Tcohort/ac/12-12/Betty/results/old_cohort_76subjects/

[CN_a2]=textread('/data/rad10/projects/dementie3Tcohort/ac/12-12/Betty/results/old_cohort_76subjects/native/result_dirs.txt','%s');

numimages=size(CN_a2,1);

for im=1:numimages	%[9,15]  %im=1:numimages
	%go to appriopriate directory
	tempd=char(CN_a2(im));
	cd(tempd)
	% Load data needed
	%load data/rotation/BC.m -mat
	load data/rotation/rot_bin_all_degree.m -mat
	load data/nz.m -mat
	load data/lookup.m -mat
	load data/bind.m -mat
	load Va.m -mat
	
	% get hub indices
	%hub_ind=find(BC> (mean(BC)+std(BC)));
	%hub_bc(hub_ind)=BC(hub_ind);
	
	% normalise the degree to values between 1 - 0
	stand_degree = rot_bin_all_degree ./max(rot_bin_all_degree); 
	degree_lerch=zeros([91,109,91]);
	%bc_hub_lerch=zeros([91,109,91]);
	
	for i=1:nz
	
		% Get the indices for the cube
		tb=bind(lookup(:,i));
		%lerch_d(tb)=md;
		%lerch_mc(tb)=r;
		degree_lerch(tb)=stand_degree(i);	%BC(i); %bc2(i); %deg_hub(i);	% %st_degree(i);
		%bc_hub_lerch(tb)=hub_bc(i);
	end
	
	l1=Va;
	l1.pinfo=[0,0,0]';
	%l1.fname=strcat(tempd, '/images/rot_lerch_all.img');
	l1.fname='images/rank_degree_lerch.img';
	%store data in image
	spm_write_vol(l1, degree_lerch);
	
	
	load data/rotation/BC.m -mat
	
	stand_BC = BC ./mean(BC); 
	BC_lerch=zeros([91,109,91]);
	%bc_hub_lerch=zeros([91,109,91]);
	
	for i=1:nz
	
		% Get the indices for the cube
		tb=bind(lookup(:,i));
		%lerch_d(tb)=md;
		%lerch_mc(tb)=r;
		BC_lerch(tb)=stand_BC(i);	%BC(i); %bc2(i); %deg_hub(i);	% %st_degree(i);
		%bc_hub_lerch(tb)=hub_bc(i);
	end
	
	l1=Va;
	l1.pinfo=[0,0,0]';
	%l1.fname=strcat(tempd, '/images/rot_lerch_all.img');
	l1.fname='images/BC_lerch.img';
	%store data in image
	spm_write_vol(l1, BC_lerch);
	
	cd ..
	im
end
