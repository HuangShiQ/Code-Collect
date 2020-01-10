%%  ...............................................
%���ܣ� ��ת������ƽ��ͼ�����ָ���ߴ磬����Ҫ����������תͼ��
%���룺ԭͼ������ϵ������ת�Ƕȡ�ƽ�Ʋ�����ָ��ͼ��ĳߴ�
%����� ָ���ߴ��ͼ��
%author: hs 0110/2020
%% ...............................................

clear all
% close all
clc

%% �������
%����ԭʼͼ��
img = (imread('football.jpg'));
% figure;imshow(img,[])
[height,width,channel] = size(img);
%ָ�����ͼ���С
ActualH = 600;
ActualW = 800;
if(channel==3)
    ActualImg = zeros(ActualH,ActualW,3);
else
    ActualImg = zeros(ActualH,ActualW,1);
end


%��������ϵ��
scale = 1;
%������ת�Ƕ�
angle = 30*pi/180;
%���������ԭͼ�����ĵ�ƽ�ƵĴ�С�����ƹ켣��ƽ��ͼ��
transh = 60;   %�����ƶ�   + �����ƶ�  -�����ƶ�
transw = 0;     %�����ƶ�  - �����ƶ�  +�����ƶ�
%�Ƿ�ʹ��˫���Բ�ֵ
biliinterp = 0;
%% ������
%ͼ������λ��
ActualHCenter = ActualH/2;
ActualWCenter = ActualW/2;
%���ž���
Tscale = [scale,0,0;
    0,scale,0;
    0,0,1];
%��ת����
Trotate = [cos(angle),-sin(angle),0;
    sin(angle),cos(angle),0;
    0,0,1];
%����任����
T =  Trotate*Tscale;
%�������仯ͼ���С

point = [0,0,height,height;
    0,width,0,width;
    1,1,1,1];
pointT = T*point;
offsetH = min(pointT(1,:));
offsetW = min(pointT(2,:));

% %ʵ��ͼ���С
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


%% ��ʾ����ͼ��
figure;imshow(uint8(ActualImg))

%ʵ��ͼ���С
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

