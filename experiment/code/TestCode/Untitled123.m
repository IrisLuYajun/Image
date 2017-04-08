%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 对位移曲线滤波
%% Inputs:  
%%      hmin,hmax               -   感兴趣区域
%%      point                   -   匹配的点
%%      windowMeanPoint_MA      —  MA上的点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('point.mat'); 
% load('windowMeanPoint_MA.mat');
% load('hmax.mat'); 
% load('hmin.mat'); 
ROI_Im = Im(hmin:hmax,:,:);
% close all
 figure,
 axis on
 hold on
for index = 1:length(windowMeanPoint_MA) 
    distension_index = point(index,:,:);
    distension = [];
     for i = 1:size(ROI_Im,3)
         distension = [distension;distension_index(:,:,i)];
     end
      
      distension_y = distension(2:end,2)-distension(2,2);%%%%%%%%%%%相对于哪个点？心脏舒张末期那一帧怎么找到
      D = fft(distension_y);
%     plot(abs(D));
      x = 0:(length(distension_y)-1);
      plot(x,distension_y);
      dtt = diff(x);
      dt = sum(dtt)/length(dtt);
      Fs = round(1/dt);
      Wp = 0;
      Ws = 10/(Fs/2);
      Rp = 0.05;
      Rs = 85;
      [n,Wn] = buttord(0.1,0.8,Rp,Rs);
      [b,a] = butter(n,Wn);
      [h,w]=freqz(b,a,512,Fs);
      RollAf=filtfilt(b,a,distension_y);
%     plot(w,abs(h));
      H=plot(x,distension_y,x,RollAf,'r--');
      set(H(2),'linewidth',2);
      
 end
 

% Im_framenum2 = ROI_Im(:,:,framenum);%后一帧
%     for index = 1:length(windowMeanPoint_MA)   
%          p = windowMeanPoint_MA(index,:);
%          x_double = p(:,1);%横坐标
%          y_double = p(:,2);%纵坐标
%          x = round(p(:,1));%横坐标
%          y = round(p(:,2));%纵坐标
%          window_1 = Im_framenum1((y-interval_1):(y+interval_1),(x-interval_1):(x+interval_1));
%          mean_1 = mean(mean(window_1));
%          siegema_1 = sqrt(sum(sum((window_1 - mean_1).^2)));
%          
%          i = 1;
%          for m = (x_double-(interval_2-interval_1)):0.5:(x_double+(interval_2-interval_1))
%              for n = ( y_double-(interval_2-interval_1)):0.5:( y_double+(interval_2-interval_1))
%                 m_integer = round(m);
%                 n_integer = round(n);
%                 window_2 = Im_framenum2(round(n-interval_1):round(n+interval_1),round(m-interval_1):round(m+interval_1));
%                 mean_2 = mean(mean(window_2 ));
%                 siegema_2 = sqrt(sum(sum(window_2.^2 )));
%                 window_1 = window_1 - mean_1;
%                 window_2 = window_2 - mean_2;
%                 ANC(index,i) = sum(sum((window_1.*window_2)/(siegema_1*siegema_2)));
%                 i = i + 1;
%              end
%          end
%          
%     end