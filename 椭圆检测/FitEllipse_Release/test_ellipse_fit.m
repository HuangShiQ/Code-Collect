data = [9.9 12.1 14.9 16.1 17.1 19.9; 
        43.1 42.8 42.7 42.1 41.9 40.6 ]
params = fitellipse(data(1,:)',data(2,:)');

 t = linspace(0,pi*2);
  x = params(3) * cos(t);
  y = params(4) * sin(t);
  nx = x*cos(params(5))-y*sin(params(5)) + params(1); 
  ny = x*sin(params(5))+y*cos(params(5)) + params(2);
  hold on
  plot(nx,ny,'r-')
  hold on
plot(data(1,:),data(2,:),'ob');

%质心绘制
hold on;
str = strcat('(',num2str(params(1),3),',',num2str(params(2),3),')')
plot(params(1),params(2),'og');
text(params(1),params(2), str);
%绘制长轴短轴的起始点和终点
 t = [0 pi/2 pi 3*pi/2];
  x = params(3) * cos(t);
  y = params(4) * sin(t);
  nx = x*cos(params(5))-y*sin(params(5)) + params(1); 
  ny = x*sin(params(5))+y*cos(params(5)) + params(2);
  for k = 1:4
        str = strcat('(',num2str(nx(k),3),',',num2str(ny(k),3),')')
        text(nx(k),ny(k), str);
        plot(nx(k),ny(k),'og');
%         plot(x(k)+ params(1),y(k)+ params(1),'og');
  end
  line(nx([1 3]),ny([1 3]));
    line(nx([2 4]),ny([2 4]));