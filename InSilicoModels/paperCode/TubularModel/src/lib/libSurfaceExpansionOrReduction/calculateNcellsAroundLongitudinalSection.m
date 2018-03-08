function calculateNcellsAroundLongitudinalSection(numSeeds,kindProjection,path3dVoronoi,pathV5data,directory2save1,numOfSurfaceRatios)

    directory2save=[directory2save1 '\' kindProjection '\512x1024_' num2str(numSeeds) 'seeds\'];


    acumN=cell(numOfSurfaceRatios,size(pathV5data,1));

    for i=1:size(pathV5data,1)

        %load cylindrical Voronoi 5 data
        nameFile=pathV5data(i).name;
        load([directory2save '\' nameFile(1:end-4) '\' nameFile],'listLOriginalProjection')

        for j=1:numOfSurfaceRatios

            Img_cyl=listLOriginalProjection.L_originalProjection{j,1};
            %calculate neighbours of cells as cylinder model
            [neighs_cylModel,~]=calculateNeighbours(Img_cyl);

            %create adjacency matrix of planar model
            n_cellsPlanar=length(neighs_cylModel);
            adjacencyMatrix=zeros(n_cellsPlanar,n_cellsPlanar);
            for k=1:n_cellsPlanar
                for n=1:length(neighs_cylModel{k})
                    neighbors_network=neighs_cylModel{k};
                    adjacencyMatrix(k,neighbors_network(n))=1;
                    adjacencyMatrix(neighbors_network(n),k)=1;
                end
            end

            %choose cells to calculate shortest path between them
            [H,W,~]=size(Img_cyl);
            wCoordinatesInitial=round(W*(0.1:0.1:0.9));
            wCoordinatesFinal=round(W*(0.1:0.1:0.9));

            cellsInitial=Img_planar(1,wCoordinatesInitial);
            cellsFinal=Img_planar(H,wCoordinatesFinal);
            
            while any(Img_cyl(1,wCoordinatesInitial)==0) || any(Img_cyl(end,wCoordinatesFinal)==0)
                indexZeroInitial=Img_cyl(1,wCoordinatesInitial)==0;
                wCoordinatesInitial(indexZeroInitial)=wCoordinatesInitial(indexZeroInitial)+1;
                
                 if wCoordinatesInitial(indexZeroInitial)==W
                    cellsInitial(indexZeroInitial)=Img_cyl(1,wCoordinatesInitial(indexZeroInitial)+1);
                else
                    cellsInitial=Img_cyl(1,wCoordinatesInitial(indexZeroInitial));
                end
                
                indexZeroFinal=Img_cyl(end,wCoordinatesFinal)==0;
                wCoordinatesFinal(indexZeroFinal)=wCoordinatesFinal(indexZeroFinal)+1;
                if hCoordinatesFinal(indexZeroFinal)==H
                    cellsFinal(indexZeroFinal)=Img_cyl(end,wCoordinatesFinal(indexZeroFinal)-1);
                else
                    cellsFinal=Img_cyl(end,wCoordinatesFinal(indexZeroFinal));
                end
            end
            
            %Analysis shortest path from adjacency matrix
            nCellsSection=zeros(1,length(cellsInitial));
            for nPath=1:length(cellsInitial)
                [~,pathNodes,~]=graphshortestpath(sparse(adjacencyMatrix),cellsInitial(nPath),cellsFinal(nPath));
                nCellsSection(nPath)=length(pathNodes);
            end

            acumN{j,i}=nCellsSection;

        end


    end

    %statistics
    averageAcumN=cellfun(@(x) mean(x(:)),acumN);
    averageAcumNByImage=mean(averageAcumN,2)';
    stdAcumNByImage=std(averageAcumN,[],2)';
    averageAcumNGlobaBySurfaceRatio=zeros(1,numOfSurfaceRatios);
    stdAcumNGlobalBySurfaceRatio=zeros(1,numOfSurfaceRatios);
    for i=1:numOfSurfaceRatios
        averageAcumNGlobaBySurfaceRatio(1,i)=mean(horzcat(acumN{i,:}));
        stdAcumNGlobalBySurfaceRatio(1,i)=std(horzcat(acumN{i,:}));
    end


    save([directory2save 'numberOfCellsAlongLongitudinalSection.mat'],'acumN','averageAcumN','averageAcumNByImage','stdAcumNByImage','averageAcumNGlobaBySurfaceRatio','stdAcumNGlobalBySurfaceRatio')
end