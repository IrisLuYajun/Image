%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  ”√”⁄œ‘ æRFÕºœÒ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RPviewrfs(rawIm, header, framenum)

% Im = sqrt(abs(hilbert(rawIm(:,:,framenum))));
% 
% figure, 
% imagesc(Im);
% rfimtitle = sprintf('RF Raw Image %d',framenum);
% title(rfimtitle);
% colormap(gray);



Im = abs(hilbert(rawIm(:,:,framenum)));
A = 35;
M = 30;
Imout = (20*log10(Im/max(Im(:))) + A)/ M * 255;
figure, 
image(Imout);
rfimtitle = sprintf('RF Raw Image %d',framenum);
title(rfimtitle);
colormap(gray(256));


end
