function calculateNcellsAroundTrasversalSection(numSeeds,kindProjection,pathV5data,directory2save1,numOfSurfaceRatios,Hinitial,Winitial)

    directory2save=[directory2save1 kindProjection '\' num2str(Winitial) 'x' num2str(Hinitial) '_' num2str(numSeeds) 'seeds\'];


    acumN=cell(numOfSurfaceRatios,size(pathV5data,1));

    for i=1:size(pathV5data,1)

        %load cylindrical Voronoi 5 data
        nameFile=pathV5data(i).name;
        load([directory2save nameFile(1:end-4) '\' nameFile],'listLOriginalProjection')

        for j=1:numOfSurfaceRatios
            [num2str(i),'-',num2str(j)]
            Img_cyl=listLOriginalProjection.L_originalProjection{j,1};
            %calculate neighbours of cells as cylinder model
            [neighs_cylModel,~]=calculateNeighbours(Img_cyl);


            %calculate neighbours of cells as planar model
            Img_planar=bwlabel(Img_cyl,8);
            [neighs_planar,~]=calculateNeighbours(Img_planar);

            %create adjacency matrix of planar model
            n_cellsPlanar=length(neighs_planar);
            adjacencyMatrix=zeros(n_cellsPlanar,n_cellsPlanar);
            for k=1:n_cellsPlanar
                for n=1:length(neighs_planar{k})
                    neighbors_network=neighs_planar{k};
                    adjacencyMatrix(k,neighbors_network(n))=1;
                    adjacencyMatrix(neighbors_network(n),k)=1;
                end
            end

            %choose cells from borders to calculate shortest path between them
            [H,W,~]=size(Img_cyl);
            hCoordinatesInitial=round(H*(0.1:0.1:0.9));
            hCoordinatesFinal=round(H*(0.1:0.1:0.9));
            
            cellsInitial=Img_planar(hCoordinatesInitial,1);
            cellsFinal=Img_planar(hCoordinatesFinal,W);
            while any(cellsInitial==0) || any(cellsFinal==0)
                indexZeroInitial=Img_planar(hCoordinatesInitial,1)==0;
                hCoordinatesInitial(indexZeroInitial)=hCoordinatesInitial(indexZeroInitial)+1;
                if hCoordinatesInitial(indexZeroInitial)==H
                    cellsInitial(indexZeroInitial)=Img_planar(hCoordinatesInitial(indexZeroInitial)+1,1);
                else
                    cellsInitial=Img_planar(hCoordinatesInitial,1);
                end
                indexZeroFinal=Img_planar(hCoordinatesFinal,end)==0;
                hCoordinatesFinal(indexZeroFinal)=hCoordinatesFinal(indexZeroFinal)+1;
                if hCoordinatesFinal(indexZeroFinal)==H
                    cellsFinal(indexZeroFinal)=Img_planar(hCoordinatesFinal(indexZeroFinal)-1,end);
                else
                    cellsFinal=Img_planar(hCoordinatesFinal,W);
                end
            end
            

            %Analysis shortest path from adjacency matrix
            nCellsSection=zeros(1,length(cellsInitial));
            for nPath=1:length(cellsInitial)
                [~,pathNodes,~]=graphshortestpath(sparse(adjacencyMatrix),cellsInitial(nPath),cellsFinal(nPath));
                mask=zeros(H,W);
                for cellPath=1:length(pathNodes)
                    mask(Img_planar==pathNodes(cellPath))=1;
                end
                %do cells in shortest path binary and the rest 0's, afterthat
                %multiplying by cylindermodel image.
                nCellsSection(nPath)=length(unique(mask.*Img_cyl))-1;

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


    save([directory2save 'numberOfCellsAlongTrasversalSection.mat'],'acumN','averageAcumN','averageAcumNByImage','stdAcumNByImage','averageAcumNGlobaBySurfaceRatio','stdAcumNGlobalBySurfaceRatio')
end