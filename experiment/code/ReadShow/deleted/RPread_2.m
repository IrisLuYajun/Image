%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% loads the ultrasound RF data saved from the Sonix software
%%
%% Inputs:  
%%     filename - The path of the data to open
%%     version  - The version of the Sonix (Exam) software used to acquire
%%                the data
%%
%% Return:
%%     Im     -   The image data returned into a 3D array (h, w, numframes)
%%     header -   The file header information   
%%
%% Authors: Corina Leung, corina.leung@ultrasonix.com
%%          Ali Baghani,  ali.baghani@ultrasonix.com
%% Copyright: Ultrasonix Medical Corporation - Analogic Ultrsound Group
%%            2011 - 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Im,header] = RPread(varargin)  %% 'aasf.b8'
clear all;
close all;
% to determine whether a later version of Sonix is being used
if nargin > 1
    filename = varargin{1};    
    version  = varargin{2};         % Valid versions are in the a.b.c format, for instance 5.7.4, 6.0.6, or 6.1.0
else
    filename = varargin{1};
    version  = '6.1.0';
end

% Converting the string version to a numeric for ease of comparison
version = string2numericVer(version);

% In very old versions of the Sonix, the file extension was also used to
% distinguish some data types. The practice is now obsolete
fileExt = filename(end-3:end);

fid = fopen(filename, 'r');
if( fid == -1)
    error('Cannot open file');
end

% load the header information into a structure and save under a separate file
hinfo = fread(fid, 19, 'int32');
header.filetype = hinfo(1);
header.nframes = hinfo(2);
header.w = hinfo(3);
header.h = hinfo(4);
header.ss = hinfo(5);
header.ul = [hinfo(6), hinfo(7)];
header.ur = [hinfo(8), hinfo(9)];
header.br = [hinfo(10), hinfo(11)];
header.bl = [hinfo(12), hinfo(13)];
header.probe = hinfo(14);
header.txf = hinfo(15);
header.sf = hinfo(16);
header.dr = hinfo(17);
header.ld = hinfo(18);
header.extra = hinfo(19);
%% 下面这条语句在读取avi rf数据的时候使用，因为会产生内存不足的情况，所以要限定读取的帧数，17帧是能读取的最大帧数
%因此Untitled.m调用RPread.m时有下面这一条语句，而Untitled.m调用时没有这条语句
header.nframes = 20;



% --------------  memory initialization for speeding up -------------------
Im = zeros(header.h, header.w, 10);


h = waitbar(0, 'Please wait while the data is being loaded.');
% load the data and save into individual .mat files

for frame_count = 1:10
    
    % In older versions of the Sonix (Exam) Software, a frame header was
    % saved for every frame of data. This practice was abondoned from
    % version 6.0.0 onward
    if and(version < 60000, ismember(header.filetype, ...
            [2, 4, 8, 16, 32, 128, 512, 1024, 2048, 4096]))
        frameNoTag = fread(fid, 1, 'int32'); 
    end
    Im(:,:,frame_count) = fread(fid, [header.h, header.w], 'int16');
    
    
    if (ishandle(h))
        waitbar(frame_count/header.nframes, h);
    else 
        h = waitbar(frame_count/header.nframes, 'Please wait while the data is being loaded.');
    end   
end

if or(header.filetype == 131072, header.filetype == 262144) %.gps
    Im.gps_posx    = gps_posx;
    Im.gps_posy    = gps_posy;
    Im.gps_posz    = gps_posz;
    Im.gps_s       = gps_s;
    Im.gps_time    = gps_time;
    Im.gps_quality = gps_quality;
    Im.gps_Zeros   = Zeros;
    if (version >= 60003)
     Im.gps_a    = gps_a;
     Im.gps_e    = gps_e;
     Im.gps_r    = gps_r;
     Im.gps_q    = gps_q;
    end
end

pause(0.1);
if (ishandle(h))
    delete(h);
end

fclose(fid);

function numericVersion = string2numericVer(version)
% converting the string version to an ordinal number // 5.7.4 -> 50704
inds      = regexp(version, '\.');
vMajor    = str2double(version(1:inds(1)-1));
vMinor    = str2double(version(inds(1)+1:inds(2)-1));
vSubMinor = str2double(version(inds(2)+1:end));

numericVersion   = vMajor * 100 * 100 + vMinor * 100 + vSubMinor;
