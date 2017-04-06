function [ tripletsData ] = lookForNeighSeedsToSquare( tripletsData,seedsX2,neighbours,border_cells, W)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

   
    triplets=cat(1,tripletsData.Triplets);
    neigh_aux=[neighbours,neighbours];
    nodesToSquare={};
    coordNodeSquarCel={};
    neighFirstPair={};
    neighSecondPair={};
    neighThirdPair={};
    
    
    for i=1:size(triplets,1)
        
        trian=triplets(i,:);
        triplet_aux=trian;
        triplet_aux(triplet_aux>length(neighbours))=triplet_aux(triplet_aux>length(neighbours))-length(neighbours);
        
        negh1_pair=intersect(neigh_aux{trian(1)},neigh_aux{trian(2)});
        negh1_pair=negh1_pair(negh1_pair~=triplet_aux(3));
        negh2_pair=intersect(neigh_aux{trian(1)},neigh_aux{trian(3)});
        negh2_pair=negh2_pair(negh2_pair~=triplet_aux(2));
        negh3_pair=intersect(neigh_aux{trian(2)},neigh_aux{trian(3)});
        negh3_pair=negh3_pair(negh3_pair~=triplet_aux(1));
       
        
        neighFirstPair(i)={negh1_pair};
        neighSecondPair(i)={negh2_pair};
        neighThirdPair(i)={negh3_pair};
        
        nodesNeigTri=[negh1_pair;negh2_pair;negh3_pair]';
        
        nodesToSquare(i,1)={nodesNeigTri};
        coordNodeSquar=seedsX2(nodesNeigTri,:);
%         coordNodeSquar=unique(coordNodeSquar,'rows','stable');
        coordNodeSquarY=coordNodeSquar(:,2);
        
            if sum(ismember(triplet_aux,border_cells))>0 || sum(ismember(nodesNeigTri,border_cells))>0
                if sum(seedsX2(trian,2)> (W/2))==3
                    coordNodeSquarY(coordNodeSquarY<(W/2))=coordNodeSquarY(coordNodeSquarY<(W/2))+W;
                elseif sum(seedsX2(trian,2)>(W/2))==0
                    coordNodeSquarY(coordNodeSquarY>(W/2))=coordNodeSquarY(coordNodeSquarY>(W/2))-W;
                elseif sum(seedsX2(trian,2)>(W/2))>0 && sum(seedsX2(nodesNeigTri,2)>(W/2))==0
                    coordNodeSquarY(coordNodeSquarY<(W/2))=coordNodeSquarY(coordNodeSquarY<(W/2))+W;
                elseif sum(seedsX2(trian,2)<(W/2))>0 && sum(seedsX2(nodesNeigTri,2)>(W/2))>0
                    coordNodeSquarY(coordNodeSquarY>(W/2))=coordNodeSquarY(coordNodeSquarY>(W/2))-W;
                end
                coordNodeSquar(:,2)=coordNodeSquarY;
            end



            listEmpty=[isempty(negh1_pair),isempty(negh2_pair),isempty(negh3_pair)];
            acum=1;
            for k=1:length(listEmpty);

                if(listEmpty(k)==0)
%                     negh1_pair
%                     negh2_pair
%                     negh3_pair
%                     coordNodeSquar
                    coordNodeSquarCel{i,k}=coordNodeSquar(acum,:);
                    acum=acum+1;
                end

            end
        
        
    end
        

    
    [tripletsData.NodesToSquare]=nodesToSquare{:};
    [tripletsData.NeighFirstEdge]=neighFirstPair{:};
    [tripletsData.CoordNode1ToSquare]=coordNodeSquarCel{:,1};
    [tripletsData.NeighSecondEdge]=neighSecondPair{:};
    [tripletsData.CoordNode2ToSquare]=coordNodeSquarCel{:,2};
    [tripletsData.NeighThirdEdge]=neighThirdPair{:};
    [tripletsData.CoordNode3ToSquare]=coordNodeSquarCel{:,3};

end

