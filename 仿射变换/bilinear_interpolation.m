function out =  bilinear_interpolation(img, x, y)
%输入图像
%x 宽度方向
%y 高度方向
[height,width,channel] = size(img);
x_pos = floor(x);
x_u = x - x_pos;
xb = x_pos+1;
y_pos = floor(y);
y_v = y - y_pos;
yb = y_pos+1;
if(x_pos<=0||xb>width||xb<=0||x_pos>width||y_pos<=0||yb>height||yb<=0||y_pos>height)
    out(1,1:3) = 0;
else
    P1 = img(y_pos, x_pos, 1:channel) .* (1 - x_u) + img(y_pos, xb,  1:channel) .* x_u;
    P2 = img(yb, x_pos,  1:channel) .* (1 - x_u) + img(yb, xb, 1:channel) .* x_u;
    out =  floor(P1 .* (1 - y_v) + P2 .* y_v);
    out(out>255) = 255;
    out(out<0) = 0;
end
