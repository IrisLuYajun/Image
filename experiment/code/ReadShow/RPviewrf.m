%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% loads the ultrasound RF data saved from the Sonix software. Clicking on
%% the raw RF image will display that particular line of RF data.
%%
%% Inputs:  
%%     rawIm - The data to view
%%     header - The file header
%%     framenum - The frame number to show
%%
%% Ultrasonix Medical Corporation Jan 31, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RPviewrf(rawIm, header, framenum)

Im = sqrt(abs(hilbert(rawIm(:,:,framenum))));

figure, subplot(2,1,1);
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

    subplot(2,1,2);
    plot(RFLine, 'b'); 
    axis([0 length(RFLine) min(RFLine) max(RFLine)]); 
    rftitle = sprintf('RF Line: %d', Line);
    title(rftitle);  
end