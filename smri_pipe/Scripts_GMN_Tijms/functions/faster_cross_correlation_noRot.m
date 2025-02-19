function [r] = faster_cross_correlation_noRot(rois)

corr=zeros(size(rois,2),'single');

% Construct numerator and denumerator tables, that contain precomputed sums

% n sum contains c_ij - mean(c_j) --> so the mean of the particular column subtracted from all the cells in that column.

% Get the mean and put in a matrix with the same size as rois
mean_rois=mean(rois);

% t_mean_mat=mean_rois(ones(1,size(rois,1)),:); % This is same as below, but slightly slower
t_mean_mat=ones(size(rois,1),1)*mean_rois;	%repmat is also possible but this is a bit faster (don't understand why).
n_sum= rois-t_mean_mat;

% d_sum is basically n_sum squared and then the root
% NOTE need to sum over squared values before taking sqrt!!!
d_sum= sqrt(sum(n_sum.^2));

%t2='s1/vox_corrs.m';
%fid=fopen(t2, 'a');



% Compute the pairwaise correlation between all voxels
% NB Only necessary to do this for the uppertriangle
for i = 1:size(n_sum,2)
	% seed is i

	%tic
	%don't correlate with itself
%	for 
	j = (i+1):size(n_sum,2);
	tseed = repmat(n_sum(:,i),1,length(j));
	td_sum =d_sum(i)* ones(1,length(j),'single');
		% Target is j
		
		% Calculate all correlations --> take produkt of nseed and ntarget and sum over the rows, divide by the product of dseed and dtarget
%		tr= sum(n_sum(:,i) .* n_sum(:,j))./(d_sum(i)*d_sum(j));


%  		% Will this be faster if we compute for each seed all the rows at the same time?
	tr= sum(tseed .* n_sum(:,j))./(td_sum.*d_sum(j));

	%fprintf(fid, '%d \n', tr);
	corr(i,j)=tr;

	clear tseed td_sum tr

		% Save the correlation
	%corr(i,j)=tr;
	
end
%fclose(fid);


% Save only necessary variables in temp directory --> for memory issues
% clear the rest and load all of them
t=corr';
r=t+corr;

