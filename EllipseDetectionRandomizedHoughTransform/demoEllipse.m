% demoEllipse.m demonstrates using the findellipse by finding the ellipse in
% in the ellipse.bmp image
%
% Setup:
%   1. In findellipseParams make sure iterations is 50 and maxEpochs is 10 
%   2. ellipse.bmp should be in the directory this demo is run from
%

clear all
clc
% load the image 
img = imread('ellipse.bmp');
%e = edge(img);
e = ~img;
[bestEllipses, originalImage] = findellipse(e);
bestEllipses


