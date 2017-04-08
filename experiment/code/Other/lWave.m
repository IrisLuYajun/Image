%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 小波变换检测信号突变点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rfLine = (Im_1(:,100))';
% rfLine = rfLine(1000:1500);
figure,
plot(rfLine);
xlabel('time');ylabel('amp');
title('RF scanline signal');
figure,
[d,a] = wavedec(rfLine,5,'db6');
% [c,l] = wavedec(rfLine,5,'db6');
% cfd = zeros(5,2080);
% for k = 1:5
%     d = detcoef(c,l,k);
%     d = d(ones(l,2^k),:);
%     cfd(k,:) = wkeep(d(:)',2080);
% end
% cfd = cfd(:);
% I=find(abs(cfd)<sqrt(eps));
% cfd(I)=zeros(size(I));
% cfd=reshape(cfd,5,2080);
% colormap(pink(64));
% img=image(flipud(wcodemat(cfd,64,'row')));
% set(get(img,'parent'),'YtickLabel',[]);
% title('离散小波变换后系数的绝对值')
% ylabel('层数'); 
% figure(3)  
% ccfs=cwt(rfLine,1:32,'haar','plot'); 
% title('连续小波变换系数的绝对值') 
% colormap(pink(64)); ylabel('尺度')  
% xlabel('时间(或者空间)')


a3=wrcoef('a',d,a,'db5',3); 
d3=wrcoef('d',d,a,'db5',3); 
d2=wrcoef('d',d,a,'db5',2); 
d1=wrcoef('d',d,a,'db5',1); 
subplot(411);plot(a3);ylabel('近似信号a3'); 
title('小波分解后示意图'); 
subplot(412);plot(d3);ylabel('细节信号'); 
subplot(413);plot(d2);ylabel('细节信号'); 
subplot(414);plot(d1);ylabel('细节信号'); 
xlabel('信号');
figure,plot(a3);ylabel('三层近似信号a3');