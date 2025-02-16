function [th, fp, sp] = auto_threshold(rotcorr, rrcorr, nz, x)

maxcor=nz*(nz-1);	

temp_triu= triu(rrcorr,1);

th = prctile(rrcorr(temp_triu(:)~=0),x);

fp = sum(rrcorr(:)>th)/maxcor;

sp= sum(rotcorr(:)>th)/maxcor*100;

return