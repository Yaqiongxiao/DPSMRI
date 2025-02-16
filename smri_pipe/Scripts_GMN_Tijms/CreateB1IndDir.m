% PATH where the canonical SPM image "avg305T1.nii´ can be found --> this is used to reslice the images
SPMPath=fileparts(which('spm.m'));
DPSMRIPath=fileparts(which('dpsmri.m'));
P1FilePath=fullfile(SPMPath, 'canonical', 'avg305T1.nii');

P1Nii=nifti(P1FilePath);

if exist(fullfile(DPSMRIPath, 'bl_ind', 'all_dirs.txt'), 'file')==0
    B1IndDir=fullfile(DPSMRIPath, 'bl_ind');
    if exist(B1IndDir, 'dir')==0
        mkdir(B1IndDir);
    end
    dimx=size(P1Nii.dat, 1);
    dimy=size(P1Nii.dat, 2);
    dimz=size(P1Nii.dat, 3);
    
    n=3;
    
    cd(B1IndDir);
    
    % Store all the directories in a text file --> needed when extracting network later
    delete('all_dirs.txt');
    fid1=fopen('all_dirs.txt', 'a');
    
    % Loop through x, y and z dimensions to make sure to cover all possible combinations of [x, y, z] starting coordinates
    for indx=1:n
        
        for indy=1:n
            
            for indz=1:n
                % Make the corresponding directory
                mkdir(strcat( char([int2str(indx), int2str(indy), int2str(indz)] ), '/data/rotation' ));
                mkdir(strcat( char([int2str(indx), int2str(indy), int2str(indz)] ), '/images' ));
                
                % Go to this directory
                cd( char([int2str(indx), int2str(indy), int2str(indz)]));
                
                store_dir= char([int2str(indx), int2str(indy), int2str(indz)]);
                fprintf(fid1, '%s \n', store_dir);
                
                %initialize variables
                b=zeros(dimx,dimy,dimz);	% Simulated volume with the same dimensions as the original volume
                tbl_ind=[];			% temporary cube index --> contains just one cube's worth of indices
                bl_ind=0;			% the cube index, a concatenation of all the tbl_ind
                
                i_start=((indz-1)*(dimx*dimy))+((indy-1)*dimx)+indx;	%(note: indz -1 has been done, because the first z dimension is the first slice --> so no transitation is needed. Simarlaly for (indy-1)
                i_step=(dimx*dimy*n);
                end_i=numel(b)-i_step;
                
                % Determine end row
                row_n=floor(dimx/n);
                
                if (dimx-n*row_n+1)<indx
                    end_k=n*row_n-n;	% --> for maximum 27 --> x max is 81
                else
                    end_k=n*row_n;	% --> for maximum 27 --> x max is 81
                end
                %end_k=n*row_n-n;	% --> for 256-124 dimensions
                
                % Step size for columns: The step should encompase all the columns that belong to a cube
                j_step=n*dimx;
                
                % Determine end column --> this should be adjusted to the index where the cube gridding is starting.
                if (dimy-n*(floor(dimy/n) ) )< indy
                    end_j=dimx*dimy-2*n*dimx;
                else
                    end_j=dimx*dimy-n*dimx;
                end
                
                %data storage
                delete('data/bl_ind.m');
                fid2=fopen('data/bl_ind.m', 'a');
                
                % Loop through all the  voxels in all directions to extract cubes
                for i=i_start:i_step:end_i
                    
                    for j=i:j_step:(i+end_j)
                        for k=j:n:(j+end_k-1)
                            % For each position on the z-axis extract a square of dimensions n x n
                            
                            for l=0:(n-1)
                                % 0 is the first position on the z-axis
                                tempz=dimx*dimy*l;
                                
                                start_k=k+tempz;
                                % At this z-position, extract the square, by adding n-1 columns to this --> so 2:(n-1) times dimxz
                                for m=0:(n-1)
                                    tempy=dimx*m;
                                    tbl_ind=[tbl_ind (start_k+tempy):(start_k+tempy+(n-1))];
                                end
                            end
                            
                            % store the indices corrsponding to cubes for this template
                            fprintf(fid2, '%d \n', tbl_ind);
                            %reset table_ind
                            tbl_ind=[];
                            %bl_ind=reshape(bl_ind',n,n,n);
                            %b(tbl_ind)=k;
                        end
                    end
                end
                % close the file connection
                fclose(fid2);
                
                % Go back one directory
                cd ..
            end
        end
        indx
    end
    fclose(fid1);
end