%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI区域自动检测算法
%% 
%%
%% Inputs:  
%%     I     - unit类型的B-图
%%     rawIm - 原始rf数据
%%  Output:
%%     ROI - 提取出来的ROI区域
%%     hmin,hmax - ROI的上下坐标值，直接传递ROI在进行seeds算法的时候由于不是double变量会出错，因此传递ROI的边界坐标值
%%     out - 一个中间过程量，由于调用neighbor函数时所需时间较长，调整参数时不方便，所以将其单独返回
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ROI,hmin,hmax,out] = testostu(I,rawIm)
    %% 数据准备，原始B图，灰度图
    [A B C] = size(I);%先判断是不是灰度图
    if C ~= 1
        G = rgb2gray(I);
        Imsc = G;
    else
        Imsc = I;
        G = I;
    end
    %% ostu自适应阈值二值化
    [counts x] = imhist(Imsc);
    [m n] = size(Imsc);  
    level = otsu(counts, m*n);  
    output =Imsc;  
    output(output<level) = 0;  
    output(output>=level) = 255;  
    [lengthy,lengthx] = size(output);
    figure;
    subplot(121),imagesc(Imsc);colormap(gray);
    axis([0 lengthx 0 lengthy]); 
    subplot(122),imagesc(output);colormap(gray);
    axis([0 lengthx 0 lengthy]); 

    %% 求邻域并将图像转换为黑灰白三色
    output = neighbor( 5,lengthy,lengthx,output);%所需时间长，所需时间与15的大小有关，，此时邻域是31 x 31
    figure;
    imagesc(output);colormap(gray);
    out = output;
    %% 从众多边界中分离出颈动脉远端边界  
    [ROI,hmin,hmax] = findObj( out ,G,rawIm);
    
end

