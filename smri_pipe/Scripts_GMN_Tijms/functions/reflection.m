function a = reflection(cube_in, ax)

% Reflect given cube over given ax

cube=1:dim^3;
cube=reshape(cube,dim,dim,dim);

if ax == 1

	Xref=[];
	for i=1:dim
		t=flipud(cube(:,:,i));
		Xref=[Xref, reshape(t,1,dim^2)]; 
	end

elseif ax == 2

%% Reflect over Y axis
	Yref=[];
	for i=1:dim
		t=fliplr(cube(:,:,i));
		Yref=[Yref, reshape(t,1,dim^2)]; 
	end

%% Reflect over Z axis
elseif ax == 3
	
	Zref=[];
	for i=dim:-1:1
		Zref=[Zref, reshape(cube(:,:,i),1,dim^2)]; 
	end

end

a_names={'org','Y45','Y45(Xref)', 'Y45(Yref)', 'Y45(Zref)','Y90','Y90(Xref)','Y90(Yref)', 'Y90(Zref)','Y135','Y135(Xref)','Y135(Yref)','Y135(Zref)','Y180','Y180(Xref)','Y180(Yref)','Y180(Zref)','Y225','Y225(Xref)','Y225(Yref)','Y225(Zref)','Y270','Y270(Xref)','Y270(Yref)','Y270(Zref)','Y315','Y315(Xref)','Y315(Yref)','Y315(Zref)','X45', 'X45(Xref)','X45(Yref)','X45(Zref)','X90','X90(Xref)','X90(Yref)','X90(Zref)','X135','X135(Xref)','X135(Yref)','X135(Zref)','X180','X180(Xref)','X180(Yref)','X180(Zref)','X225','X225(Xref)','X225(Yref)','X225(Zref)','X270','X270(Xref)','X270(Yref)','X270(Zref)','X315','X315(Xref)','X315(Yref)','X315(Zref)','Z45', 'Z45(Xref)','Z45(Yref)','Z45(Zref)','Z90','Z90(Xref)','Z90(Yref)','Z90(Zref)','Z135','Z135(Xref)','Z135(Yref)','Z135(Zref)','Z180','Z180(Xref)','Z180(Yref)','Z180(Zref)','Z225','Z225(Xref)','Z225(Yref)','Z225(Zref)','Z270','Z270(Xref)','Z270(Yref)','Z270(Zref)','Z315','Z315(Xref)','Z315(Yref)','Z315(Zref)','Yref','Xref','Zref'};

% Check redundant reflections/rotations --> are there identical index vectors?

cend=size(a,2)-1;
dup_check=zeros(cend,2);
dup_count = 1;

for i = 1:cend
	t = a(:,i);
	for j = i+1:(cend+1)
		if all(t == a(:,j))
			dup_check(dup_count,:)=[i,j];
			dup_count=dup_count+1;
		end
	end
end

dup_check=dup_check(1:dup_count-1,:);

% Now the duplicates need to be excluded from a --> so use the unique indices from the second column to remove these
a(:, unique(dup_check(:,2)))=[];