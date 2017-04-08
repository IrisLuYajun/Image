%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI算法之求中心像素点的n x n 邻域,统计该邻域内灰度值为255与0的像素点个数，
%% 并作出该中心像素点是100灰度值或者0灰度值
%% Inputs:  
%%      n                - n x n邻域
%%      lengthx,lengthy  - 原图像尺寸
%%      output           — 原图像
%% Outputs:  
%%      output - 处理结束后的图像，黑白灰三色
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function output = neighbor( n ,lengthy,lengthx,output)
b1 = 0;
b2 = 0;
for x =(n+1):(lengthx-n)
        for y = (n+1): (lengthy-n)
            output(y,x);%中心像素点
            for i = (x-n):(x+n)
                for j = (y-n):(y+n)
                    b1 = b1 + ROIfb(output(j,i),255);
                    b2 = b2 + ROIfb(output(j,i),0);
                end
            end
            if (b1 - b2)>12%为了使得边缘点灰度值为255，给其设定一个范围
                output(y,x) = 100;
             end
            if (b1 - b2)<-22
                output(y,x) = 0;           
            end
            b1 =0;
            b2 = 0;
        end
       end
end


