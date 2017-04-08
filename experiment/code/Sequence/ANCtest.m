%==============================================
%%  互相关系数
%% 输入参数：
%%     ROI_Im       -    感兴趣区域
%%     windowMeanPoint_MA     -   合成轮廓的点
%% 输出参数：
%%     point         -   所有windowMeanPoint_MA在49帧最匹配的点
%% ==============================================
function [point] = ANCtest(ROI_Im,windowMeanPoint_MA)
interval_1 = 20;%7 x7
interval_2 = 30;%11 x 11
% ROI_Im =  ROI_Im(:,:,2:end);
framenum = 1;
Im_framenum1 = ROI_Im(:,:,framenum);%前一帧
windowMeanPoint_MA(:,3)=[];
point(:,:,1) = windowMeanPoint_MA;%第一帧的点

for framenum = 2:size(ROI_Im,3)%哪一帧？
    Im_framenum2 = ROI_Im(:,:,framenum);%后一帧
    for index = 1:size(windowMeanPoint_MA,1)   %哪一个点？
         p = windowMeanPoint_MA(index,:);
         x_double = p(:,1);%横坐标，表示哪条扫描线
         y_double = p(:,2);%纵坐标，表示哪个采样点
         x = round(p(:,1));%横坐标
         y = round(p(:,2));%纵坐标
         if ((size(ROI_Im,2)-x) > interval_1)%滑动匹配窗没有超过边界
             window_1 = Im_framenum1((y-interval_1):(y+interval_1),(x-interval_1):(x+interval_1));
             mean_1 = mean(mean(window_1));
             siegema_1 = sqrt(sum(sum((window_1 - mean_1).^2)));
         else                                %超过边界
             zero_w1 = interval_1 - (size(ROI_Im,2)-x);
             zero_domain1 = zeros((interval_1*2+1),zero_w1);
             window_1 = Im_framenum1((y-interval_1):(y+interval_1),(x-interval_1):end);
             window_1 = [window_1,zero_domain1];
             mean_1 = mean(mean(window_1));
             siegema_1 = sqrt(sum(sum((window_1 - mean_1).^2)));
         end
         
         %后一帧
         i = 1;
         space = 0.5;
         for m = (x_double-(interval_2-interval_1)):space:(x_double+(interval_2-interval_1))
             for n = ( y_double-(interval_2-interval_1)):space:( y_double+(interval_2-interval_1))
                m_integer = round(m)
                n_integer = round(n)
                if ((size(ROI_Im,2)-m_integer) >= interval_1)
%                     window_2 = Im_framenum2(round(n-interval_1):round(n+interval_1),round(m-interval_1):round(m+interval_1));
                    window_2 = Im_framenum2((round(n)-interval_1):(round(n)+interval_1),(round(m)-interval_1):(round(m)+interval_1));
                    mean_2 = mean(mean(window_2 ));
                    siegema_2 = sqrt(sum(sum((window_2-mean_2).^2 )));
                else
                    zero_w2 = interval_1 - (size(ROI_Im,2) - m_integer);
                    zero_domain2 = zeros((interval_1*2+1),zero_w2);
                    window_2 = Im_framenum2((round(n)-interval_1):(round(n)+interval_1),(round(m)-interval_1):end);
                    window_2 = [window_2,zero_domain2];
                    mean_2 = mean(mean(window_2 ));
                    siegema_2 = sqrt(sum(sum((window_2-mean_2).^2 )));
                end
                
                window_1 = window_1 - mean_1;
                window_2 = window_2 - mean_2;
                ANC(index,i) = sum(sum((window_1.*window_2)/(siegema_1*siegema_2)));
                i = i + 1
             end
         end
         
    end
    
    %[max_ANC,index_ANC] = max(ANC,[],2);%每行的最大值，max_ANC是最大值，index_ANC是最大值在每行所处的位置
    
%     figure,
    for i = 1:size(ANC,1)
        ANCD = ANC(i,:);
        ANCD = (double(reshape(ANCD,sqrt(size(ANCD,2)),sqrt(size(ANCD,2)))))';
%         ma = (x_double-(interval_2)):space:(x_double+(interval_2));
%         na = ( y_double-(interval_2)):space:( y_double+(interval_2));
%         mesh(ma,na,ANCD);
%         pause(0.05);
         p = windowMeanPoint_MA(i,:);
         x_double = p(:,1);%横坐标，表示哪条扫描线
         y_double = p(:,2);%纵坐标，表示哪个采样点
        close all,
        [xx,yy] = find(ANCD == max(max(ANCD)))%第xx行第yy列
        point(i,1,framenum) = x_double-(interval_2-interval_1)+(xx(1,1)-1)*space;                  
        point(i,2,framenum) = y_double-(interval_2-interval_1)+yy(1,1)*space;
             
     end
    
    %求解m、n迭代了几次
%     clear iter;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
%     for i = 1:length(index_ANC)
% %          iter(i,1) = fix(index_ANC(i,1)/(sqrt(size(ANC,2))));
% %          iter(i,2) = mod(index_ANC(i,1),(sqrt(size(ANC,2))));
%         ANCD = ANC(1,:);
%         ANCD = reshape(ANCD,81,81);
%         ma = (x_double-(interval_2-interval_1)):space:(x_double+(interval_2-interval_1));
%         na = ( y_double-(interval_2-interval_1)):space:( y_double+(interval_2-interval_1));
%         
% 
%     end
%     %将m、n迭代的次数换算成坐标点
%     for index = 1:length(windowMeanPoint_MA)
%          p = windowMeanPoint_MA(index,:);
%          x_double = p(:,1);%横坐标
%          y_double = p(:,2);%纵坐标
%          point(index,1,framenum) = x_double-(interval_2-interval_1)+iter(index,1)*space;
%          if (iter(index,2) == 0)
%              point(index,2,framenum) = y_double+(interval_2-interval_1);
%          else
%             point(index,2,framenum) = y_double-(interval_2-interval_1)+(iter(index,2) - 1)*space;
%          end
%     end
   
    Im_framenum1 = Im_framenum2;%下一次迭代的前一帧
    
 end
 %每个点做作出纵轴方向上位移的曲线(横坐标：帧，纵坐标：像素点)
 test;
 
%  figure,
%  axis on
%  hold on
% for index = 1:size(point,1) %哪一个点？
%     distension_index = point(index,:,:);
%     distension = [];
%      for i = 1:size(ROI_Im,3)            %点在那一帧？
%          distension = [distension;distension_index(:,:,i)];
%      end
%       
%       distension_y = distension(2:end,2)-distension(1,2);%%%%%%%%%%%相对于哪个点？心脏舒张末期那一帧怎么找到，
%       x = 0:(length(distension_y)-1);
%       plot(x,distension_y);
% end
end





