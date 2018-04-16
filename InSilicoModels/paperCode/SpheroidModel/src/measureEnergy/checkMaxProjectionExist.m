function [ projectionsInnerWater,projectionsOuterWater ] = checkMaxProjectionExist( filePath, nRand, nCellHeight, splittedCellHeight )
%CHECKMAXPROJECTIONEXIST If the projection does not exist, it creates it.
% 
    if exist([filePath 'randomizations\random_' num2str(nRand) '\roiProjections.mat'],'file') || exist([filePath 'randomizations\random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'file')
        if nCellHeight>1
            load([filePath 'randomizations\random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
        else
            load([filePath 'randomizations\random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
        end
    else
        ellipsoidInfoFile = dir([filePath 'randomizations\random_' num2str(nRand) '\*' splittedCellHeight]);
        load([filePath 'randomizations\random_' num2str(nRand) '\' ellipsoidInfoFile(1).name] ,'ellipsoidInfo','initialEllipsoid')
        %getting 4 projections from 3d ellipsoid
        [projectionsInner,projectionsOuter,projectionsInnerWater,projectionsOuterWater]=maxProjectionEllipsoid( ellipsoidInfo,initialEllipsoid);
        if nCellHeight>1
            save([filePath 'randomizations\random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater')
        else
            save([filePath 'randomizations\random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater')
        end

    end

end

