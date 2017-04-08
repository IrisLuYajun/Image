%==============================================
%%  向左移动扫描线
%% 输入参数：
%%     mark_li       -   第几次左移
%%     mark_left     -   左移坐标点矩阵
%%     nopti,topti   -   最佳种子点
%%     rawIm         -   原始图像
%%     Rtaomax       -   判断是否再移动的参数（seeds函数）
%%     Rt            -   最佳种子点所在扫描线的信号
%% 输出参数：
%%     mark_left     -   返回左移坐标点
%%  ==============================================
function  mark_left = left(mark_li,mark_left,nopti,topti,rawIm,Rtaomax,Rt)
    global seed_n;
    global seed_t;
     left = 1
    nopti = round(nopti);
    topti = round(topti);
    tn = topti;
     %%第三步
    T = 1/6600000;
    Fs = 40000000;
    W = 2*T*Fs;
    n = nopti-1;
    Line = round(n);
    framenum = 1;
    %%第四、五步
    
    P0t =  rawIm(:,Line, framenum);
    P1t = P0t(round(topti-W):round(topti+W));
    %第六步
    rlength = length(Rt);
    plength = length(P1t);
    rmean = mean(Rt);
   
   dr = sqrt(sum((Rt - rmean).^2));
    % dp = sqrt(sum((P1t - pmean).^2));
%     dr = sqrt(sum((Rt).^2));
    
    fc = 6600000;
    pace = 0.1;
    xtao =  -Fs/(2*fc):pace:Fs/(2*fc);
    ycross = zeros(1,length(xtao));
    i = 1;
    for tao = -Fs/(2*fc):pace:Fs/(2*fc)
        Pt =P0t((round(tn-W)+round(tao)):(round(tn+W)+round(tao)));
        rpsum = sum(Rt.*Pt);
         pmean = mean(Pt);
         dp = sqrt(sum((Pt - pmean).^2));
%         dp = sqrt(sum((P1t).^2));
        crossR = rpsum/(dr*dp);
        ycross(1,i) = crossR;
        i = i+1;
    end
%ycross
ycross = ycross;
    
    %rpsum = sum(Rt.*Pt);
    %crossR = rpsum/(dr*dp);
    %第七八步
   
   
    [Rtao0 tao0] = max((ycross));
    taomax =  xtao(tao0);
    if abs(Rtao0) > 0.9
        tn = tn + xtao(tao0);
        Rtn = (Rt*(size(rawIm,2))+Pt)/(size(rawIm,2));
    else
        Rt = Rt;
    end
    %第九、十、十一步
    Rtaoaverage = (abs(Rtaomax)+abs(Rtao0))/2;
    Rtaomax = Rtao0;
    %subplot(221),
    plot(n,tn,'r+');
    mark_left(mark_li,:) = [n,tn];
    if abs(Rtaoaverage) > 0.8
        if Line > 1
        %%继续左移
           mark_li = mark_li+1;
          mark_left = left1(mark_li,mark_left,n,tn,rawIm,Rtaomax,Rt);
        end
    end
   if length(mark_left) == 0
       mark_left = [nopti,topti];
   end
end


