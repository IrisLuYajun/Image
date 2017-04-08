
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ROI算法之求像素点的灰度值是否等于某个值
%% Inputs:  
%%      i  - 输入值
%%      j  - 输入值
%%    
%% Outputs:  
%%      d - 若i,j相等，d等于1，否则返回0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = ROIfb( i,j )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if i == j
        d = 1;
    else
        d = 0;
    end

end

