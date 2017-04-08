clear all;
close all;
clc


figure;
[Im,header] = RPread('p3.rf');
%% 显示rf原始图像
if(size(Im,2) > 256)
    Im = Im(:,2:2:end,:);%取偶数的扫描线
end
for framenum = 1 : 37%
    RPviewrfs(Im, header, framenum);%得到rf原始图像
end
for framenum = 38 : size(Im, 3)%37%
    RPviewrfs(Im, header, framenum);%得到rf原始图像
end
%% 
%Im = Im(:,2:2:end,:);
%% 第一帧 RF信号
framenum = 1;
Im_1 = Im(:,:,framenum);
close all;
RPviewrfs(Im, header, 1);
figure;
rf1 = Im_1(:,1);
rf2 = Im_1(:,round(size(Im_1,2)*0.5));
rf3 = Im_1(:,round(size(Im_1,2)*0.7));
rf4 = Im_1(:,round(size(Im_1,2)*1));
subplot(221),plot(rf1);
subplot(222),plot(rf2);
subplot(223),plot(rf3);
subplot(224),plot(rf4);
% j = 1;
% space = 20;
% rf22 = zeros(1,(length(rf2)/space));
% for i = 1:space:(length(rf2)-space)
%     rf22(1,j) = mean(rf2(i:(i+space)));
%     j = j+1;
% end
% figure,plot(rf22);
% extrMaxIndex = find(diff(sign(diff(rf22)))==-2)+1;
%% 四号扫描线的包络信号
enve_rf4 = abs(hilbert(rf4));
figure;
plot(enve_rf4);
%% 显示rf原始图像
framenum = 1;
RPviewrf(Im, header,framenum);%得到rf原始图像
%% 得到ROI-RF图像
[ROI_rf,hmin,hmax,out] = getrfimage(Im_1, header, framenum);
% 或者：
% load('hmax.mat');
% load('hmin.mat');
ROI_Im_1 = Im_1(hmin:hmax,:);
ROI_Imsc = RF2Bmode(ROI_Im_1, framenum);%解调与对数压缩
%ROI_Imsc = sqrt(abs(hilbert(ROI_Im_1)));%(:,:,framenum)
%figure;
%imagesc(ROI_Imsc);
%title('ROI in RF image');
%colormap(gray);

%% 种子点，分割，返回分割结果点集
LIMA = 0;
[ markPointRight_LI ,markPointLeft_LI,initalSeeds_LI,iter_LI] = seeds(LIMA,Im_1, hmin,hmax,header, 1);%先分割LI
% LIMA = 1;
% [ markPointRight_MA ,markPointLeft_MA,initalSeeds_MA,iter_MA] = seeds(LIMA,Im_1, hmin,hmax,header, 1);%再分割MA
%% 轮廓合成
 LIMA = 0;
 markPoint_LI = [markPointRight_LI ;markPointLeft_LI];%两个矩阵的合成
 markPoint_LI = unique(markPoint_LI,'rows');%删除矩阵中相同的行（unique函数还将矩阵按照第一列排序）
 windowMeanPoint_LI = coherentPro(LIMA,markPoint_LI,ROI_Imsc,initalSeeds_LI,iter_LI);%轮廓的合成
%  LIMA = 1;
%  markPoint_MA = [markPointRight_MA ;markPointLeft_MA];
%  markPoint_MA = unique(markPoint_MA,'rows');
%  markPoint_MA = sortrows(markPoint_MA,1);
%  windowMeanPoint_MA = coherentPro(LIMA,markPoint_MA,ROI_Imsc,initalSeeds_MA,iter_MA);
 %% %将LI与MA在同一幅图上显示出来
% showLIMA (ROI_Im_1,windowMeanPoint_LI, windowMeanPoint_MA);
%%  LI增强
enhanced_ROI = delaysum( ROI_Im_1,windowMeanPoint_LI );
IMAGE_1 = Im_1(1:(hmin-1),:);%在完整的原始图像上显示增强后的LI效果
IMAGE_2 = Im_1((hmax+1):end,:);
IMAGE = [IMAGE_1;enhanced_ROI;IMAGE_2];
RF2Bmode(IMAGE, 1);
title('Enhanced LI');
%% 后续帧
 ROI_Im = Im(hmin:hmax,:,:);
 [point] = ANCtest(ROI_Im,windowMeanPoint_LI);





























