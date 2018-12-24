function Lout = RemovePseudoContour(L)


%% Remove the psudo boundaries to make it looks better
LABELNUM = max(L(:));
bwbound = (L==0);
Lmin = ordfilt2(L+bwbound.*(LABELNUM+1),1,ones(3,3)); %3-by-3 minimum filter
Lmax = ordfilt2(L,9,ones(3,3)); %3-by-3 maximum filter
Lout = L + Lmax.*bwbound.*((Lmax-Lmin)==0);