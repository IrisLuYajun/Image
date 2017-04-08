%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 将LI与MA在同一幅图上显示出来
%% Inputs:  
%%      ROI_Imsc                -   感兴趣区域
%%      windowMeanPoint_LI      -   LI上的点
%%      windowMeanPoint_MA      —  MA上的点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showLIMA (ROI_Im_1,windowMeanPoint_LI, windowMeanPoint_MA)
ROI_Imsc = RF2Bmode(ROI_Im_1, 1);%解调与对数压缩
%figure;
%ROI_Imsc = sqrt(abs(hilbert(ROI_Im_1)));
%imagesc(ROI_Imsc);
title('coherent profile');
colormap(gray);
axis on
hold on
if size(windowMeanPoint_MA,1) ~=0
    windowMeanPoint_MA = sortrows(windowMeanPoint_MA,1);
end
windowMeanPoint_LI = sortrows(windowMeanPoint_LI,1);
for in = 1:(size(windowMeanPoint_LI,1) -1)
     p1 = windowMeanPoint_LI(in,:);%点练成线的方法
     p2 = windowMeanPoint_LI((in+1),:);
     plot([p1(1,1),p2(1,1)],[p1(1,2),p2(1,2)],'y');
%      x = p1(:,1);% 画点方法
%      y = p1(:,2);
%     plot(x,y,'y--');
end
for in = 1:(size(windowMeanPoint_MA,1) - 1)
     p1 = windowMeanPoint_MA(in,:);
     p2 = windowMeanPoint_MA((in+1),:);
     plot([p1(1,1),p2(1,1)],[p1(1,2),p2(1,2)],'r');
%      x = p1(:,1);
%      y = p1(:,2);
%     plot(x,y,'r--');
end


end

