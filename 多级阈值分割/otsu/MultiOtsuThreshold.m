%  Algorithm: PS.Liao, TS.Chen, and PC. Chung,
%          A Fast Algorithm for Multilevel Thresholding
%
% by huang shuai
%  Date     : 12/24/2018

clear all
close all
clc
src = double((imread('1.jpg')));
I = src;
%% Convert to 256 levels
% I = I-min(I(:));
% I = round(I/max(I(:))*255);
[histo,pixval] = hist(I(:),256);
p = histo/sum(histo);
w = cumsum(p);
P = zeros(256,256);
S = zeros(256,256);
%%  similar P(1,:) = w
for v=0:255
    if v==0
        P(1,v+1) = p(1,v+1);
        S(1,v+1) = p(1,v+1);
    else
        P(1,v+1) = P(1,v)+p(1,v+1);
        S(1,v+1) = S(1,v)+p(1,v+1)*(v+1);
    end
end
for u=2:256
    for v = 1:256
        
        P(u,v) = P(1,v)-P(1,u-1);
        S(u,v) = S(1,v)-S(1,u-1);
        if(P(u,v)<0)
            P(u,v) = 0;
        end
        if(S(u,v)<0)
            S(u,v) = 0;
        end
    end
end
H = zeros(256,256);
for  i=1:256
    for  j=i+1:256
        
        if (P(i,j) ~= 0)
            H(i,j) = (S(i,j)*S(i,j))/P(i,j);
        else
            H(i,j) = 0;
        end
    end
end

%% example 4
Level = 4;
M = Level-1;

MaxNum = -9999;
for i  =  1:256-M
    for j = i+1:256-M+1
        for k = j+1:256-M+2
            sdev = H(1,i) + H(i+1,j) + +H(j+1,k)+H(k+1,256);
            
            if MaxNum<sdev
                MaxNum = sdev;
                index(1,1) = i;
                index(1,2) = j;
                index(1,3) = k;
            end
            
        end
    end
end
IDX = ones(size(I))*Level;
IDX(I<=index(1)) = 1;
IDX(I>index(1) & I<=index(2)) = 2;
IDX(I>index(2) & I<=index(3)) = 3;
figure;imshow(IDX,[])
%% example 5
Level = 5;
M = Level-1;

MaxNum = -9999;
for i  =  1:256-M
    for j = i+1:256-M+1
        for k = j+1:256-M+2
            for l = k+1:256-M+3
                sdev = H(1,i) + H(i+1,j) + +H(j+1,k)+H(k+1,l)+H(l+1,256);
                
                if MaxNum<sdev
                    MaxNum = sdev;
                    index(1,1) = i;
                    index(1,2) = j;
                    index(1,3) = k;
                    index(1,4) = l;
                end
                
            end
        end
    end
end
IDX = ones(size(I))*Level;
IDX(I<=index(1)) = 1;
IDX(I>index(1) & I<=index(2)) = 2;
IDX(I>index(2) & I<=index(3)) = 3;
IDX(I>index(3) & I<=index(4)) = 4;
figure;imshow(IDX,[])
IDX = otsu(I,5);
figure;imshow(IDX,[])