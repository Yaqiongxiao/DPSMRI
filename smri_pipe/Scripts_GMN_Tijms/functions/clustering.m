function [a inf_check disc_check] = clustering(bin_all, st)

%% Compute the clustering coefficient for a given network

%initialise variables
a=single(zeros(st,1));
inf_check=single(zeros(st,1));
disc_check=single(zeros(st,1));
tct=0;
ct=0;
neigh=0;

for i= 1:st
	
	% Only go into the analysis of node is connected --> otherwise c_i = 0
	if sum(bin_all(i,:))==0
		discon_check(i)=1;
	else
		%get neighbours --> which is 1 in row i
		neigh=find(bin_all(i,:)==1);
		%exclude test node --> is node (i,i).
		neigh(neigh==i)=[];

		%only continue if there are minimally 2 neighbours
		if length(neigh) > 1
			%check relations between neighbours & store count
			%count connections only once, -1 --> there is no self-connection-> so no -1.
			k_i=length(neigh);
			for j=1:k_i
				tct=sum(bin_all(neigh(j),neigh(j:end)));
				ct=ct+tct;
			end
		
			%compute c_i: Actual_number_edges/max_number_edges_possible
			denum=(k_i*(k_i-1))/2;
			a (i)= ct / denum;
			
			if denum == 0
				inf_check(i)=1;
			end
		end
	end

	%reset variables
	k_i=0;
	neigh=0;
	denum=0;
	ct=0;
	tct=0;
end

