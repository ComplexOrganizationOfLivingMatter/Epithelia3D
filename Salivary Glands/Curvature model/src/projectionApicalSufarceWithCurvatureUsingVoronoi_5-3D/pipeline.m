%pipeline

path3dVoronoi='D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\External cylindrical voronoi\';
directory2save='..\..\data\';
addpath('lib')

pathV5data=dir([path3dVoronoi '*_5_V*']);

for i=1:size(pathV5data,1)
    
    load([path3dVoronoi pathV5data(i).name])
    
    [H,W]=size(L_original);
    %% Diameter of cell calculation and estimate heigth of cell and 'lumen'
    mask=L_original;
    for j=1:length(border_cells)
        mask(L_original==border_cells(j))=0;
    end
    majorAxis=regionprops(mask,'majorAxis');
    majorAxis=cat(1,majorAxis.MajorAxisLength);
    majorAxis=majorAxis(majorAxis~=0);
    majorAxisMean=mean(majorAxis);
    
    heigthVoronoiCell=2*majorAxisMean;
    lumenRadius2=heigthVoronoiCell/2;
    lumenRadius1=heigthVoronoiCell;
        
    %% Curvature implication - recalculate seeds and labelled images
    curvature2=lumenRadius2/(lumenRadius2+heigthVoronoiCell);
    curvature1=lumenRadius1/(lumenRadius1+heigthVoronoiCell);
        
    seedsBasal=sortrows(seeds_values_before,1);
    seedsApical2=[seedsBasal(:,1:2),round(seedsBasal(:,3)*curvature2)];
    seedsApical1=[seedsBasal(:,1:2),round(seedsBasal(:,3)*curvature1)];

    L_originalApical2=generateCylindricalVoronoi(seedsApical2,H,round(W*curvature2));
    L_originalApical1=generateCylindricalVoronoi(seedsApical1,H,round(W*curvature1));

    %% Representations
    seeds_values_before=sortrows(seeds_values_before,1);
    numCells=size(seeds_values_before,1);

    name2save=pathV5data(i).name;
    name2save=name2save(1:end-16);
    
    representAndSaveFigureWithColourfulCells(L_original,numCells,seeds_values_before(:,2:3),directory2save,name2save,'_basal')
    representAndSaveFigureWithColourfulCells(L_originalApical2,numCells,seedsApical2(:,2:3),directory2save,name2save, '_apical2')
    representAndSaveFigureWithColourfulCells(L_originalApical1,numCells,seedsApical1(:,2:3),directory2save,name2save, '_apical1')
 
      
    %% Distance matrix between Centroids of Neighbors using adjacency matrix
    [distanceMatrixNeighsBasal, adjacencyMatrixBasal,distanceMatrixBasalGeneral]=calculateDistanceMatrixInVoronoi3D(new_seeds_values,L_original,W);
    [distanceMatrixNeighsApical2, adjacencyMatrixApical2,distanceMatrixApical2General]=calculateDistanceMatrixInVoronoi3D(seedsApical2,L_originalApical2,round(W*curvature2));
    [distanceMatrixNeighsApical1, adjacencyMatrixApical1,distanceMatrixApical1General]=calculateDistanceMatrixInVoronoi3D(seedsApical1,L_originalApical1,round(W*curvature1));

    %% Testing neighs exchanges
    [ numberOfTransitionsBasApi2,nWinBasApi2,nLossBasApi2 ] = testingNeighsExchange(L_original,L_originalApical2);
    [ numberOfTransitionsBasApi1,nWinBasApi1,nLossBasApi1 ] = testingNeighsExchange(L_original,L_originalApical1);

    
    save([directory2save name2save '\' name2save '.mat'],'heigthVoronoiCell','seedsApical1','seedsApical2','seedsBasal','curvature1','curvature2','lumenRadius1','lumenRadius2','majorAxisMean','L_originalApical1','L_originalApical2','L_original','distanceMatrixNeighsBasal','adjacencyMatrixBasal','distanceMatrixBasalGeneral','distanceMatrixNeighsApical2','adjacencyMatrixApical2','distanceMatrixApical2General','distanceMatrixNeighsApical1','adjacencyMatrixApical1','distanceMatrixApical1General','numberOfTransitionsBasApi1','nWinBasApi1','nLossBasApi1','numberOfTransitionsBasApi2','nWinBasApi2','nLossBasApi2')
    
    close all
    
    
end