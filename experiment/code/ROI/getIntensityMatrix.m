%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI区域自动检测算法之求组织边界之上长度为length_aver的像素点强度值平均的矩阵
%% Inputs:  
%%     length_aver - 求平均的像素点的长度
%%     output - 黑白二值图像
%%     G - 原始图像
%%  Output:
%%     aver - 平均强度值矩阵
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function aver = getIntensityMatrix( length_aver,output,G,rawIm)
framenum = 1;
Imout = RF2Bmode(rawIm, framenum);%解调与对数压缩
sum50 = 0; 
[lengthy,lengthx] = size(output);
aver = zeros(lengthy,lengthx);
for x =1:lengthx
        for y = (length_aver+1): lengthy
           if output(y,x) == 255%只遍历白色像素点，其它点的返回值值为-1
               sum50 = sum(Imout((y-length_aver):y,x));
               aver(y,x) = sum50/length_aver;
           else
               aver(y,x) = -1;
           end         
            sum50 = 0; 
           
        end
end

end


