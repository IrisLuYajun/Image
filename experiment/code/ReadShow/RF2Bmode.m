%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  rf -- B mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Imout = RF2Bmode(rawIm, framenum)

Im = abs(hilbert(rawIm(:,:,framenum)));
A = 35;
M = 30;
Imout = (20*log10(Im/max(Im(:))) + A)/ M * 255;
figure, 
image(Imout);
rfimtitle = sprintf('A = %d,M = %d',A,M);
title(rfimtitle);
colormap(gray(256));
%% 整体增强
% [x,y] = size(rawIm);
% Cmin = 6;
% Cmax = 150;
% for(i = 1:x)
%     for(j = 1:y)
%         enhancedImout(i,j) = 255*((Imout(i,j)-Cmin)/(Cmax - Cmin));
%     end
% end
% figure, 
% image(enhancedImout);
% rfimtitle = sprintf('enhanced');
% title(rfimtitle);
% colormap(gray(256));

end
