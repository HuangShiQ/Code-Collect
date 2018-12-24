
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo file
% I is the input image
% NThresholds: The number of thresholds required. It lies between
%              1 and (the difference between the maximum and minimum 
%              graylevel present in the image)
% This code is for thresholding of gray-scale images of 8-bit depth.
% Color images can also be inputted to this code. But it will be converted
% to gray-scale image by the code before starting the thresholding algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by : Sujoy Paul, Jadavpur University, Kolkata %
%              Email : paul.sujoy.ju@gmail.com          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread('55067.jpg');
NThresholds = 3;
if size(I,3)==3
    I=rgb2gray(I);
end
for i=1:size(I,3)
 cI(:,:,i) = thresholdImage(I(:,:,i),NThresholds);
end
figure,subplot(1,2,1),imshow(I),title('Original Image');
       subplot(1,2,2),imshow(cI),title(strcat('Thresholded Image (',num2str(NThresholds),' Thresholds)'));
