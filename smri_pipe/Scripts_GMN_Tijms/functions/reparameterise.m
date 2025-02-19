function [Affine,Tr] = reparameterise(Y1,Y2,Y3,B,M2,MT,d2)
% Take a deformation field and reparameterise in the same form
% as used by the spatial normalisation routines of SPM
d          = [size(Y1) 1];
[x1,x2,o]  = ndgrid(1:d(1),1:d(2),1);
x3         = 1:d(3);
Affine     = M2\MT*B(1).mat;
A          = inv(Affine);

B1  = spm_dctmtx(d(1),d2(1));
B2  = spm_dctmtx(d(2),d2(2));
B3  = spm_dctmtx(d(3),d2(3));
pd  = prod(d2(1:3));
AA  = eye(pd,'int8')*0.01;
Ab  = zeros(pd,3);
spm_progress_bar('init',length(x3),['Reparameterising'],'Planes completed');
mx = [0 0 0];
for z=1:length(x3),
    y1       = double(Y1(:,:,z));
    y2       = double(Y2(:,:,z));
    y3       = double(Y3(:,:,z));
    msk      = isfinite(y1);
    w        = double(msk);
    y1(~msk) = 0;
    y2(~msk) = 0;
    y3(~msk) = 0;
    z1       = A(1,1)*y1+A(1,2)*y2+A(1,3)*y3 + w.*(A(1,4) - x1);
    z2       = A(2,1)*y1+A(2,2)*y2+A(2,3)*y3 + w.*(A(2,4) - x2);
    z3       = A(3,1)*y1+A(3,2)*y2+A(3,3)*y3 + w *(A(3,4) - z );
    b3       = B3(z,:)';
    Ab(:,1)  = Ab(:,1) + kron(b3,spm_krutil(z1,B1,B2,0));
    Ab(:,2)  = Ab(:,2) + kron(b3,spm_krutil(z2,B1,B2,0));
    Ab(:,3)  = Ab(:,3) + kron(b3,spm_krutil(z3,B1,B2,0));
    AA       = AA  + kron(b3*b3',spm_krutil(w, B1,B2,1));
    spm_progress_bar('set',z);
end;
spm_progress_bar('clear');
Tr  = reshape(AA\Ab,[d2(1:3) 3]); drawnow;
return;