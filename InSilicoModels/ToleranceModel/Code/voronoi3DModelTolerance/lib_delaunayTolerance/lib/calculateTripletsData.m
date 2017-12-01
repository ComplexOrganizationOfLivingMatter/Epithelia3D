function [ tripletsData,seedsX2,allPairs] = calculateTripletsData( tripletsOfNeighs,new_seeds_values, border_cells ,W)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    %%Calculate matrix distance between future joined centroids
    seeds=sortrows(new_seeds_values);
    seeds=seeds(:,2:3);
    n_seeds=size(seeds,1);
        
    %Duplicate image to calculate real distances between seeds and
    %coordenates in triplets
    aux_seeds=seeds;
    aux_seeds(:,2)=aux_seeds(:,2)+W;
    seedsX2=[seeds;aux_seeds];
    D=pdist(seedsX2);
    distanceMatrix_X2=squareform(D);
        
    %This trick treats in taking the shortest distance between neighbours
    %comparing with both distanceMatrix.
    fields={'Triplets','firstEdge','distanceFirstEdge','secondEdge','distanceSecondEdge','thirdEdge','distanceThirdEdge','first_node','first_node_XY','second_node','second_node_XY','third_node','third_node_XY'};
    tripletsDataCell={};
    allPairs=[];
    for i=1:size(tripletsOfNeighs,1)
        
        %filtering to add real seed indexes to triangles
        if (sum(ismember(tripletsOfNeighs(i,:),border_cells)>0))
               if (sum(seedsX2(tripletsOfNeighs(i,:),2)> (W/2))<3 && sum(seedsX2(tripletsOfNeighs(i,:),2)> (W/2))>0)
                   for j=1:size(tripletsOfNeighs,2)
                       if((seedsX2(tripletsOfNeighs(i,j),2)<(W/2))>0)
                           tripletsOfNeighs(i,j)=tripletsOfNeighs(i,j)+size(seeds,1);
                       end
                   end
                       
               end
        end
        
        seed1_2=tripletsOfNeighs(i,[1,2]);        
        seed1_3=tripletsOfNeighs(i,[1,3]);
        seed2_3=tripletsOfNeighs(i,[2,3]);
        
        coord1=seedsX2(seed1_2(1),:);
        coord2=seedsX2(seed2_3(1),:);
        coord3=seedsX2(seed1_3(2),:);
        
        allPairs=[allPairs;seed1_2;seed2_3;seed1_3];
        
        distSeed1_2=distanceMatrix_X2(seed1_2(1),seed1_2(2));
        distSeed1_3=distanceMatrix_X2(seed1_3(1),seed1_3(2));
        distSeed2_3=distanceMatrix_X2(seed2_3(1),seed2_3(2));
        
        tripletsDataCell(i,1:13)={tripletsOfNeighs(i,1:3),seed1_2,distSeed1_2,seed1_3,distSeed1_3,seed2_3,distSeed2_3,tripletsOfNeighs(i,1),coord1,tripletsOfNeighs(i,2),coord2,tripletsOfNeighs(i,3),coord3};
    end
    
    tripletsData=cell2struct(tripletsDataCell',fields,1);
    
    
   allPairs=unique(allPairs,'rows');



end

