%pipeline

path3dVoronoi='D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\External cylindrical voronoi\';
directory2save='..\..\data\';
addpath('lib')

pathV5data=dir([path3dVoronoi '*_5_V*']);

listOfSurfaceReduction=0.1:0.1:1;
for i=1:size(pathV5data,1)
    
    listTransitionsByCurvature=[];
    listSeedsApical={};
    listLOriginalApical={};
    
    load([path3dVoronoi pathV5data(i).name])

    [H,W]=size(L_original);
    %% Diameter of cell calculation and estimate heigth of cell and 'lumen'
    mask=L_original;
    for j=1:length(border_cells)
        mask(L_original==border_cells(j))=0;
    end
    
    for j=1:length(listOfSurfaceReduction)

        

        %% Curvature implication - recalculate seeds and labelled images
        curvature=listOfSurfaceReduction(j);

        seedsBasal=sortrows(seeds_values_before,1);
        seedsApical=[seedsBasal(:,1:2),round(seedsBasal(:,3)*curvature)];

        L_originalApical=generateCylindricalVoronoi(seedsApical,H,round(W*curvature));

        %% Representations
        seeds_values_before=sortrows(seeds_values_before,1);
        numCells=size(seeds_values_before,1);

        name2save=pathV5data(i).name;
        name2save=name2save(1:end-16);

        if j==1
            representAndSaveFigureWithColourfulCells(L_original,numCells,seeds_values_before(:,2:3),directory2save,name2save,'_basal')
        end
        representAndSaveFigureWithColourfulCells(L_originalApical,numCells,seedsApical(:,2:3),directory2save,name2save, ['_apical_' num2str(curvature) '_reduction'])


%         %% Distance matrix between Centroids of Neighbors using adjacency matrix
%         [distanceMatrixNeighsBasal, adjacencyMatrixBasal,distanceMatrixBasalGeneral]=calculateDistanceMatrixInVoronoi3D(new_seeds_values,L_original,W);
%         [distanceMatrixNeighsApical, adjacencyMatrixApical,distanceMatrixApical1General]=calculateDistanceMatrixInVoronoi3D(seedsApical,L_originalApical,round(W*curvature));

        %% Testing neighs exchanges
        [numberOfTransitionsBasApi,nWinBasApi,nLossBasApi] = testingNeighsExchange(L_original,L_originalApical);


        listTransitionsByCurvature(end+1,:)=[curvature,nWinBasApi,nLossBasApi,numberOfTransitionsBasApi];
        listSeedsApical{end+1,1}=curvature;listSeedsApical{end,2}=seedsApical;
        listLOriginalApical{end+1,1}=curvature;listLOriginalApical{end,2}=L_originalApical;
        close all


    end
    
    listTransitionsByCurvature=array2table(listTransitionsByCurvature);
    listTransitionsByCurvature.Properties.VariableNames{1} = 'reductionProportion';
    listTransitionsByCurvature.Properties.VariableNames{2} = 'nWins';
    listTransitionsByCurvature.Properties.VariableNames{3} = 'nLoss';
    listTransitionsByCurvature.Properties.VariableNames{4} = 'nTransitions';
    
    listSeedsApical=cell2table(listSeedsApical);
    listSeedsApical.Properties.VariableNames{1} = 'reductionProportion';
    listSeedsApical.Properties.VariableNames{2} = 'seedsApical';
    
    listLOriginalApical=cell2table(listLOriginalApical);
    listLOriginalApical.Properties.VariableNames{1} = 'reductionProportion';
    listLOriginalApical.Properties.VariableNames{2} = 'L_originalApical';
    
    save([directory2save name2save '\' name2save '.mat'],'seedsBasal','L_original','listLOriginalApical','listSeedsApical','listTransitionsByCurvature')

end