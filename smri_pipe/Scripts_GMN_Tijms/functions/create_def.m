function [Y1,Y2,Y3] = create_def(T,VG,VF,Affine)
% Generate a deformation field from its parameterisation.
d2   = size(T);
d    = VG.dim(1:3);
M    = VF.mat\Affine*VG.mat;
[x1,x2,o] = ndgrid(1:d(1),1:d(2),1);
x3   = 1:d(3);
B1   = spm_dctmtx(d(1),d2(1));
B2   = spm_dctmtx(d(2),d2(2));
B3   = spm_dctmtx(d(3),d2(3));
[pth,nam,ext] = fileparts(VG.fname);
spm_progress_bar('init',length(x3),['Creating Def: ' nam],'Planes completed');
for z=1:length(x3),
    [y1,y2,y3] = defs(T,z,B1,B2,B3,x1,x2,x3,M);
    Y1(:,:,z)  = single(y1);
    Y2(:,:,z)  = single(y2);
    Y3(:,:,z)  = single(y3);
    spm_progress_bar('set',z);
end;
spm_progress_bar('clear');
return;
%=======================================================================
