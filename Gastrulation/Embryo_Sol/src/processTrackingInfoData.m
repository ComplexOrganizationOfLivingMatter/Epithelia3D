function [ ] = processTrackingInfoData( pathToData )
%PROCESSTRACKINGINFODATA Summary of this function goes here
%   Detailed explanation goes here

    load(pathToData);
    
    trackingInfo = vertcat(trackingInfo{:});
    
    trackingInfo.Properties.VariableNames(2) = {'PixelsImgInitial'};
    trackingInfo.Properties.VariableNames(4) = {'PixelsImgEnd'};
    
    imgInitialNewLabels = zeros(size(imgInitialWts));
    imgEndNewLabels = zeros(size(imgEndWts));
    
    [ imgInitialInvalidCells ] = getInvalidCells( imgInitialWts );
    [ imgEndInvalidCells ] = getInvalidCells( imgEndWts );
    
    trackingInfo.validCell = ones(size(trackingInfo, 1), 1);
    
    for numLabel = 1:size(trackingInfo, 1)
        if ismember(trackingInfo.idCellInit(numLabel), imgInitialInvalidCells) || ismember(trackingInfo.idCellEnd(numLabel), imgEndInvalidCells)
            trackingInfo.validCell(numLabel) = 0;
        end
        imgInitialNewLabels(imgInitialWts == trackingInfo.idCellInit(numLabel)) = numLabel;
        imgEndNewLabels(imgEndWts == trackingInfo.idCellEnd(numLabel)) = numLabel;
    end
    
    trackingInfo.newLabel = (1:size(trackingInfo, 1))';
    
    trackingInfo.neighboursInitial = calculateNeighbours(imgInitialNewLabels)';
    trackingInfo.neighboursEnd = calculateNeighbours(imgEndNewLabels)';
    
    trackingInfo.AreaInitial = struct2array(regionprops(imgInitialNewLabels, 'area'))';
    trackingInfo.AreaEnd = struct2array(regionprops(imgEndNewLabels, 'area'))';
    
    trackingInfo.PerimeterInitial = struct2array(regionprops(imgInitialNewLabels, 'perimeter'))';
    trackingInfo.PerimeterEnd = struct2array(regionprops(imgEndNewLabels, 'perimeter'))';
    
    trackingInfo.regionPropsInitial = regionprops(imgInitialNewLabels, 'all');
    trackingInfo.regionPropsEnd = regionprops(imgEndNewLabels, 'all');
    
    save(pathToData, 'trackingInfo', 'imgInitialNewLabels', 'imgEndNewLabels', 'imgEndWts', 'imgInitialWts');
end

