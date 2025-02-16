function a= rotation_xyz_6vox(dim,forty)
% Takes the dimensions of a cube as argument and returns the array a which contains the indices to rotate a cube of that dimension.

%% Rotate over the X axis
X90=[];
for i=dim:-1:1
	for t=0:(dim-1)
		X90=[X90, i+t*dim^2];
	end

	% Use i as starting value for next loop
	y=i;
	for j=1:(dim-1)
		y=i+j*dim;
		for t=0:(dim-1)
			X90=[X90, y+t*dim^2];
		end
	end
end

X180=X90(X90);
X270=X180(X90);

% idem for 45 degrees : now instead of dim steps --> ceil(median(1:dim)) : so shift to the middle of the dimension (2 voor 3 voxels, 4 for 7; in even cases, rounded to highest integer, which is not exactly 45degrees but an approximation)
X45=[];
% Loop through the slices in the Z dimension
for i=1:dim

	% Slice 1: loop through the columns and  calculate new location
	if (i ==1)
		for ( j = 0:1:(dim-1))
			% For the first column of the first dimension
	
			
			for t=floor(dim/2):-1:1
				
				X45=[X45, (i+j*dim) + t * dim^2 ];
			
			end
		
	
			for t=(floor(dim/2)+1):1:dim
	
				X45=[X45, ((t+j*dim) -floor(dim/2))];
			end
		end

	end

	% Slice 2: loop through the columns and calculate new location
	if ( i == 2)
		
		ti = dim^2 + 1;

		for (j = 0:1:(dim-1))

			tj = 0;
			
			for t=floor(dim/2):-1:1
				
				if(t > 1)
					X45 = [X45, (ti + tj + j*dim) + t* dim^2];
					tj = tj +1;
					
				else

					X45 = [X45, (ti + tj + j*dim -1) + t* dim^2];
					tj = tj +1;
				end
			end

	
			for t=(floor(dim/2)+1):1:dim
	
				if(t < dim)
					X45=[X45, ((t+dim^2+j*dim+1) -floor(dim/2))];
				else
					X45=[X45, ((t+dim^2+j*dim - 2) - dim^2)];
				end
			end

		end
	end

	if ( i == 3)

		ti = dim^2 * 2 + 1;

		for (j = 0:1:(dim-1))

			tj = 0;
			for t= floor(dim/2):-1:1

				X45 = [X45, (ti + j*dim + tj+ t*dim^2)];
				tj = tj +1;
			end

			tj = 0;
			for t=(floor(dim/2)+1):1:dim

				X45=[X45, ((t+2*dim^2 -1 +j*dim) - tj * dim^2)];
				tj = tj+1;
			end
		end


	end


	if ( i == 4)

		ti = dim^2 * 3 + 1;

		for (j = 0:1:(dim-1))

			tj = 0;
			for t= (floor(dim/2)-1):-1:0

				X45 = [X45, (ti + j*dim + 1+ tj + t*dim^2)];
				tj = tj + 1;
			end

			tj = 1;
			for t=(floor(dim/2)):1:(dim-1)

				X45 = [X45, ((t+3*dim^2 +1  +j*dim) - tj * dim^2)];
				tj = tj +1;

			end
		end
	end

	if ( i == 5)

		ti = dim^2 * 4 + 1;
		for ( j = 0:1:(dim-1))

			for t= 0:(floor(dim/2)-1)

				if ( t == 0)
					X45 = [X45, (ti + j*dim + 2+ dim^2)];

				else
					X45 = [X45, (ti + j*dim + 2 + t )];

				end
			end

			tj = 1;
			for t=(floor(dim/2)):1:(dim-1)
			
				if ( t == floor(dim/2))
					X45 = [X45, ((ti +j*dim + t) -  tj*dim^2 +1)];
					tj = tj+1;
				else

					X45 = [X45, ((ti + j*dim + t) - tj*dim^2)];
					tj = tj+1; 
				end

			end

		end

	end

	if ( i == 6)

		ti = dim^2 * 5 + 1;

		for ( j = 0:1:(dim-1))

			for t= 0:(floor(dim/2)-1)
				
				X45 = [X45, (ti + j*dim + 3 +t)];
				
			end

			tj = 1;
			ttj=2;
			for t=(floor(dim/2)):1:(dim-1)

				X45 = [X45, (ti+t + j*dim - tj*dim^2 + ttj)];
				tj=tj+1;
				ttj=ttj-1;
			end

		end
	end

end

% When done get the correct orde of the indices
[temp X45] = sort(X45);

X135= X45(X90);
X225= X135(X90);
X315 = X225(X90);


% test whether ok:
%X360=X270(X90);this should be the original indices

%% Y rotation

Y90=[];
for i=0:(dim-1)
	y=dim^2*(dim-1)+1+i*dim;

	%Loop through other dimensions	
	for t=0:dim-1
		Y90=[Y90 (y-t*dim^2):(y-t*dim^2+dim-1)];
	end
end	

Y180=Y90(Y90);
Y270=Y180(Y90);

% Test if correct
%Y360=Y270(Y90);
%all(Y360(:)==Y360(:))

% Y rotation in 3*45 degrees
%Y45 = [10,11,12,1,2,3,4,5,6,19,20,21,13,14,15,7,8,9,22,23,24,25,26,27,16,17,18];

Y45=[];

for (i = 1:6)

	if( i == 1)

		for (col = 3:-1:1)

			for ( ind = 1:6)
				
				Y45=[Y45, (col*dim^2 + ind)];

			end
		end

		for ( t = 0:2)
		
			for (ind = 1:6)
				
				Y45 = [Y45, (ind + t * dim)];
				
			end
			
		end

	end

	if( i == 2)

		for (col = 4:-1:2)

			if ( col==4)
				
				for ( ind = 1:6)	
					Y45 = [Y45, (dim^2 * col +ind)];
				end
			end

			if ( col <4 )

				for ( ind = 1:6)	
					Y45 = [Y45, (dim^2 * col +dim +ind)];
				end
			end

		end

		for ( col = 1:3)

			if(col < 3)
				
				for( ind = 1:6)

					Y45=[Y45, (dim^2 + dim* col + ind)];
				end

			end

			if(col==3)
				for( ind = 1:6)

					Y45=[Y45,  (dim* col + ind)];
				end

			end
		end

	end

	if ( i == 3)

		t = 0;
		for ( col = 5:-1:3)

			for ( ind= 1:6)
				Y45=[Y45,  (dim^2 * col +t*dim + ind)];
			end
			
			t = t+1;
		end

		t=2;
		for ( col = 2:-1:0)

			
			if ( col > 0)
				for ( ind= 1:6)
					Y45=[Y45,  (dim^2 * col + t*dim + ind)];
				end

				
			end

			if ( col == 0)

				for ( ind= 1:6)
					Y45=[Y45,  (dim^2 * col +t*dim + ind)];
				end
			end
			
			t=t+1;
			
		end
	end

	if ( i == 4)

		t=1;
		for ( col = 5:-1:3)
			
			for(ind = 1:6)
				Y45 = [Y45, (dim^2 * col + t*dim + ind)];
			end

			t=t+1;
		end

		t= 3;
		for (col= 2:-1:0)

			for(ind = 1:6)
				Y45=[Y45,(dim^2 * col + t*dim + ind)];
			end

			t=t+1;
		end
	end


	if ( i == 5)

		
		for ( t = 2:4)
		
			if( t==2)	
				for(ind = 1:6)
					Y45 = [Y45, (dim^2 * 5 + t*dim + ind)];
				end
			end

			if( t>2)
				for(ind = 1:6)
					Y45 = [Y45, (dim^2 * 4 + t*dim + ind)];
				end
			end

		
		end

		for ( col=3:-1:1)

			if(col>1)
				for(ind=1:6)
					Y45 = [Y45, (dim^2 * col + 4*dim + ind)];
				end
			end

			if( col == 1)
				for ( ind = 1:6)
					Y45 = [Y45, (dim^2 * col + 5*dim + ind)];
				end
			end

		end
	end

	if( i == 6)

		for ( t = 3:5)

			for ( ind = 1:6)
				Y45=[Y45, (dim^2 * 5 + t * dim+ind)];
			end

		end

		for ( col = 4:-1:2)

			for ( ind = 1:6)
				Y45 = [ Y45, (dim^2 * col + 5*dim+ind)];
			end
		end


	end
end

Y135=Y45(Y90);
Y225=Y135(Y90);
Y315=Y225(Y90);

%% Z Rotation

Z90=[];
for i=dim:dim^2:dim^3
	% loop through other dimensions
	for t=0:dim-1
		Z90=[Z90, i+t*dim];
	end
	
	% Loop through other dimensions
	for j=i-1:-1:(i-dim+1)
	
		for t=0:dim-1
			Z90=[Z90, j+t*dim];
		end

	end
end

Z180=Z90(Z90);
Z270=Z180(Z90);

% test whether ok:
%Z360=Z270(Z90);
%all(Z360(:)==cube(:))

% Z rotation 3* 45 degrees
%Z45= [2,3,6,1,5,9,4,7,8,11,12,15,10,14,18,13,16,17,20,21,24,19,23,27,22,25,26];

Z45=[];

for ( i = 0:5)

	% col 1
	for (j = 2:-1:0)

		Z45=[Z45, (dim - j + dim^2 *i)]; 
		
	end

	for ( j = 2:4)

		Z45=[Z45, (dim * j+ dim^2 *i)];

	end

	% col 2
	for (j = 3:-1:1)

		if( j == 3)
			Z45=[Z45, (dim - j+ dim^2 *i)]; 
		end

		if(j<3)
			Z45=[Z45, (dim * 2 - j+ dim^2 *i)];
		end
	end

	for ( j = 3:5)

		if( j <5 )
			Z45=[Z45, (dim * j - 1+ dim^2 *i)];
		end

		if( j ==5 )
			Z45=[Z45, (dim * j+ dim^2 *i)];
		end

	end

	% col 3
	for (j = 1:3 )

		t=[-4,-3,3];
		Z45= [Z45, (dim * j + t(j)+ dim^2 *i)];

	end
	
	t= [2, 5, 6];
	t2= [3,-1,0];
	for (j =1:3 )
		
		Z45=[Z45, (dim*t(j) + t2(j)+ dim^2 *i)];	
	end

	% col 4
	t=[-5,-4,4];
	for ( j = 1:3)

		Z45=[Z45, (dim * j + t(j)+ dim^2 *i)];

	end

	t= [3, 5, 6];
	t2= [-2,-2,-1];
	for (j =1:3 )
		
		Z45=[Z45, (dim*t(j) + t2(j)+ dim^2 *i)];	
	end

	%col 5
	t=[1,2,2];
	for ( j = 1:3)

		Z45=[Z45, (dim * j + t(j)+ dim^2 *i)];

	end		

	t= [4, 4, 6];
	t2= [2,3,-2];
	for (j =1:3 )
		
		Z45=[Z45, (dim*t(j) + t2(j)+ dim^2 *i)];	
	end

	% col 6
	for (j = 2:4)

		Z45=[Z45, (dim *j + 1 + dim^2 *i)]; 
		
	end

	for ( j = 1:3)

		Z45=[Z45, (dim * 5 + j+ dim^2 *i)];

	end

end

Z135= Z45(Z90);
Z225= Z135(Z90);
Z315= Z225(Z90);

%% Reflection over X axis
cube=1:dim^3;
cube=reshape(cube,dim,dim,dim);

Xref=[];
for i=1:dim
	t=flipud(cube(:,:,i));
	Xref=[Xref, reshape(t,1,dim^2)]; 
end

%% Reflect over Y axis
Yref=[];
for i=1:dim
	t=fliplr(cube(:,:,i));
	Yref=[Yref, reshape(t,1,dim^2)]; 
end

%% Reflect over Z axis
Zref=[];
for i=dim:-1:1
	Zref=[Zref, reshape(cube(:,:,i),1,dim^2)]; 
end

if forty==1
	a=[[1:dim^3]',Y90',Y180',Y270',X90',X180',X270',Z90',Z180',Z270',Yref',Xref',Zref'];
elseif forty == 2
	a=[[1:dim^3]',Y45', Y90',Y135', Y180',Y225',Y270',Y315',X45', X90',X135', X180',X225',X270',X315',Z45', Z90',Z135', Z180',Z225',Z270',Z315',Yref',Xref',Zref'];
end