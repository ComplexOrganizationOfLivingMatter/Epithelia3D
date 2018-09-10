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

imgToShow(perimImg == 1) = 65536;
imshow(imgToShow');
hold on;
[xIndices, yIndices] = find(labelledImage(:, :,  selectedZ) == selectCellId);
if isempty(xIndices) == 0
    s = scatter(yIndices,xIndices,'filled','SizeData',10);
    hold off
    alpha(s,.7)
end
end

