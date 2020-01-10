%%  ...............................................
%功能： 旋转、缩放平移图像存入指定尺寸，不需要计算整幅旋转图像
%输入：原图像、缩放系数、旋转角度、平移参数、指定图像的尺寸
%输出： 指定尺寸的图像
%author: hs 0110/2020
%% ...............................................

clear all
% close all
clc

%% 输入参数
%输入原始图像
img = (imread('football.jpg'));
% figure;imshow(img,[])
[height,width,channel] = size(img);
%指定输出图像大小
ActualH = 600;
ActualW = 800;
if(channel==3)
    ActualImg = zeros(ActualH,ActualW,3);
else
    ActualImg = zeros(ActualH,ActualW,1);
end


%输入缩放系数
scale = 1;
%输入旋转角度
angle = 30*pi/180;
%输入相对于原图像中心点平移的大小（类似轨迹球平移图像）
transh = 60;   %上下移动   + 向上移动  -向下移动
transw = 0;     %左右移动  - 向右移动  +向左移动
%是否使用双线性插值
biliinterp = 0;
%% 主程序
%图像中心位置
ActualHCenter = ActualH/2;
ActualWCenter = ActualW/2;
%缩放矩阵
Tscale = [scale,0,0;
    0,scale,0;
    0,0,1];
%旋转矩阵
Trotate = [cos(angle),-sin(angle),0;
    sin(angle),cos(angle),0;
    0,0,1];
%仿射变换矩阵
T =  Trotate*Tscale;
%计算仿射变化图像大小

point = [0,0,height,height;
    0,width,0,width;
    1,1,1,1];
pointT = T*point;
offsetH = min(pointT(1,:));
offsetW = min(pointT(2,:));

% %实际图像大小
maxH =  max(pointT(1,:));
maxW =  max(pointT(2,:));
NewH = floor(maxH-offsetH);
NewW = floor(maxW-offsetW);

centerpoint = T*[height/2+transh;width/2+transw;1];
anchorH = floor(centerpoint(1)-offsetH);
anchorW = floor(centerpoint(2)-offsetW);
InvT = inv(T);
ImgTh = floor(anchorH+ActualHCenter)-floor(anchorH-ActualHCenter+1)+1;
ImgTw = floor(anchorW+ActualWCenter)-floor(anchorW-ActualWCenter+1)+1;
if(ImgTh~=ActualH||ImgTw~=ActualW)
    error('error')
end
if (biliinterp ==1)
    
    
    for i= floor(anchorH-ActualHCenter+1):floor(anchorH+ActualHCenter)
        for j = floor(anchorW-ActualWCenter+1):floor(anchorW+ActualWCenter)
            newpoint = floor(InvT*[i+offsetH+0.5;j+offsetW+0.5;1]);
            if(newpoint(1)>=1&&newpoint(1)<=height&&newpoint(2)>=1&&newpoint(2)<=width)
                if(channel==3)
                    ActualImg(i- floor(anchorH-ActualHCenter+1)+1,j-floor(anchorW-ActualWCenter+1)+1,:) = bilinear_interpolation(img, newpoint(2), newpoint(1));
                    
                else
                    ActualImg(i- floor(anchorH-ActualHCenter+1)+1,j-floor(anchorW-ActualWCenter+1)+1) = bilinear_interpolation(img, newpoint(2), newpoint(1));
                end
            end
        end
    end
    
else
    for i= floor(anchorH-ActualHCenter+1):floor(anchorH+ActualHCenter)
        for j = floor(anchorW-ActualWCenter+1):floor(anchorW+ActualWCenter)
            newpoint = floor(InvT*[i+offsetH+0.5;j+offsetW+0.5;1]);
            if(newpoint(1)>=1&&newpoint(1)<=height&&newpoint(2)>=1&&newpoint(2)<=width)
                if(channel==3)
                    ActualImg(i- floor(anchorH-ActualHCenter+1)+1,j-floor(anchorW-ActualWCenter+1)+1,:) = img(newpoint(1),newpoint(2),:);
                else
                    ActualImg(i- floor(anchorH-ActualHCenter+1)+1,j-floor(anchorW-ActualWCenter+1)+1) = img(newpoint(1),newpoint(2));
                    
                end
            end
            
        end
    end
end


%% 显示最终图像
figure;imshow(uint8(ActualImg))

%实际图像大小
if(channel==3)
    ImgOut = zeros(NewH,NewW,3);
else
    ImgOut = zeros(NewH,NewW,1);
end

for i= 1:NewH
    for j = 1:NewW
        newpoint = floor(InvT*[i+offsetH+0.5;j+offsetW+0.5;1]);
        if(newpoint(1)>=1&&newpoint(1)<=height&&newpoint(2)>=1&&newpoint(2)<=width)
            if(channel==3)
                ImgOut(i,j,:) = img(newpoint(1),newpoint(2),:);
            else
                ImgOut(i,j) = img(newpoint(1),newpoint(2));
                
            end
        end
        
    end
end
figure;imshow(uint8(ImgOut))

