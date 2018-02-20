function [ distanceMatrixLocal, adjacencyMatrix, distanceMatrixGlobal] = calculateDistanceMatrixInVoronoi3D( new_seeds_values,L_original,W )
    
    %How cells are connected to calculated 'width' and n of cells

    centroids=sortrows(new_seeds_values,1);
    centroids=centroids(:,2:3);
    centroidsX2=[centroids; [centroids(:,1), (centroids(:,2)+W)]];
    distanceMatrixGeneral=squareform(pdist(centroidsX2)); 
    [neighs,~]=calculate_neighbours(L_original);
    
    adjacencyMatrix=zeros(length(centroids),length(centroids));
    distanceMatrixLocal=zeros(length(centroids),length(centroids));
    distanceMatrixGlobal=zeros(length(centroids),length(centroids));
    for j=1:length(centroids)
        localDistance=[]; %#ok<NASGU>
        adjacencyMatrix(j,(neighs{j}'))=1;
        localDistance=[distanceMatrixGeneral(j,:).*[adjacencyMatrix(j,:),adjacencyMatrix(j,:)];distanceMatrixGeneral(j+length(centroids),:).*[adjacencyMatrix(j,:),adjacencyMatrix(j,:)]];
        localDistance=[localDistance(:,1:length(centroids));localDistance(:,length(centroids)+1:end)];
        distanceMatrixLocal(j,:)=min(localDistance);
        distanceMatrixRow=[distanceMatrixGeneral(j,:);distanceMatrixGeneral(j+length(centroids),:)];
        distanceMatrixGlobal(j,:)=min([distanceMatrixRow(:,1:length(centroids));distanceMatrixRow(:,length(centroids)+1:end)]);
    end

end

