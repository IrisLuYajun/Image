%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for viewing the mirror reflection of an image along a Line
% Im - Input image
% pos - Line position where pos is a number between 1 and the number of columns in the image 
% newIm - The mirror image 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function newIm = mirror(Im,pos)

[x y z]=size(Im);
newIm = zeros(x,y,z);

newIm(:,pos+1:y,:) = Im(:,1:y-pos,:);
newIm(:,1:pos,:) = Im(:,pos:-1:1,:);

