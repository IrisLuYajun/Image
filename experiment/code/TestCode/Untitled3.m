% figure;
%  [Im,header] = RPread('avib8.b8');%avirf.rf报错：out of memory
%  for i = 1: size(Im, 3)
%        
%     image(Im(:,:,i));
%     colormap(gray(256));
%     axis('image');
%     
%     drawnow;
%     title(i);
%     
%     pause(0.05);
%  end
% % figure;
% %rf = Im(:,1);
% %plot(rf);
% RPviewrf(Im, header, 1);
% 
% 
% 
% 
% function [output,n] = getMinIntensity(aver,length)
%     [lengthx,lengthy] = size(aver);
%     aver1 = aver';%转置的目的是按行
%     b1 = reshape(aver1,1,[]);%矩阵变为行向量，按列
%     c1 = find(b1>0,length*2);%找出b1中的前length*2的正数，索引值
%     c2 = b1(c1);%实际值
%     c3 = sort(c2,'ascend');%升序，以获得最小值
%    % c4 = find(c3>min(c3),length);
%     %c5 = c3(c4);
%     b2 = find(b1>min(c3),length);%索引值
%     b3 = b1(b2);%实际值
%     b4 = sort(b3,'ascend');%升序
%     c = b2;
%     m = zeros(1,length);
%     n = zeros(1,length);
%     for x =1:lengthx %将图像变为全黑
%             for y = 1: lengthy
%                 output(x,y) =  0;
%             end
%     end
%     
%     for i = 1:length
%         if rem(c(i),lengthy) == 0
%             n(i) = floor(c(i)/lengthy);
%             m(i) = lengthy;
%         else
%             if (c(i)/lengthy) <  lengthx
%                 n(i) = floor(c(i)/lengthy+1);%取整，行数
%                 m(i) = rem(c(i),lengthy);%取余数，列数
%             else
%                 n(i) = floor(c(i)/lengthy);%取整，行数
%                 m(i) = rem(c(i),lengthy);%取余数，列数
%             end
%         end
%         output(n(i),m(i)) = 255;%灰度值设为255
%     end
%     
%    
% 
% end





figure,
 axis on
 hold on
for index = 1:size(windowMeanPoint_MA,1) 
    distension_index = point(index,:,:);
    distension = [];
     for i = 1:size(ROI_Im,3)
         distension = [distension;distension_index(:,:,i)];
     end
      
      distension_y = distension(2:end,2)-distension(2,2);%%%%%%%%%%%相对于哪个点？心脏舒张末期那一帧怎么找到
      x = 1:(length(distension)-0);
      plot(x,distension(:,2));
end