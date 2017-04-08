%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% destoried code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function findROIbyRF(rawIm, header, framenum)

Im = sqrt(abs(hilbert(rawIm(:,:,framenum))));

figure, subplot(3,1,1);
imagesc(Im);
rfimtitle = sprintf('RF Raw Image %d',framenum);
title(rfimtitle);
colormap(gray);

while(-1)
    [x,y] = ginput(1);

    Line = round(x);   
    
    if(header.filetype == 16)
        if(x<1 || x>header.w)
            return;
        end    
    else
         if(x<1 || x>header.h)
            return;
        end
    end
    
    RFLine = rawIm(:,Line,framenum);

    subplot(3,1,2);
    plot(RFLine, 'b'); 
    axis([0 length(RFLine) min(RFLine) max(RFLine)]); 
    rftitle = sprintf('RF Line: %d', Line);
    title(rftitle);  
    %% rf scanline signal 简化
     j = 1;
    space = 15;
    simplifedRFline = zeros(1,(length(RFLine)/space));
    for i = 1:space:(length(RFLine)-space)
        simplifedRFline(1,j) = mean(RFLine(i:(i+space)));
        j = j+1;
    end
    subplot(3,1,3),plot(simplifedRFline);
    title('simplified RF scanline signal');
    extrMaxIndex = find(diff(sign(diff(simplifedRFline)))==-2)+1;%极大值点索引值
end

