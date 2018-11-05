function [] = showSelectedCell()
%SHOWSELECTEDCELL Summary of this function goes here
%   Detailed explanation goes here
selectCellId = getappdata(0, 'cellId');
labelledImage = getappdata(0, 'labelledImageTemp');
selectedZ = getappdata(0, 'selectedZ');
lumenImage = getappdata(0, 'lumenImage');

% perimImg = bwperim(labelledImage(:, :,  selectedZ) == selectCellId)';
%imshow(perimImg);
imageSequence = getappdata(0, 'imageSequence');

imgToShow = imageSequence(:, :, selectedZ);

% imgToShow(perimImg == 1) = 65536;
cla('reset') 
imshow(imgToShow);
hold on;
[xIndices, yIndices] = find(labelledImage(:, :,  selectedZ) == selectCellId);
if isempty(xIndices) == 0
    s2 = scatter(yIndices, xIndices, 'blue','filled','SizeData',10);
    hold off
    alpha(s2,.4)
end

%% Showing lumen
[xIndices, yIndices] = find(lumenImage(:, :,  selectedZ) == 1);
if isempty(xIndices) == 0
    hold on
    s = scatter(yIndices, xIndices, 'red', 'filled','SizeData',10);
    hold off
    alpha(s,.5)
end

end

