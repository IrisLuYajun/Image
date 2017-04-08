%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 总程序
%% 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 clc;
  clear all;
  close all;
 
 %% 数据准备，原始B图，灰度图
%  I = imread('carotid.png');
%  G = rgb2gray(I);
%  figure;
%  subplot(121),imshow(I);
%  subplot(122),imshow(G);
 %% 读取RF数据
 figure;

 [Im,header] = RPread('22-55-09.rf');
%  Im = Im(:,2:2:end,:);
 for i = 1: size(Im, 3)
       
%     image(Im(:,:,i));
%     colormap(gray(256));
%     axis off;
    %axis([0 256 0 2080]);
    
    
    Imin = abs(hilbert(Im(:,:,i)));
    A = 35;
    M = 30;
    Imout = (20*log10(Imin/max(Imin(:))) + A)/ M * 255;
    image(Imout);
    rfimtitle = sprintf('RF Raw Image %d',i);
    title(rfimtitle);
    colormap(gray(256));
    
    
    drawnow;
    title(i);
    
    pause(0.05);
 end
 %% 显示扫描线1,2,3,4
 figure;
rf1 = Im(:,50);
rf2 = Im(:,100);
rf3 = Im(:,150);
rf4 = Im(:,200);
subplot(221),plot(rf1);
subplot(222),plot(rf2);
subplot(223),plot(rf3);
subplot(224),plot(rf4);
%% 四号扫描线的包络信号
enve_rf4 = abs(hilbert(rf4));
figure;
plot(enve_rf4);

%% 显示rf原始图像
framenum = 1;
RPviewrf(Im, header,framenum);%得到rf原始图像

%% 得到ROI-RF图像
[ROI_rf,hmin,hmax,out] = getrfimage(Im, header, framenum);
ROI_Im = Im(hmin:hmax,:);
ROI_Imsc = sqrt(abs(hilbert(ROI_Im(:,:,framenum))));
figure;
imagesc(ROI_Imsc);
title('ROI in RF image');
colormap(gray);
%% 滤波？

%% 种子点，分割，返回分割结果点集
LIMA = 0;
[ markPointRight_LI ,markPointLeft_LI] = seeds(LIMA,Im, hmin,hmax,header, 1);%先分割LI
LIMA = 1;
[ markPointRight_MA ,markPointLeft_MA] = seeds(LIMA,Im, hmin,hmax,header, 1);%再分割MA
%% 轮廓合成
 LIMA = 0;
 markPoint_LI = [markPointRight_LI ;markPointLeft_LI];%两个矩阵的合成
 markPoint_LI = unique(markPoint_LI,'rows');%删除矩阵中相同的行（unique函数还将矩阵按照第一列排序）
 windowMeanPoint_LI = coherentPro(LIMA,markPoint_LI,ROI_Imsc);%轮廓的合成
 LIMA = 1;
 markPoint_MA = [markPointRight_MA ;markPointLeft_MA];
 markPoint_MA = unique(markPoint_MA,'rows');
 windowMeanPoint_MA = coherentPro(LIMA,markPoint_MA,ROI_Imsc);
 %% %将LI与MA在同一幅图上显示出来
showLIMA (ROI_Imsc,windowMeanPoint_LI, windowMeanPoint_MA);
%%  LI增强
enhancedLI( ROI_Imsc,windowMeanPoint_LI );
%% 下一帧 NC



