function [ output_args ] = drawArrowBasalApical( data, titleName )
%DRAWARROWBASALAPICAL Summary of this function goes here
%   Detailed explanation goes here

h = figure;

drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1), 0, varargin{:});
for numRow = 1:size(data, 1)
    numRow
    plot(data(numRow, 1), data(numRow, 3), '.', 'color', [204 204 204]/255, 'MarkerSize', 15)
    hold on;
    plot(data(numRow, 2), data(numRow, 4), '.', 'color', 'b', 'MarkerSize', 15)
    drawArrow(data(numRow,[1 2]), data(numRow,[3 4]), 'color', 'k');
    
end
title(titleName);
xlabel('Edge Length');
ylabel('Angle');
newxLim = xlim;
newxLim(1) = 0;
set(gca, 'xlim', newxLim);

newyLim = ylim;
newyLim(1) = 0;
newyLim(2) = 90;
set(gca, 'ylim', newyLim);

end

