%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI算法之求每个亮度为255的点上下domain采样点RF数值的平均
%% Inputs:  
%%      output           — 上次处理得到的黑白边界点集图像
%%      rawIm            -  RF原始数据矩阵
%%      domain           -  计算平均的范围
%% Outputs:  
%%      output           -  输出
%%      x                -  亮度为255的纵坐标点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output,x] = findObjByRF(output,rawIm,domain)
    [lengthy,lengthx] = size(output);
    RFmeanMatrix = zeros(lengthy,lengthx);
    %domain = 15;
    counter = 0;
    for x =1:lengthx
            for y = 1: lengthy
                if  output(y,x) == 255
                    if( (y <= domain)) 
                        scanLine = rawIm(y:(y+domain),x);
                     
                    else if y >= (lengthy - domain)
                        scanLine = rawIm((y-domain):y,x);    
                        
                        else
                            scanLine = rawIm((y-domain):(y+domain),x);
                         end
                    end
                    
                    extrMaxIndex = find(diff(sign(diff(scanLine)))==-2)+1;%极大值
                    RFmaxMean = mean(scanLine(extrMaxIndex));%极大值平均
                    extrMinIndex = find(diff(sign(diff(scanLine)))== 2)+1;%极小值
                    RFminMean = mean(scanLine(extrMinIndex));%极小值平均
                    RFmean =  RFmaxMean - RFminMean;%极大值减去极小值
                    %RFmean =  RFmaxMean;
                    RFmeanMatrix(y,x) = RFmean;
                    counter = counter + 1;
                end
           
           end
    end
     for i =1:lengthx %将图像变为全黑
            for j = 1: lengthy
                output(j,i) =  0;
            end
     end
    value_1D = reshape(RFmeanMatrix,1,lengthx*lengthy);
    value_sort = sort(value_1D,'descend');
    value_turn = value_sort(2000);
    [x,y] = find(RFmeanMatrix >= value_turn);
     for i = 1:length(x)
        output( x(i),y(i)) = 255;%灰度值设为255
    end
    figure;
    imagesc(output);colormap(gray);
    axis([0 lengthx 0 lengthy]); 
end