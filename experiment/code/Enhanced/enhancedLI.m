%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LI 的增强(XXXXXXX)
%% Inputs:  
%%      ROI_Imsc               - 感兴趣区域
%%      windowMeanPoint_LI     - LI上的点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  enhancedLI( ROI_Imsc,windowMeanPoint_LI )
for in = 1:length(windowMeanPoint_LI)
     p = windowMeanPoint_LI(in,:);
     x = p(:,1);
     y = p(:,2);
     ROI_Imsc(((round(y)-1):round(y)),round(x)) = 130;%之所以将点周围都设置为边界是因为让结果显示得更明显一些
end
figure;
imagesc(ROI_Imsc);
title('enhanced LI profile');
colormap(gray);

end

