start=1;
% filemark=18;
% if(filemark~=4)
%   filename=strcat('pupil',num2str(filemark),'.avi');
%   readerobj = mmreader(filename, 'tag', 'myreader1');
%   numFrames = get(readerobj, 'numberOfFrames');
% else
%   numFrames=200;  
% end

  filename=strcat('picture/2mm3.avi');
  readerobj = mmreader(filename, 'tag', 'myreader1');
  numFrames = get(readerobj, 'numberOfFrames');
%    dir=strcat(strrep(filename,'.avi',''),'\pic');     
%    mkdir(dir);
%    fn=strrep(filename,'.avi','');
disp(numFrames);
for seq=start:numFrames
%--------------------------------------------%
%    if(filemark==4)
%       filename=strcat('E:\图割\自编图割代码\pupil4\原图\',int2str(seq),'.bmp');
%       b1=imread(filename);
%       b1=b1(157:487,163:533,1); 
%    else
%    %mov=mmreader(filename);            %用mmreader读入视频文件 
   b1=read(readerobj,seq); 
%    %b1=read(mov,seq);  
%    end
%    
%    if(filemark==1)
%      b1=b1(31:361,190:560,1);        %pupil1
% %    elseif(filemark==2)
% %      b1=b1(32:362,150:520,1);        %pupil2
% %    elseif(filemark==3)
% %      b1=b1(31:361,190:560,1);
%    elseif(filemark==5)
%      b1=b1(290:620,290:660,1);         %pupil5
%    elseif(filemark==6)
%      b1=b1(310:640,290:660,1);         %pupil6
% %    elseif(filemark==7)
% %      b1=b1(90:420,225:595,1);       %pupil7
% %    elseif(filemark==8)
% %      b1=b1(30:360,135:505,1);       %pupil8
% %    elseif(filemark==9)
% %      b1=b1(115:445,200:570,1);      %pupil9
%    elseif(filemark==10)
%      b1=b1(210:540,185:555,1);      %pupil9
%    elseif(filemark==11)
%      b1=b1(195:525,215:585,1);      %pupil9
%    elseif(filemark==12)
%        b1=b1(266:596,388:758,1);
%    elseif(filemark==13)
%        b1=b1(360:690,425:795,1);
%    elseif(filemark==14)
%        b1=b1(250:580,580:950,1);
%    elseif(filemark==15)
%        b1=b1(250:580,525:895,1);
%    elseif(filemark==16)
%        b1=b1(230:560,480:850,1);
%    elseif(filemark==17)
%        b1=b1(220:550,470:840,1);
%    elseif(filemark==18)
%        b1=b1(340:670,270:640,1);
%    end
%--------------------------------------------------------%

   im=b1(:,:,1);
   I=uint8(im);
   imwrite(I,strcat('result/2mm/',num2str(seq),'.bmp')) ;  
%    if seq<10
%        imwrite(I,'-avi-000',strcat(dir,'\',fn,num2str(seq),'.bmp'),'bmp');
%    elseif seq>=10&&seq<100
%        imwrite(I,'-avi-00',strcat(dir,'\',fn,num2str(seq),'.bmp'),'bmp');    
%    elseif seq>=100&&seq<1000
%        imwrite(I,'-avi-0',strcat(dir,'\',fn,num2str(seq),'.bmp'),'bmp');
%    elseif seq>=1000&&seq<10000
%        imwrite(I,'-avi-',strcat(dir,'\',fn,num2str(seq),'.bmp'),'bmp');
%    end    
end
