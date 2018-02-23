function [ ] = createPolarHistogram( inputAngles, colours, titleFig )
%CREATEPOLARHISTOGRAM Summary of this function goes here
%   Detailed explanation goes here

figure;
polarhistogram(deg2rad(inputAngles),'BinWidth',deg2rad(15),'Normalization','probability','FaceColor', colours,'FaceAlpha',1,'LineWidth',1)
ax=gca;
ax.ThetaZeroLocation='right';
% %ax.ThetaDir='clockwise';
ax.ThetaLimMode='manual';
ax.ThetaLim=[0,90];
ax.RLimMode='manual';
ax.GridAlpha=1;
ax.LineWidth=1;
ax.FontSize=30;
ax.RLim=[0,0.8];
ax.FontName='Helvetica-Narrow';
title(titleFig, 'FontSize', 16);


print(['results\polarHistogram_' strrep(titleFig,' ','') '_' date],'-dtiff','-r300')

close
end

