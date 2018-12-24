function Iout = dspimcat(I1, I2)

%% display the catenated two images
[M N P] = size(I1);
if (P==1)
    I1 = im2uint8(I1);
    I1 = cat(3, I1, I1, I1);
end

I2 = label2rgb(I2, 'summer', 'k', 'shuffle');

Iout = [I1, I2];

scrsz = get(0,'ScreenSize');
figure('Position', scrsz );
imshow(Iout, [], 'InitialMagnification', 'fit');            