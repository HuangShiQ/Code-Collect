function bwridge1 = bwridgecenter(I, vesseltag)

%% extract the centerline of ridge
[M_mag, M_deg] = im_scalablehess2( I, [10:2:20], vesseltag);
M_mag = nonmaxsup(M_mag, M_deg, 1.5);
valuethresh = graythresh( M_mag );
bwridge = im2bw( M_mag, valuethresh ); 
bwridge = bwmorph(bwridge, 'thin', Inf);
bwridge1 = bwareaopen(bwridge, 100);
bwridge1 = imdilate(bwridge1, ones(3,3));

%% no special, only an additional action for watershed later
bwboundary = ones(size(bwridge1));
bwboundary(2:end-1,2:end-1)=0; 
bwridge1(bwboundary>0) = 1;

%%
% figure();
% subplot 221; imshow( I ); title('original image');
% subplot 222; imshow( M_mag, [] ); title('gray ridge');
% subplot 223; imshow( bwridge ); title('initial ridge');
% subplot 224; imshow( bwridge1 ); title('final ridge');