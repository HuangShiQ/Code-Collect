function D = DepthMeature(L, I)    

%% We consider image = blob_large U blob_zero U (blob_small_contour+blob_small_inside)
bw_large = (L>0);
bw_small = (L<0);
bw_small_contour = bwperim(bw_small);
bw_small_inside = bw_small-bw_small_contour;
D_small_contour = bw_small_contour.*(1-I);
D = -bw_large + D_small_contour + bw_small_inside;