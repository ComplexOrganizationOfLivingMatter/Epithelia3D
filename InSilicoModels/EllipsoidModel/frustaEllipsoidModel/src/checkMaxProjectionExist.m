function [projectionsInnerWater,projectionsOuterWater,projectionsInnerVertices,projectionsOuterVertices,projectionsCellsConnectedToVertex] = checkMaxProjectionExist(ellipsoidPath,filePaths,nRand,nCellHeight,splittedCellHeight,nPath,cellHeight)

    if exist([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'file') || exist([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'file')
            if nCellHeight>1
                load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater','projectionsInnerVertices','projectionsOuterVertices','projectionsCellsConnectedToVertex')
            else
                load([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater','projectionsInnerVertices','projectionsOuterVertices','projectionsCellsConnectedToVertex')
            end
    else

        load([filePaths{nPath} 'random_' num2str(nRand) '\' ellipsoidPath(cellHeight).name])
        ellipsoidPath=dir([strrep(filePaths{nPath},'results','..\voronoiEllipsoidModel\results') 'random_' num2str(nRand) '\*llipsoid*' ]);
        load([strrep(filePaths{nPath},'results','..\voronoiEllipsoidModel\results') 'random_' num2str(nRand) '\' ellipsoidPath(cellHeight).name],'initialEllipsoid','ellipsoidInfo')
        ellipsoidInfo.img3DLayer=allFrustaImage;
        
%         verticesOuter.verticesConnectCells = verticesConnectCellsInitial;
%         verticesOuter.verticesPerCell = verticesPerCellInitial;

        %getting 4 projections from 3d ellipsoid
        tic
        [~,~,projectionsInnerWater,projectionsOuterWater,projectionsInnerVertices,projectionsOuterVertices,projectionsCellsConnectedToVertex]=maxProjectionVerticesFrustaEllipsoid( ellipsoidInfo,initialEllipsoid,finalVerticesAugmented,cell2mat(verticesPerCellInitial),verticesConnectCellsInitial);
        toc
        if nCellHeight>1
            save([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections_' splittedCellHeight],'projectionsInnerWater','projectionsOuterWater','projectionsInnerVertices','projectionsOuterVertices','projectionsCellsConnectedToVertex')
        else
            save([filePaths{nPath} 'random_' num2str(nRand) '\roiProjections.mat'],'projectionsInnerWater','projectionsOuterWater','projectionsInnerVertices','projectionsOuterVertices','projectionsCellsConnectedToVertex')
        end

    end

end

