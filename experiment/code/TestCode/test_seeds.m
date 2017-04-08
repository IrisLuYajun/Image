%seeds;
clear all
close all
clc
set(gcf,'color','white')
A=imread('seed.jpg');
B=imshow(A);
x=ginput;
k=size(x,1);
axis on
hold on
for i=1:k
    plot(x(i,1),x(i,2),'r+');
    text(x(i,1),x(i,2),sprintf('(%d,%d)',round(x(i,1)),round(x(i,2))),'color','red')
end  
axis off