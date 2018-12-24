%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A demo for image segmentation using iterative watersheding plus ridge detection. 
% Copyright(c) 2008 Li CHEN (chenli.wh at gmail.com)
% School of Computer Science & Engineering
% The Wuhan University of Science and Technolgoy
% http://imvl.wust.edu.cn/
% 
% Note: 
% I would like to write a detatiled description, but time is limited
% This program is inspired by 
% Cell segmentation at http://blogs.mathworks.com/steve/2006/06/02/cell-segmentation/
% Ridge detection from NaiXiang LIAN, Peter Kovein, etc.

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% Version 1.0
% September 2008 - finished basic version ^_^
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Step 1: load image
startup;
filename = 'wkd02.jpg';
filepath = '.\data1\';
readfile = strcat(filepath,filename);
ridgetag = 'dark'; % 'dark' or 'bright'
imgscale = 1;

I_ori = im2double(imread(readfile));
I_ori = imresize(I_ori(:,:,1),imgscale); %downsize the image if you want a quick result
[M, N]= size(I_ori);

%% Step 2: reinforce the edge and smooth the image
Itarget = I_ori;
if ~strcmp(ridgetag, 'dark'); %edges assumes be dark
    Itarget = imcomplement(Itarget);
end
Itarget = ordfilt2(Itarget,1,ones(3,3)); %3-by-3 minimum filter
Itarget = ordfilt2(Itarget,9,ones(3,3)); %3-by-3 maximum filter

%% Step 3: first round of watershed
slen = 3;
graythresh = 0.1;
areathresh = 20;

%bwridge = edge(Itarget,'canny'); %ridge should be better
bwridge = bwridgecenter(Itarget, ridgetag);
bwgray = gray2bw( Itarget, graythresh, areathresh );
bwblobs = bwgray&(~bwridge);
Iblobs = imimposemin(-Itarget, bwblobs);
L = watershed(Iblobs);

%dspimalpha(Itarget, bwblobs);
%dspimcat(I_ori,L); title(['WaterShed Iteration ', int2str(0)]);

%% Step 4: Lrgb is too detailed, merge small blobs to a larger one 
NUMITER = 3;
MERGETHRESH = 0.1;
NUMTHRESH = 80;
RATIO = (0.6/MERGETHRESH)^(1/NUMITER);

L1 =  L;
Itarget1 = Itarget;
Itarget1 = ordfilt2((Itarget1-Itarget1.*bwridge/2), 1, ones(3,3)); %3-by-3 minimum filter
%figure(); imshow(Itarget1, []); title('ridge information');
    
% start the iteration, GO
for iteration = 1:NUMITER
    MERGETHRESH = MERGETHRESH*RATIO;
    NUMTHRESH = NUMTHRESH/RATIO;
    L1 = MarkPseudoBlob( L1, bwridge, NUMTHRESH, MERGETHRESH );
    D1 = DepthMeature(L1, Itarget1); 
    Lt = watershed(D1);
    L1 = ModifyWaterShed(L1, Lt);
    L1 = RemovePseudoContour(L1);
   %dspimcat(I_ori, L1); title(['WaterShed Iteration ', int2str(iteration)]);
end

%%
Iout = dspimanalys(I_ori, L1);
imwrite(Iout,strcat(filepath,'\result\result_', filename));
