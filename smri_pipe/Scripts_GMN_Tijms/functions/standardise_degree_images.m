% Standardise lerch values
CN_a2=textread('/haso/users/bettytij//Betty/results/old_cohort_76subjects/native/result_dirs.txt','%s');

numimages=size(CN_a2,1);

for im=1:numimages

	this_scan=char(CN_a2(im));

	Va = spm_vol(strcat(this_scan, 'images/degree_lerch.img'));
	Sa = spm_read_vols(Va);
	Sa(Sa==0)=NaN;

	Sa = (Sa-min(Sa(:)))./(max(Sa(:))-min(Sa(:)));

	l1=Va;
	l1.pinfo=[0,0,0]';
	l1.fname=strcat(this_scan, 'images/stand_rot_lerch_all.nii');

	%store data in image
	spm_write_vol(l1, Sa);

	im
end


% 

(i1+i2++i3++i4++i5++i6++i7+i8+i9+i10+i11+i12+i13+i14+i15+i16+i17+i18+i19+i39+i40+i41+i42++i43++i44++i45++i46++i47+i48+i49+i50+i51+i52+i53+i54+i55+i56+i57)./38

(i20+i21+i22+i23+i24+i25+i26+i27+i28+i29+i30+i31+i32+i33+i34+i35+i36+i37+i38+i58+i59+i60+i61+i62++i63+i64+i65+i66+i67+i68+i69+i70+i71+i72+i73+i74+i75+i76)/38