addpath('src\measureEnergy')

filePath='results\Stage 8\random_1\ellipsoid_x21648_y1_z1_cellHeight01457.mat';

load(filePath,'ellipsoidInfo','initialEllipsoid');

[projectionsInner,projectionsOuter,projectionsInnerWater,projectionsOuterWater]=zProjectionEllipsoid( ellipsoidInfo.img3DLayer,initialEllipsoid.img3DLayer);




    
    
    % cells in ROI
    tableDataAnglesTransitionsEdgesOuter.TotalRegion.cellularMotifs;


