%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 选取初始种子点，并求得最佳种子点
%% Inputs: 
%%     LIMA     -  标志位，用于检查输入的是LI还是MA
%%     rawIm    -   The data to view
%%     hmin,hmax -  感兴趣区域的上下边界值
%%     header   -   The file header
%%     framenum - The frame number to show
%% outputs:
%%     markPointRight   - 最终左移的坐标点
%%     markPointLeft    - 最终右移的坐标点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [markPointRight ,markPointLeft,initalSeeds,iter] = seeds(LIMA,rawIm, hmin,hmax,header, framenum)
global seed_n;
global seed_t;
markPointLeft = [];
markPointRight = [];
%%首先获得原始图像
clc
rawIm = rawIm(hmin:hmax,:);
Im = RF2Bmode(rawIm, framenum);%解调与对数压缩
%Im = sqrt(abs(hilbert(rawIm(:,:,framenum))));
%Im = rawIm;
c = 340;s = .001;Fs = 40000000;
if LIMA == 0
   interval = s*Fs/(20*c);%参数interval与最佳种子点的搜寻范围有关，设置越大，最佳种子点与手工设置的初始种子点关系越弱，如果要搜寻MA则可将该参数设置得大一些例如设置成2*s*Fs/c
   rfimtitle = sprintf('select LI initial points in RF Raw Image');
else if LIMA == 1
   interval = s*Fs/(15*c);
   rfimtitle = sprintf('select MA initial points in RF Raw Image');
    end
end
figure, 
%subplot(2,2,1);
image(Im);
title(rfimtitle);
colormap(gray(256));
[n,tn] = ginput(); %先测试一次
k=size(n);
axis on
hold on
initalSeeds = [];%保存的是初始种子点的坐标
iter = [];%保存每个种子点的迭代次数
 for i=1:k
    plot(n(i),tn(i),'r*');
    %text(n(i),tn(i),sprintf('(%d,%d)',round(n(i)),round(tn(i))),'color','red')
     Line = round(n(i)); 
      if(header.filetype == 16)
        if(n(i)<1 || n(i)>header.w)
            return;
        end    
    else
         if(n(i)<1 || n(i)>header.h)
            return;
        end
      end
      
    Snt = rawIm(:,Line,framenum);
    
    %subplot(2,2,2);
    %plot(Snt, 'b'); 
    %axis([0 541 min(Snt) max(Snt)]); 
    %rftitle = sprintf('RF Line: %d', Line);
    %title(rftitle); 
    %axis off
 %%获得初始种子点[x(i),y(i)]所在RF扫射线的信号S后，截取初始种子店附近的信号S0
    
    tn(i);
    S0nt = Snt(round(tn(i)-interval):round(tn(i)+interval));
    length(S0nt);
    min(S0nt);
    max(S0nt);
    %subplot(2,2,3);
    %plot(S0nt,'b');    
    %axis([0 length(S0nt) min(S0nt) max(S0nt)]); 
    %xlim([0,length(S0)]);
    %ylim([min(S0),max(S0)]);
    %rftitle = 'section signal around the seed';
    %title(rftitle); 
    %%求S0的包络及其最大值
    S0envelop = hilbert(S0nt);
[S0envelopmax tnop] = max(S0envelop);%最大值点tn
%subplot(224),plot(abs(S0envelop));
%length(S0envelop);
%max(S0envelop);
%min(S0envelop);
%axis([0 length(S0envelop) min(S0envelop) max(S0envelop)]);
%length(S0envelop)
%max(S0envelop)
%min(S0envelop)
%%在RF图像上显示出最佳种子点
nopti = n(i);%最佳种子点
topti = tnop-1+round(tn(i)-interval);
seed_n = nopti;
seed_t = topti;
%subplot(221)
plot(n(i),topti,'ro');%由于是通过S截取的部分S0信号，因此需要将坐标值对应起来
initalSeeds = [initalSeeds;n(i),topti];%将每个种子点的坐标保存下来并返回
%text(n(i),tnop+round(tn(i)-interval),sprintf('(%d,%d)',round(n(i)),tnop+round(tn(i)-interval)),'color','red');
tnop = topti;

%%第三步
tn(i) = tnop;
T = 1/6600000;
W = 2*T*Fs;%约为6
Rt = Snt(round(tn(i)-W):round(tn(i)+W));
%%第四、五步
n(i) = round(n(i))+1;
Line = round(n(i));
tn(i) = tn(i)
P0t = rawIm(:,Line,framenum);
P1t =P0t(round(tn(i)-W):round(tn(i)+W));
fc = 6600000;
%第六步
rlength = length(Rt);
plength = length(P1t);
rmean = mean(Rt);

dr = sqrt(sum((Rt - rmean).^2));
% dp = sqrt(sum((P1t - pmean).^2));
% dr = sqrt(sum((Rt).^2));
% dp = sqrt(sum((P1t).^2));

%tao = -Fs/(2*fc):0.2:Fs/(2*fc);
%Pt =P0t(round(tn-W+tao):round(tn+W+tao))

%tao = Fs/(2*fc);
pace = 0.1;
xtao =  (-Fs/(fc)):pace:(Fs/(fc));
ycross = zeros(1,length(xtao));
j = 1;
for tao = -Fs/(fc):pace:Fs/(fc)
        Pt =P0t((round(tn(i))-round(W)+round(tao)):(round(tn(i))+round(W)+round(tao)));
        length(Rt)
        length(Pt)
        pmean = mean(Pt);
%         dp = sqrt(sum((P1t).^2));
         dp = sqrt(sum((Pt - pmean).^2));
        rpsum = sum(Rt.*Pt);
        crossR = rpsum/(dr*dp);
        ycross(1,j) = crossR;
        j = j+1;
end
ycross;
ycross = ycross;
%rpsum = sum(Rt.*Pt);
%crossR = rpsum/(dr*dp)%%%%%%%%%%%%%%%%%%%%%%%%%%%%不是矩阵
%第七八步
Rtaomax = 0.8;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
firstright = 1
% [Rtao0 tao0] = max(abs(ycross))%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Rtao0 tao0] = max(ycross);
taomax =  xtao(tao0)
if abs(Rtao0) > 0.9
    tn(i)
    tn(i) = tn(i) + xtao(tao0);
    tn(i)
    Rtn = (Rt*(size(Im,2))+Pt)/(size(Im,2));
else
     Rtn = Rt;
end
%第九、十、十一步
Rtaoaverage = (abs(Rtaomax)+abs(Rtao0))/2
Rtaomax = Rtaoaverage;
%subplot(221),
plot(n(i),tn(i),'r+');
 mark_left = [];
 mark_right = [];
if abs(Rtaoaverage) < 0.8
   
    mark_li = 1;
    mark_left(mark_li,:) = [n(i),tn(i)];
    mark_li = mark_li + 1;
    %%相反方向重复算法
   mark_left = left(mark_li,mark_left,seed_n,seed_t,rawIm,0.8,Rt);
else
    %%继续右移
    n(i)
    tn(i)
    if n(i) < 511
       
        mark_ri = 1;
        mark_right(mark_ri,:) = [n(i),tn(i)];
        mark_ri = mark_ri + 1;
        markpoint_right = mark_right;
        [ mark_right ,mark_left] = right(mark_ri,mark_right,n(i),tn(i),rawIm,Rtaomax,Rtn,Rt);
    else
    end
end
%% 求每个种子点迭代次数
%length_left = [];
%length_left = [length_left;length(markPointLeft)];
%length_right = [];
%length_right = [length_right;length(markPointRight)];
%iteration = length_left + length_right;
%% 将每一个最佳初始点得到的边界点保存
mark_left = [mark_left ones(size(mark_left,1),1)*i];%坐标点为（x,y,flag），flag位是标志位，表示是由哪一个种子点生成的
mark_right = [mark_right ones(size(mark_right,1),1)*i];
markPointLeft = [markPointLeft;mark_left];
markPointRight = [markPointRight;mark_right];
%% 每个种子点迭代次数 
mark_left = unique(mark_left,'rows');
mark_right = unique(mark_right,'rows');
%markPointofNseeds = [mark_left;mark_right];
iter = [iter;size(mark_left,1) + size(mark_right,1)];
mark_left = [];
mark_right = [];
 end 
% markPointLeft = [markPointLeft;seed_n,seed_t];
end



    
    
   
    
    

