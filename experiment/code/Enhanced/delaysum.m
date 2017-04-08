
function  enhanced_ROI = delaysum( ROI_Im_1,windowMeanPoint_LI )
ROI_Im_2 = ROI_Im_1;
%%  相同扫描线（横坐标），做处理：纵坐标取平均
windowMeanPoint_LI = [round(windowMeanPoint_LI(:,1)),windowMeanPoint_LI(:,2)];%扫描线（横坐标）取整
d = [];
for i = 1:size(windowMeanPoint_LI,1)
    p = windowMeanPoint_LI(i,1);
    for j = (i+1):size(windowMeanPoint_LI,1)
        t = windowMeanPoint_LI(j,1);
        if(p == t)
            windowMeanPoint_LI(i,2) = (windowMeanPoint_LI(i,2) + windowMeanPoint_LI(j,2))/2;
            d = [d,j];
        end
    end

end
windowMeanPoint_LI(d,:) = [];%%显示
windowMeanPoint_MA = [];
showLIMA (ROI_Im_1,windowMeanPoint_LI, windowMeanPoint_MA);
title('LI')

%% 对windownMeanPoint_MA插值,有些扫描线有缺失的情况
 x0 = windowMeanPoint_LI(:,1); 
 y0 = windowMeanPoint_LI(:,2);
 d = 1;
 x = (min(windowMeanPoint_LI(:,1))-d):d:(max(windowMeanPoint_LI(:,1))+d);
 y = interp1(x0,y0,x,'spline');
 figure,
 subplot(211),plot(x0,y0,'r.'),title('original ');
 subplot(212),plot(x0,y0,'r.'),title('spline');
 hold on;
 subplot(212),plot(x,y,'b*',x,y);
 windowMeanPoint_LI = [x',y'];
 %%  对图像进行二维插值
x=1:256;
y=(1:size(ROI_Im_1,1))';
x0=0.5:(size(ROI_Im_1,2)+0.5);
y0=y;
ROI_Im_interp=interp2(x,y,ROI_Im_1,x0,y0,'spline');

ROI_Im_Com = zeros(size(ROI_Im_1,1),(size(ROI_Im_1,2)+size(ROI_Im_interp,2)));%将插值结果与原始结果合并
ROI_Im_Com(:,1:2:end)=ROI_Im_interp;
ROI_Im_Com(:,2:2:end)=ROI_Im_1;
%% 对扫描线插值，并进行延时求和
% ROI_Im_1 = Im_1(hmin:hmax,:);
x0 = 0:(size(ROI_Im_1,1)-1);
region = 3;
figure,
for i = (region+1):1:(size(windowMeanPoint_LI,1)-region)%i表示哪个点
    scanline_del = [];
    for j = (-region):(+region)
        %timedelay = windowMeanPoint_LI(i + j,2) - windowMeanPoint_LI(i,2);
        x = windowMeanPoint_LI(i + j,2);%x = x0 - timedelay;
        scanline_pre = ROI_Im_Com(:,windowMeanPoint_LI(i + j,1)*2);
        scanline_del = [scanline_del,(interp1(x0,scanline_pre',x,'spline'))'];
    end
    scanline_sum = sum(scanline_del);%按行相加
    
    %扫描线信号插值，画图用！！！！
%      figure,
%      ax = 1:size(scanline_pre,1);
%      plot(ax,scanline_pre,'r.',ax,scanline_pre);
%      hold on;
%      plot(x,interp1(x0,scanline_pre',x,'spline'),'b*');
    
%     
%     x0 = windowMeanPoint_MA(:,2); 
%     y0 = windowMeanPoint_MA(:,1);
%     x = windowMeanPoint_MA(i,2);
%     y = interp1(x0,y0,x,'spline');
%     windowMeanPoint_MA(i,1) = y;
    ROI_Im_1(round(windowMeanPoint_LI(i,2)),windowMeanPoint_LI(i,1)) = scanline_sum;%%%%%%%%%%%取整？？？？？？？？？
    
%     figure,
    ax = 1:size(scanline_pre,1);
    plot(ax,scanline_pre);
    hold on;
    scanline_pre(round(windowMeanPoint_LI(i,2))) =  scanline_sum;
     plot(ax,scanline_pre,'r.');
end
enhanced_ROI = ROI_Im_1;
ROI_Imsc = RF2Bmode(ROI_Im_1, 1);%解调与对数压缩，显示增强后的LI
%ROI_Imsc = sqrt(abs(hilbert(ROI_Im_1)));
%figure;
%imagesc(ROI_Imsc);
title('enhanced image');
%colormap(gray);
% image(ROI_Im_1)
% x0 = 0:621;
% y0 = scanline;
% x = x0 - 1.1102;%timedelay;
% y1 = interp1(x0,y0,x,'linear');
% y2 = interp1(x0,y0,x,'spline');
% y3 = interp1(x0,y0,x,'nearst');
% y4 = interp1(x0,y0,x,'cubic');
% subplot(221),plot(x0,y0,'r',x,y4);
% subplot(222),plot(x0,y0,'r',x,y1);
% subplot(223),plot(x0,y0,'r',x,y2);
% subplot(224),plot(x0,y0,'r',x,y3);
end