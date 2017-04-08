%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI区域自动检测算法之一：得到原始rf图像并进行后续ROI提取
%% 
%% Inputs:  
%%     rawIm - rf原始数据
%%     header - 文件头
%%     framenum - 帧数
%%  Output:
%%     ROI——rf - 提取出来的ROI区域(uint8型)
%%     hmin,hmax - ROI的上下坐标值，直接传递ROI在进行seeds算法的时候由于不是double变量会出错，因此传递ROI的边界坐标值
%%     out - 一个中间过程量，由于调用neighbor函数时所需时间较长，调整参数时不方便，所以将其单独返回
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function  [ROI_rf,hmin,hmax,out] = getrfimage(rawIm, header, framenum)

    %Imsc = sqrt(abs(hilbert(rawIm(:,:,framenum))));
    Imsc = RF2Bmode(rawIm, framenum);%解调与对数压缩
    %figure;
    %imagesc(Imsc);
    %rfimtitle = sprintf('RF Raw Image %d',framenum);
    %title(rfimtitle);
    %colormap(gray);
    I = uint8(Imsc); %将double型的Imsc转化为uint8型的I，因为求直方图时要对uint8型的数据计算
    %G = rgb2gray(I);
    %Imsc = rgb2gray(I);
    %G = I;
    %Imsc = I;
    [lengthx lengthy] = size(rawIm);
    %%   ROI自动检测
    [ROI_rf,hmin,hmax,out] = testostu(I,rawIm);
    %%   在原始rf图像上画出ROI所在区域
    figure;
    image(Imsc);
    %imagesc(Imsc);
    rfimtitle = sprintf('RF Raw Image %d',framenum);
    title(rfimtitle);
    colormap(gray(256));
    hold on;
    rectangle('position',[1,hmin,lengthy,(hmax-hmin)],'curvature',[0,0],'edgecolor','r');%rectangle('Position',[x,y,w,h]) 从点x,y 开始绘制一个矩形，宽度为w 长度为 h.
end



