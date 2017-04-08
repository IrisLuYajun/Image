%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI区域自动检测算法之求强度平均值矩阵的升序
%% Inputs:  
%%     aver - 强度平均值矩阵
%%     length - 需要显示的升序矩阵前length个像素点
%%  Output:
%%     output - 输出二值图像，颈动脉边界为白色，其余像素为黑色
%%     n      - 目标像素点的纵坐标矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [output,n] = getMinIntensity(aver,length)
    [lengthx,lengthy] = size(aver);
    for x =1:lengthx %将图像变为全黑
            for y = 1: lengthy
                output(x,y) =  0;
            end
    end
    
    [index_x,index_y] = find(aver ~= 0 & aver ~= -1);%找出b1中的前length*2的正数，索引值
    value = [];
    for i = 1:size(index_x,1)
        value(i) = aver(index_x(i),index_y(i));%实际值
    end
     value_sort = sort(value,'ascend');
     value_turn = value_sort(length);
     value_index = find(value < value_turn);
    x = [];
    y = [];
    for i = 1:size(value_index,2)
        x(i) = index_x(value_index(i));
        y(i) = index_y(value_index(i));
        output( x(i),y(i)) = 255;%灰度值设为255
    end
    n = x;
    
    
%     value_sort = sort(value,'ascend');%升序，以获得最小值
%     value_sort = value_sort(1:length);
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
 
    
   

end

