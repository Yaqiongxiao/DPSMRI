function MT = procrustes(Y1,Y2,Y3,B,M2)
% Take a deformation field and determine the closest rigid-body
% transform to match it, with weighing.
%
% Example Reference:
% F. L. Bookstein (1997).  "Landmark Methods for Forms Without
% Landmarks: Morphometrics of Group Differences in Outline Shape"
% Medical Image Analysis 1(3):225-243

M1         = B.mat;
d          = B.dim(1:3);
[x1,x2,o]  = ndgrid(1:d(1),1:d(2),1);
x3         = 1:d(3);
c1  = [0 0 0];
c2  = [0 0 0];
sw  =  0;
spm_progress_bar('init',length(x3),['Procrustes (1)'],'Planes completed');
for z=1:length(x3),
    y1         = double(Y1(:,:,z));
    y2         = double(Y2(:,:,z));
    y3         = double(Y3(:,:,z));
    msk        = find(isfinite(y1));
    w          = spm_sample_vol(B(1),x1(msk),x2(msk),o(msk)*z,0);
    swz        = sum(w(:));
    sw         = sw+swz;
    c1         = c1 + [w'*[x1(msk) x2(msk)] swz*z ];
    c2         = c2 +  w'*[y1(msk) y2(msk) y3(msk)];
    spm_progress_bar('set',z);
end;
spm_progress_bar('clear');
c1 = c1/sw;
c2 = c2/sw;
T1 = [eye(4,3) M1*[c1 1]'];
T2 = [eye(4,3) M2*[c2 1]'];
C  = zeros(3);
spm_progress_bar('init',length(x3),['Procrustes (2)'],'Planes completed');
for z=1:length(x3),
    y1         = double(Y1(:,:,z));
    y2         = double(Y2(:,:,z));
    y3         = double(Y3(:,:,z));
    msk        = find(isfinite(y1));
    w          = spm_sample_vol(B(1),x1(msk),x2(msk),o(msk)*z,0);
    C = C + [(x1(msk)-c1(1)).*w (x2(msk)-c1(2)).*w (    z-c1(3))*w ]' * ...
            [(y1(msk)-c2(1))    (y2(msk)-c2(2))    (y3(msk)-c2(3)) ];
    spm_progress_bar('set',z);
end;
spm_progress_bar('clear');
[u,s,v]    = svd(M1(1:3,1:3)*C*M2(1:3,1:3)');
R          = eye(4);
R(1:3,1:3) = v*u';
MT         = T2*R*inv(T1);
return;
