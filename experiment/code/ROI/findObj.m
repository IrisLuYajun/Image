%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI区域自动检测算法之从众多边界中找出目标边界，即颈动脉边界
%% Inputs:  
%%     out - 黑白灰三色图像
%%     Imsc   - rf经hilbert变换得到的图像
%%     rawIm  - 原始rf数据
%%  Output:
%%     ROI - 提取出的目标ROI
%%     hmin,hmax - ROI的上下边界坐标值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ROI,hmin,hmax] = findObj( out ,Imsc,rawIm)
output = out;
[lengthy,lengthx] = size(output);
 %% 遍历每个像素，将灰色像素点转换为黑色，整个图像变为黑白二值图像，并统计白色255像素点个数
    length255 = 0;%灰度值为255像素点的个数
    for x =1:lengthx
            for y = 1: lengthy
               if output(y,x) == 100
                   output(y,x) = 0;
              end
                if  output(y,x) == 255
                    length255 = length255 + 1;
                end

           end
    end
    length255
    figure;
    imagesc(output);colormap(gray);
    axis([0 lengthx 0 lengthy]);
    %%  根据RF数据缩小目标区域的范围
    domain = 20;
    [output,n] = findObjByRF(output,rawIm,domain);
    %%  为了从众多边界中找出颈动脉远端边界，根据颈动脉解剖学结构，原始图像中（G），颈动脉远端边界上方有最小的强度值（intensity）
    length_aver =250;%在255的像素点上方求平均的像素点长度
    aver = getIntensityMatrix(length_aver,output,Imsc,rawIm);



    %%  找出颈动脉边界线
    length =round(size(n,1)*0.1);%显示像素长度为2900，设置的越大说明显示的白色轮廓点越多
    [output,n] = getMinIntensity(aver,length);
    figure;
    imagesc(output);colormap(gray);
    axis([0 lengthx 0 lengthy]); 
%     [output,n] = findObjByRF(output, rawIm);
    %%  确定ROI的高度，并在原始B图的灰度图上找到ROI，宽度等于原始图像宽度
     a = n - mean(n);%3sigema原则，去除杂点
     b = 1 * std(n);
     index = find(a > b | a<(-b));
     n(index) = [];
     a = [];
     b = [];
     index = [];
     a = n - mean(n);%3sigema原则，去除杂点
     b = 1 * std(n);
     index = find(a > b | a<(-b));
     n(index) = [];
     
     max_y = max(n);
     min_y = min(n);
     h = (max_y-min_y);
     hmin = min_y-7*h;
     hmax = max_y+7*h;
     if hmin <= 1
         hmin = 1;
     end
     if hmax >= size(Imsc,1)
         hmax = size(Imsc,1);
     end

     ROI = Imsc(hmin:hmax,:);
     %imshow可以将ROI显示出来，灰度正常，但是宽高比恒定，不能调节成矩形形状
     %figure;
     %imshow(ROI);
     %image与imagesc一样需要设置corlormap，但是不同的是image得到的ROI图像会整体变白，而imagesc不会
     %figure;
     %image(ROI);
     %colormap(gray);
     figure;
     imagesc(ROI);
     colormap(gray);%imagesc得到的图像形状有些失真，可以通过调节figure的窗口大小改变ROI形状

end



