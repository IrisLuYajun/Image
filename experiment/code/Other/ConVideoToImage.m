
 close all
 clear all
 clc
 
 [filename, pathname] = uigetfile('*.avi','please select a avi file');
 fprintf('filename = %s \npathname = %s \n\n', filename, pathname); 
 if ischar(filename) 
     fprintf('choose file success.\n\n');
     
 video = aviinfo([pathname filename]);
 len = video.NumFrames; % get length of the video 
 fprintf('length of video : %d \n\n', len);
 dir=strcat(pathname,strrep(filename,'.AVI',''),'\pic');
 if ~exist(dir)    % 若不存在，在当前目录中产生一个子目录‘Figure’
   mkdir(dir); % create folder for saving picture
   
end
 fn=strrep(filename,'.avi','');  % replace the .avi with '';
 for k = 1 : len 
     video_videotape(k) = aviread(video.Filename, k);
     frame=video_videotape(k).cdata;
     figure
     imshow(frame);    
     pause(2);  % delay 2 seconds
     imwrite(frame,strcat(dir,'\',fn,'-avi-0',int2str(k),'.jpg'),'jpg'); 
 end
 end
 