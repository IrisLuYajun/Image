function [envmin]=baoluo(x6,t)

x66 = hilbert(x6);
xx=abs(x66+j*x6);
% figure(1)
% hold on
% plot(t,x6);
% plot(t,xx,'r')
% hold off
% 包络算法，未考虑边界条件
d = diff(x6);
n = length(d);
d1 = d(1:n-1);
d2 = d(2:n) ;
indmin = find(d1.*d2<0 & d1<0)+1;
indmax = find(d1.*d2<0 & d1>0)+1;
envmin = spline(t(indmin),x6(indmin),t);
envmax = spline(t(indmax),x6(indmax),t);

% figure
% hold on
% plot(t,x6);
% %plot(t,envmin,'r');
% plot(t,envmax,'m');
% hold off
end