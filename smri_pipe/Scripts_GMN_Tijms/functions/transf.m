function t = transf(B1,B2,B3,T)
d2 = [size(T) 1];
t1 = reshape(T, d2(1)*d2(2),d2(3)); drawnow;
t1 = reshape(t1*B3', d2(1), d2(2)); drawnow;
t  = B1*t1*B2';
return;