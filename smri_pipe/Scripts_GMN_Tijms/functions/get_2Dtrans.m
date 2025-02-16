function T2 = get_2Dtrans(T3,B,j)
d   = [size(T3) 1 1 1];
tmp = reshape(T3,d(1)*d(2),d(3));
T2  = reshape(tmp*B(j,:)',d(1),d(2));
return;