
function [x1,y1,z1] = defs(sol,z,B1,B2,B3,x0,y0,z0,M)
if ~isempty(sol),
    x1a = x0    + transf(B1,B2,B3(z,:),sol(:,:,:,1));
    y1a = y0    + transf(B1,B2,B3(z,:),sol(:,:,:,2));
    z1a = z0(z) + transf(B1,B2,B3(z,:),sol(:,:,:,3));
else
    x1a = x0;
    y1a = y0;
    z1a = z0;
end;
x1  = M(1,1)*x1a + M(1,2)*y1a + M(1,3)*z1a + M(1,4);
y1  = M(2,1)*x1a + M(2,2)*y1a + M(2,3)*z1a + M(2,4);
z1  = M(3,1)*x1a + M(3,2)*y1a + M(3,3)*z1a + M(3,4);
return;