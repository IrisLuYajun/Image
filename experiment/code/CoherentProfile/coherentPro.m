%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 轮廓的合成
%% 
%% Inputs:  
%%     markPoint         -   所有种子点生成的边界点
%%     ROI_Imsc          -   ROI区域，用于作图
%%     LIMA              -   标志位，用于检查输入的是LI还是MA 
%%     initalSeeds_LI    -   初始种子点的坐标，在轮廓合成的时候用来删除那些距离边界远的坏种子点
%%     iter_LI           -   种子点的迭代次数
%% Outputs:  
%%     windowMeanPoint   -   轮廓合成后的边界点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function windowMeanPoint = coherentPro(LIMA,markPoint,ROI_Imsc,initalSeeds_LI,iter_LI)
c = 340;s = .001;Fs = 40000000;
 if LIMA == 0
       interval =s*Fs/(10*c);%参数interval与最佳种子点的搜寻范围有关，设置越大，最佳种子点与手工设置的初始种子点关系越弱，如果要搜寻MA则可将该参数设置得大一些例如设置成2*s*Fs/c
    else if LIMA == 1
       interval = s*Fs/(5*c);   
        end
 end
iterThreshold = 5;
iterLessThan10 = find(iter_LI < iterThreshold);%迭代次数小于5次
if size(iterLessThan10,1) > 1
    for i = 1:size(iterLessThan10,1)
        deleteIndex = find(markPoint(:,3) == iterLessThan10(i,:));
        markPoint(deleteIndex',:,:) = [];
    end
end

seedsPoint_y = initalSeeds_LI(:,2);%初始种子点远离目标边界 
seedsPointMean_y = mean(seedsPoint_y);
seedsPointDiff = seedsPoint_y - seedsPointMean_y;
seedsPointSiegema = std(seedsPoint_y);
deleteIndex = [];
farFromObject = find((seedsPointDiff > seedsPointSiegema) | (seedsPointDiff < -(seedsPointSiegema)));
if size(farFromObject,1) > 1
    for i = 1:size(farFromObject,1)
        deleteIndex = find(markPoint(:,3) == farFromObject(i,:));
        markPoint(deleteIndex',:,:) = [];%剔除纵轴方向上偏差大的点
    end
end

 

windowMeanPoint = [];
for in = 1:length(markPoint)
     p = markPoint(in,:);
     x = p(:,1);
     y = p(:,2);
     
     windowPoint_index = find((markPoint(:,1)>=(x-interval)) & (markPoint(:,1)<=(x+interval)) &(markPoint(:,2)>=(y-interval)) & (markPoint(:,2)<=(y+interval)));
     %滑动窗的尺寸与最终合成轮廓的密度有关系，尺寸过小不能去掉一些距离相近的点，特别是纵轴方向容易产生一条扫描线有多个边界点的情况
     
     windowPoint = markPoint(windowPoint_index,:);
     [r,c] = size(windowPoint);
     if r == 1
         windowMeanPoint = [windowMeanPoint;windowPoint];
     else
         windowMeanPoint = [windowMeanPoint;mean(windowPoint)];
     end 
     
 end
windowMeanPoint = unique(windowMeanPoint,'rows');




figure;
image(ROI_Imsc);
if LIMA == 0
       title('coherent LI profile');
    else if LIMA == 1
       title('coherent MA profile'); 
        end
end

colormap(gray(256));
axis on
hold on
for in = 1:(size(windowMeanPoint,1)-1)
     p1 = windowMeanPoint(in,:);
     p2 = windowMeanPoint((in+1),:);
     x = p1(:,1);
     y = p1(:,2);
     if LIMA == 0
        plot([p1(1,1),p2(1,1)],[p1(1,2),p2(1,2)],'r.');
%         plot(x,y,'y-');
        else if LIMA == 1
              plot([p1(1,1),p2(1,1)],[p1(1,2),p2(1,2)],'r.');                  
%              plot(x,y,'r-');  
        end
     end
      
end
end
