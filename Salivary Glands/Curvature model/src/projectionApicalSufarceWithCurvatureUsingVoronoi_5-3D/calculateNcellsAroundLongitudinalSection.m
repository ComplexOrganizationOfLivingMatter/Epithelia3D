numSeeds=400;
numOfSurfaceRatios=10;
nameOfFolder=['512x1024_' num2str(numSeeds) 'seeds\'];
path3dVoronoi='D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\expansion\512x1024_400seeds\';
directory2save='..\..\data\expansion\512x1024_400seeds\';
addpath('lib')   
pathV5data=dir([path3dVoronoi '*m_5*']);

acumN=cell(numOfSurfaceRatios,size(pathV5data,1));

for i=1:size(pathV5data,1)

    %load cylindrical Voronoi 5 data
    load([path3dVoronoi pathV5data(i).name '\' pathV5data(i).name '.mat'],'listLOriginalProjection')

    parfor j=1:numOfSurfaceRatios
        
        Img_cyl=listLOriginalProjection.L_originalProjection{j,1};
        %calculate neighbours of cells as cylinder model
        [neighs_cylModel,~]=calculate_neighbours(Img_cyl);
        
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
        
        while any(Img_cyl(1,wCoordinatesInitial)==0) || any(Img_cyl(end,wCoordinatesFinal)==0)
            indexZeroInitial=Img_cyl(1,wCoordinatesInitial)==0;
            wCoordinatesInitial(indexZeroInitial)=wCoordinatesInitial(indexZeroInitial)+1;
            indexZeroFinal=Img_cyl(end,wCoordinatesFinal)==0;
            wCoordinatesFinal(indexZeroFinal)=wCoordinatesFinal(indexZeroFinal)+1;
        end
        cellsInitial=Img_cyl(1,wCoordinatesInitial);
        cellsFinal=Img_cyl(end,wCoordinatesFinal);
        
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


save(['..\..\data\expansion\512x1024_' num2str(numSeeds) 'seeds\numberOfCellsAlongLongitudinalSection.mat'],'acumN','averageAcumN','averageAcumNByImage','stdAcumNByImage','averageAcumNGlobaBySurfaceRatio','stdAcumNGlobalBySurfaceRatio')
