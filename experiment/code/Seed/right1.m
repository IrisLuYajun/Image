%==============================================
%% 向右移动扫描线
%% 输入参数：
%%          右移次数 mark_li
%%          每次右移得到的坐标点矩阵 mark_right
%%          右移初始坐标（nopti,topti）
%%          RF图像rawIm
%%          最大相关系数平均值Rtaomax
%%          参考信号 Rtn,Rt
%% 输出参数：
%%          返回左移、右移坐标点
%==============================================
    function [ mark_right ,mark_left] = right1(mark_ri,mark_right,nopti,topti,rawIm,Rtaomax,Rtn,Rt)
        global seed_n;
        global seed_t;
       
         right1 = 2
         nopti = round(nopti);
         tn = round(topti);
    %%第三步
    
    T = 1/6600000;
    Fs = 40000000;
    W = 2 * T*Fs;
    n = nopti+1;
    Line = round(n);
    framenum = 1;
    %%第四、五步
    P0t =  rawIm(:,Line,framenum);
    P1t = P0t(round(topti-W):round(topti+W));
    %第六步
    rlength = length(Rt);
    plength = length(P1t);
    rmean = mean(Rt);
    pmean = mean(P1t);
    dr = sqrt(sum((Rt - rmean).^2));
    % dp = sqrt(sum((P1t - pmean).^2));
%     dr = sqrt(sum((Rt).^2));
    
    fc = 6600000;
    
    pace = 0.1;
    xtao =  -Fs/(2*fc):pace:Fs/(2*fc);
    ycross = zeros(1,length(xtao));
    i = 1;
    for tao = -Fs/(2*fc):pace:Fs/(2*fc)
        Pt =P0t((round(tn)-round(W)+round(tao)):(round(tn)+round(W)+round(tao)));
        rpsum = sum(Rtn.*Pt);
                pmean = mean(Pt);
         dp = sqrt(sum((Pt - pmean).^2));
%         dp = sqrt(sum((P1t).^2));
        crossR = rpsum/(dr*dp);
        ycross(1,i) = crossR;
        i = i+1;
    end
    ycross = ycross;
    %rpsum = sum(Rtn.*Pt);
    %crossR = rpsum/(dr*dp);
    %第七八步
    [Rtao0 tao0] = max((ycross));
    taomax =  xtao(tao0);
    if abs(Rtao0) > 0.9
        tn = tn + taomax;
        Rtn = (Rt*(size(rawIm,2))+Pt)/(size(rawIm,2));
    else
        Rtn = Rt;
    end
    %第九、十、十一步
    Rtaoaverage = (abs(Rtaomax)+abs(Rtao0))/2;
    Rtaomax = Rtaoaverage;
    %subplot(221),
    plot(n,tn,'r+');
    mark_right(mark_ri,:) = [n,tn];
    mark_left = [];
    if abs(Rtaoaverage) < 0.8
        if Line > 1
            Rtao0 = Rtao0
           Rtaoaverage = Rtaoaverage
           
           mark_left = [];
           mark_li = 1;
           %%相反方向重复算法
          mark_left = left(mark_li,mark_left,seed_n,seed_t,rawIm,0.8,Rt);
          
        end
    else
        %%继续右移
        n;
        tn ;
        if Line < size(rawIm,2)
           mark_ri = mark_ri + 1 ;
          [ mark_right ,mark_left] = right(mark_ri,mark_right,n,tn,rawIm,Rtaomax,Rtn,Rt);
        else
        end
    end
    if length(mark_left) == 0
       mark_left = [nopti,topti];
   end
  
    end

