
validDirs = {'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Ball\random_1\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Ball\random_2\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Ball\random_3\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Ball\resolution_150\random_1\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Ball\resolution_150\random_2\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Ball\resolution_150\random_3\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Sphere\random_1\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Sphere\random_2\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Sphere\random_3\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Rugby\random_1\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Rugby\random_2\', ...
    'D:\Pablo\Epithelia3D\InSilicoModels\EllipsoidModel\voronoiEllipsoidModel\results\Rugby\random_3\'};

for numDirs = 1:size(validDirs, 1)
    outputDir = validDirs{numDirs};
    load(strcat(outputDir, 'voronoi01-Mar-2018.mat'))

    [allXs, allYs, allZs] = findND(img3DLabelled > 0);
    allXs = uint16(allXs);
    allYs = uint16(allYs);
    allZs = uint16(allZs);
    initialEllipsoid = ellipsoidInfo;
    initialEllipsoid.surfaceIndices = [];
    countOfHeights=1;
    hCellsPredefined = [0.5, 1, 2];

    for cellHeight = hCellsPredefined
        cellHeight
        ellipsoidInfo.xRadius = initialEllipsoid.xRadius;
        ellipsoidInfo.yRadius = initialEllipsoid.yRadius;
        ellipsoidInfo.zRadius = initialEllipsoid.zRadius;
        ellipsoidInfo.cellHeight = cellHeight;

        [ validPxs, innerLayerPxs, outerLayerPxs ] = getValidPixels(allXs, allYs, allZs, ellipsoidInfo, cellHeight);
        img3DLabelledActual = img3DLabelled;
        novalidIndices = uint64(sub2ind(size(img3DLabelled), allXs(validPxs == 0), allYs(validPxs == 0), allZs(validPxs == 0)));
        img3DLabelledActual(novalidIndices) = 0;
        img3DOutterLayer = zeros(size(img3DLabelled), 'uint16');
        outterLayerIndices = uint64(sub2ind(size(img3DLabelled), allXs(outerLayerPxs), allYs(outerLayerPxs), allZs(outerLayerPxs)));
        img3DOutterLayer(outterLayerIndices) = img3DLabelledActual(outterLayerIndices);

        disp('Getting info of vertices and neighbours: outter layer');
        ellipsoidInfo.img3DLayer = img3DOutterLayer;
        ellipsoidInfo.surfaceIndices = outterLayerIndices;
        %[ellipsoidInfo] = calculate_neighbours3D(img3DOutterLayer, ellipsoidInfo);
        %ellipsoidInfo.cellArea = calculate_volumeOrArea(img3DOutterLayer);
        %ellipsoidInfo.cellVolume = calculate_volumeOrArea(img3DLabelled);
        if isempty(initialEllipsoid.surfaceIndices)
            disp('Getting info of vertices and neighbours: inner layer');

            img3DInnerLayer = zeros(size(img3DLabelled), 'uint16');
            innerLayerIndices = uint64(sub2ind(size(img3DLabelled), allXs(innerLayerPxs), allYs(innerLayerPxs), allZs(innerLayerPxs)));
            img3DInnerLayer(innerLayerIndices) = img3DLabelledActual(innerLayerIndices);
            initialEllipsoid.surfaceIndices = innerLayerIndices;
            initialEllipsoid.img3DLayer = img3DInnerLayer;
            %[initialEllipsoid] = calculate_neighbours3D(img3DInnerLayer, initialEllipsoid);
            %initialEllipsoid.cellArea = calculate_volumeOrArea(img3DInnerLayer);
        end

        %             exchangeNeighboursPerCell = cellfun(@(x, y) size(setxor(y, x), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
        %             %[ellipsoidInfo] = calculate_neighbours3D(img3DOutterLayer, ellipsoidInfo); [initialEllipsoid] = calculate_neighbours3D(img3DInnerLayer, initialEllipsoid);
        %
        %             winnigNeighboursPerCell = cellfun(@(x, y) size(setdiff(y, x), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
        %             losingNeighboursPerCell = cellfun(@(x, y) size(setdiff(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood);
        %
        %             if sum(winnigNeighboursPerCell - losingNeighboursPerCell) == 0
        %                 %error ('incorrectNeighbours', 'There should be the same number of winning and losing neighbours')
        %             end


        ellipsoidInfo.xRadius = initialEllipsoid.xRadius + cellHeight;
        ellipsoidInfo.yRadius = initialEllipsoid.yRadius + cellHeight;
        ellipsoidInfo.zRadius = initialEllipsoid.zRadius + cellHeight;

        %             newRowTableMeasuredOuter = createExcel( ellipsoidInfo, initialEllipsoid, exchangeNeighboursPerCell);
        %             newRowTableMeasuredInner = createExcel( initialEllipsoid, ellipsoidInfo, exchangeNeighboursPerCell);
        %
        %             cellsTransition = find(cellfun(@(x, y) size(setxor(x, y), 1), ellipsoidInfo.neighbourhood, initialEllipsoid.neighbourhood)>0, 1);
        %
        %             tableDataAnglesTransitionsEdgesOuter=[];
        %             tableDataAnglesNoTransitionsEdgesOuter=[];
        %             tableDataAnglesTransitionsEdgesInner=[];
        %             tableDataAnglesNoTransitionsEdgesInner=[];
        %
        % %             if ~isempty(cellsTransition)
        %                 [tableDataAnglesTransitionsEdgesOuter, tableDataAnglesNoTransitionsEdgesOuter] = getAnglesLengthAndTranstionFromTheEdges( initialEllipsoid, ellipsoidInfo);
        %                 close
        %                 [tableDataAnglesTransitionsEdgesInner, tableDataAnglesNoTransitionsEdgesInner] = getAnglesLengthAndTranstionFromTheEdges( ellipsoidInfo, initialEllipsoid);
        %                 close
        % %             end


        %Saving info
        %save(strcat(outputDir, '\ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_cellHeight', strrep(num2str(cellHeight), '.', '')), 'ellipsoidInfo', 'initialEllipsoid', 'tableDataAnglesTransitionsEdgesOuter','tableDataAnglesNoTransitionsEdgesOuter','tableDataAnglesTransitionsEdgesInner','tableDataAnglesNoTransitionsEdgesInner', '-v7.3');
        save(strcat(outputDir, '\ellipsoid_x', strrep(num2str(ellipsoidInfo.xRadius), '.', ''), '_y', strrep(num2str(ellipsoidInfo.yRadius), '.', ''), '_z', strrep(num2str(ellipsoidInfo.zRadius), '.', ''), '_cellHeight', strrep(num2str(cellHeight), '.', '')), 'ellipsoidInfo', 'initialEllipsoid', '-v7.3');


        %             fieldsNoSavedInCSV={'edgeLength','edgeAngle','edgeVertices','cellularMotifs'};
        %             for numBorders=1:length(newRowTableMeasuredOuter)
        %
        %
        %
        %                 transitionsCSVInfoTransitionsMeasuredOuter(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredOuter{numBorders}), struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesOuter.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
        %                 transitionsCSVInfoTransitionsMeasuredInner(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredInner{numBorders}), struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesTransitionsEdgesInner.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
        %                 transitionsCSVInfoNoTransitionsMeasuredOuter(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredOuter{numBorders}), struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesOuter.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
        %                 transitionsCSVInfoNoTransitionsMeasuredInner(countOfHeights,numBorders) = {horzcat(struct2table(newRowTableMeasuredInner{numBorders}), struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.TotalRegion,fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.LeftRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.RightRegion(numBorders),fieldsNoSavedInCSV)),struct2table(rmfield(tableDataAnglesNoTransitionsEdgesInner.CentralRegion(numBorders),fieldsNoSavedInCSV)))};
        %
        %             end
        countOfHeights=countOfHeights+1;
    end
end