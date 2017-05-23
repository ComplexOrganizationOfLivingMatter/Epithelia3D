function [ cellTolerances, trianTolerances ] = triangulationDelaunyGettingTolerance( new_seeds_values, border_cells, L_img,pathToSaveData)
% %UNTITLED2 Summary of this function goes here
% %   Detailed explanation goes here

    addpath 'lib_delaunayTolerance\lib'
    [neighbours,~]=calculate_neighbours(L_img);

    [H,W]=size(L_img);

    %% Building triplets of neighbors to develop Delaunay triangulation
    tripletsOfNeighs  = buildTripletsOfNeighs( neighbours );

    %% Extract triplets data
     [tripletsData,seedsX2,allPairs] = calculateTripletsData(tripletsOfNeighs,new_seeds_values,border_cells,W);
    
    %% Calculate neighs of edges
    [ tripletsData ] = lookForNeighSeedsToSquare( tripletsData,seedsX2,neighbours,border_cells,W);   

    %% Get tolerances. create circumscribed circumference from triangles and calculate tolerance
    [tripletsData]=tolerancesFromCincumferences(tripletsData);
    
    %% Get tolerance for each triangle and cell.
    [cellTolerances,trianTolerances] = calculatedToleranceForEachCell(tripletsData,new_seeds_values);
    
    
    %% Save tripletsData
    save(pathToSaveData,'tripletsData','cellTolerances','trianTolerances','-append') 

    
    
%     %% Represent tolerances and triangulations
%     figure;image([L_img,L_img]);
%     axis([-100 2*W 1 H])
%     hold on, 
%     
%     allDots=[vertcat(tripletsData.CoordNode1ToSquare);vertcat(tripletsData.CoordNode2ToSquare);vertcat(tripletsData.CoordNode3ToSquare)];
%     for i=1:size(allDots,1)
%             plot(allDots(i,2),allDots(i,1),'*r');
%         if i<=size(allPairs,1)
%             plot([seedsX2(allPairs(i,1),2),seedsX2(allPairs(i,2),2)],[seedsX2(allPairs(i,1),1),seedsX2(allPairs(i,2),1)],'-b');      
%         end
%     end
%     
%     hold off
%     
%     %%Colourful triangles tolerances 
%     numColor=64;
%     
%     tolNorm=trianTolerances/max(trianTolerances);
%     figure;
%     auxImg=L_img;
%     auxImg(auxImg>0)=numColor;
%     image(auxImg);
%     %image(ones(550,550)*numColor)
%     axis([1 W+100 1 H])
%     hold on
%     for i=1:size(tripletsData,1)
%         xy1=tripletsData(i).first_node_XY;
%         xy2=tripletsData(i).second_node_XY;
%         xy3=tripletsData(i).third_node_XY;
%         patch([xy1(2),xy2(2),xy3(2)],[xy1(1),xy2(1),xy3(1)],numColor*tolNorm(i),'FaceAlpha',.8)
%     
%     end
%     
%     colormap(hot(numColor));
%     colorbar
%     hold off
%     
%     %%Colourful cell tolerances 
%     figure;
%     auxImg=L_img;
%     for i=1:length(cellTolerances)
%         auxImg(L_img==i)=cellTolerances(i);
%     end
%     auxImg=auxImg/(max(max(auxImg)));
%     auxImg=auxImg*numColor;
%     image(auxImg)
%     colormap(hot(numColor));
%     colorbar
    
    
   
end

