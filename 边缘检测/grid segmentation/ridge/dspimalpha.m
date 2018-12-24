function dspimalpha(I1, I2)

%% display the transparented two images
figure();
imshow(I1), hold on;
himage = imshow(cat(3,zeros(size(I2)),I2, I2));
set(himage, 'AlphaData', 0.3);