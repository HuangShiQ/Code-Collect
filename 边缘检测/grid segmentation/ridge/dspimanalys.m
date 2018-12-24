function Iout1 = dspimanalys(I, L)

%% Perform analysis on the results and visualize the results
[M, N] = size(I);

Stats = regionprops( bwlabel(L>0), 'ALL');
Str = ['Grid No. = ', int2Str(numel(Stats))];
centroids = cat(1, Stats.Centroid);
areas = cat(1, Stats.Area);
diame = cat(1, Stats.EquivDiameter);
diam1 = cat(1,Stats.MajorAxisLength);
diam2 = cat(1,Stats.MinorAxisLength);
orien = cat(1,Stats.Orientation);
[sval, sidx] = sort(areas);

%% Figure 1
Iout = dspimcat(I, L); hold on; title(Str);
plot(centroids(:,1), centroids(:,2), 'r*');
plot(N+centroids(:,1), centroids(:,2), 'r*');
plot(centroids(sidx(end),1), centroids(sidx(end),2), 'r*','LineWidth',2, 'MarkerSize',15);
plot(N+centroids(sidx(end),1), centroids(sidx(end),2), 'r*','LineWidth',2, 'MarkerSize',15);

%% Figure 2
scrsz = get(0,'ScreenSize');
figure('Position', scrsz ); 
subplot 211; grid on; hold on; 
bar(sort(areas),'g'); title(' Area of each blob(Pixel)'); ylabel('Pixel'); xlabel('blob index');
subplot 212; grid on; hold on;
bar(sort(diame),'g'); title('Average Diameter of each blob (sqrt(4*Area/\pi))'); ylabel('Pixel'); xlabel('blob index');

%% Figure 3: draw bigger N ecllipse
BIGN = 5;
s1 = [centroids(:,1), centroids(:,2), diam1/2,  diam2/2, orien*pi/180 ];
s2 = [N+centroids(:,1), centroids(:,2), diam1/2,  diam2/2, orien*pi/180 ];
s1 = s1(sidx(end:-1:end-BIGN+1),:);
s2 = s2(sidx(end:-1:end-BIGN+1),:);

Iout1 = Iout; 
Iout1 = DrawEllipse(Iout1, s1' , [255, 0, 0], [255, 0, 255]);
Iout1 = DrawEllipse(Iout1, s2' , [255, 0, 0], [255, 0, 255]);
scrsz = get(0,'ScreenSize');
figure('Position', scrsz );
imshow(Iout1,[], 'InitialMagnification', 'fit'); title(' Shape of blob');