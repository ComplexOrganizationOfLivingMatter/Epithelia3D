uiopen('D:\Pablo\Epithelia3D\Salivary Glands\docs\3dMapping_ApicalSurface_EdgeLength_Angle_05-06-2017.txt',1)

tableInfo = dMappingApicalSurfaceEdgeLengthAngle05062017;
scatter3(tableInfo.LEdgeTransition, tableInfo.angledegrees, tableInfo.Apicalsurfacereduction);
transitionsRows = cellfun(@(x) isempty(x), strfind(lower(tableInfo.Name), 'no'));

h = figure;
colorTransition = [0 153 0];
colorNoTransition = [255 51 51];
scatter3(tableInfo.LEdgeTransition(transitionsRows), tableInfo.angledegrees(transitionsRows), tableInfo.Apicalsurfacereduction(transitionsRows), 36, colorTransition/255);
hold on;
scatter3(tableInfo.LEdgeTransition(transitionsRows == 0), tableInfo.angledegrees(transitionsRows == 0), tableInfo.Apicalsurfacereduction(transitionsRows == 0), 36, colorNoTransition/255);
legend('WT Transition', 'WT No Transition');
xlabel('edge length (micrometers)');
ylabel('edge angle (degrees)');
zlabel('apical surface reduction');
orient landscape