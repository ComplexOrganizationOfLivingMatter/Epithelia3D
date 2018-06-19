function extractionVertices2D_3D%(pathFile,projectionType,imageType)
    projectionType='expansion';
    H_initial=4096;
    W_initial=2048;
    n_seeds=200;
    imageType=[num2str(W_initial) 'x' num2str(H_initial) '_' num2str(n_seeds) 'seeds'];
    rootPath='D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\';
    pathFile=['data\tubularVoronoiModel\' projectionType '\' imageType '\'];
    reductionFactor=20;
    surfaceRatios=[1 10];
    
    listFolders=dir([rootPath pathFile 'Image_*']);
    addpath(genpath('src'))
    cellWithVertices={};
    dataVertID={};
    pairOfVerticesTotal={};
    
    for nRand=1%:length(listFolders)
        load([rootPath pathFile 'Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listSeedsProjected','listLOriginalProjection')
        for nSurfR = surfaceRatios

            %%1- vertices located in Cylinder 3D position over the surface
            %%2- vertices in contact over the surface
            L_img = listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==nSurfR};
            [dataVertID,pairOfVerticesTotal,verticesInfo,verticesNoValidCellsInfo]=extract3dCoordInCylinderSurface(L_img,dataVertID,pairOfVerticesTotal,nRand);          
            %%3- cells compones by N-vertices
            cellWithVertices = groupingVerticesPerCellSurface(L_img,verticesInfo,verticesNoValidCellsInfo,cellWithVertices,nRand);          
            
            [quartetsOfNeighs] = buildQuartetsOfNeighs2D(L_img);
                       
        end
        
        dir2save=[rootPath 'data\tubularVoronoiModel\3Dreconstruction\'];
        name2save= [dir2save 'Image_' num2str(nRand) '_' imageType '_surfaceRatio_' num2str(nSurfR) '_reductionFactor_' num2str(reductionFactor)];
        disp(name2save)
        if exist([name2save '.mat'],'file')
            load(name2save,'image3DInfo','img3Dfinal')
        else
            %tridimentional reconstruction info
            [~,img3Dfinal]=rebuilding3dVoronoiCylinderFromSeedsExpansion( initialSeeds, H_initial, W_initial, surfaceRatio,reductionFactor,name2save);
            save([name2save '.mat'],'image3DInfo','img3Dfinal','-append');
        end
        
        %calculate vertices of scutoids composed by 4 or more cells
        clusterOfNeighs = buildClustersOfNeighs3D(image3DInfo);
        
        %get scutoids vertices in the extreme region
        [neighDown,~]=calculateNeighbours(img3Dfinal(:,:,1));
        [neighUp,~]=calculateNeighbours(img3Dfinal(:,:,end));
        [verticesInfoDown] = calculateVertices(img3Dfinal(:,:,1),neighDown);
        [verticesInfoUp] = calculateVertices(img3Dfinal(:,:,1),neighUp);
                
    end
    
    
    cellVerticesTable=cell2table(cellWithVertices,'VariableNames',{'nRand','radius','cellID','noValidCellID','borderCellID','vertX_Y'});
    pairOfVerticesTable=cell2table(pairOfVerticesTotal,'VariableNames',{'verticeID1','verticeID2','nRand','radius'});
    vertices3dTable=cell2table(dataVertID,'VariableNames',{'nRand','radius','verticeID','vertX','vertY','vertZ','cellID'});

    writetable(cellVerticesTable,[projectionType '_' imageType '_tableVertices2D_' date '.xls'])
    writetable(vertices3dTable,[projectionType '_' imageType '_tableVertices3D_' date '.xls'])
    writetable(pairOfVerticesTable,[projectionType '_' imageType '_tableConnectionOfVertices3D_' date '.xls'])

end