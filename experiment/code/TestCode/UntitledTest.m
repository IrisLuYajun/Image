% figure,
%  axis on
%  hold on
% for index = 1:length(windowMeanPoint_MA) 
%     distension_index = point(index,:,:);
%     distension = [];
%      for i = 1:size(ROI_Im,3)
%          distension = [distension;distension_index(:,:,i)];
%      end
%       
%       distension_y = distension(1:end,2);
%       x = 0:(length(distension_y)-1);
%       plot(x,distension_y);
% end


 figure;
 [Im,header] = RPread('avib8.b8');
 for i = 1: size(Im, 3)
       
    image(Im(:,:,i));
    colormap(gray(256));
    axis('image');
    
    drawnow;
    title(i);
    
    pause(0.5);
 end