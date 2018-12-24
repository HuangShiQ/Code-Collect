function draw_img = DrawEllipse(cur_img, regs, colortable, colortable1)

%% regs: elliptical region s=[xpos,ypos,xscale,yscale, orient]
draw_img = cur_img;
[a b c] = size(cur_img);
num_reg = size(regs,2);

nseg = 400;
theta = 0:(2*pi/nseg):(2*pi);
Circle = [cos(theta);sin(theta)];

%draw elliplse
for j = 1:num_reg
    Ellipse = ([cos(regs(5,j)) sin(regs(5,j)); -sin(regs(5,j)) cos(regs(5,j)) ]*[regs(3,j) 0; 0 regs(4,j)])*Circle;
    px = regs(1,j)+ Ellipse(1,:);
    py = regs(2,j)+ Ellipse(2,:);
    px = min(max(ceil(px),1+1),b-1);
    py = min(max(ceil(py),1+1),a-1);

    mask = uint8(zeros(a,b));
    mask(sub2ind([a,b],py,  px)) = 1;
    mask(sub2ind([a,b],py+1,px)) = 1;
    mask(sub2ind([a,b],py-1,px)) = 1;
    mask(sub2ind([a,b],py,  px+1)) = 1;
    mask(sub2ind([a,b],py,  px-1)) = 1;
    for i=1:c
        draw_img(:,:,i) = draw_img(:,:,i).*(1-mask) + colortable(i)*mask;
    end
end

% draw center
px = regs(1,:);
py = regs(2,:);
px = [ px, px+0, px+0, px+0, px+0, px-1, px+1, px-2, px+2];
py = [ py, py-1, py+1, py-2, py+2, py+0, py+0, py+0, py+0];
px = min(max(ceil(px),1+1),b-1);
py = min(max(ceil(py),1+1),a-1);

mask = uint8(zeros(a,b));
mask(sub2ind([a,b],py,  px)) = 1;
mask(sub2ind([a,b],py+1,px)) = 1;
mask(sub2ind([a,b],py-1,px)) = 1;
mask(sub2ind([a,b],py,  px+1)) = 1;
mask(sub2ind([a,b],py,  px-1)) = 1;
for i=1:c
    draw_img(:,:,i) = draw_img(:,:,i).*(1-mask) + colortable1(i)*mask;
end
