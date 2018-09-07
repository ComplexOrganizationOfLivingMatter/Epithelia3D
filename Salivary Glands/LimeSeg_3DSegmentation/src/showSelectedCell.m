function [] = showSelectedCell()
%SHOWSELECTEDCELL Summary of this function goes here
%   Detailed explanation goes here
selectCellId = getappdata(0, 'cellId');
labelledImage = getappdata(0, 'labelledImage');
selectedZ = getappdata(0, 'selectedZ');

perimImg = bwperim(labelledImage(:, :,  selectedZ) == selectCellId)';
%imshow(perimImg);
imageSequence = getappdata(0, 'imageSequence');

imgToShow = imageSequence{selectedZ};

[xOld, yOld, zOld] = ind2sub(size(perimImg),find(perimImg == 1));
newIndices = sub2ind(size(imgToShow), xOld, yOld, zOld);

imgToShow(newIndices) = 65536;
imshow(imgToShow);
end

