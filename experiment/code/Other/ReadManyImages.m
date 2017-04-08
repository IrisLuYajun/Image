clc
close all
clear  all

for i=1:3   %lsg1.jpg,lsg2.jpg, ....  
lsg{i} = imread(['lsg' int2str(i) '.jpg']);
 figure
 imshow(lsg{i});
 pause(2);% delay 2 seconds
end



