% Function to write regional results to an image: image can then be used for surface plotting
% Please check the comments for lines that may need to be adjusted 

% Adjust below to point to a text file with result directories and paths
[CN_a2]=textread('/insert_path_to_text_file/result_dirs.txt','%s');

numimages=size(CN_a2,1);

%  % Adjust below according to the metric that you want to plot
for im=1:numimage
	%go to appriopriate directory
	tempd=char(CN_a2(im));
	cd(tempd)
	
	% Load the metric that you want to plot: Here the degree as an example
	load data/rotation/degree.mat

	% Load the other data necessary
	load data/nz.mat
	load data/lookup.mat
	load data/bind.mat
	load Va.mat
		
	% The degree depends on the size of a network so : normalise to values between 1 - 0
	stand_degree = degree ./max(degree);

	% If you use another image resolution  please adjust accordingly
	degree_image=zeros([91,109,91]);
		
	for i=1:nz
	
		% Get the voxel indices for the cube
		tb=bind(lookup(:,i));
		degree_image(tb)=stand_degree(i);
	end
	
	l1=Va;
	l1.pinfo=[0,0,0]';
	l1.fname='images/degree_image.img';
	%store data in image
	spm_write_vol(l1, degree_image);

	
	cd ..
	im
end
