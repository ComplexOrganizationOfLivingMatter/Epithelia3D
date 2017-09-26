function [LayerCentroid, trackingCentroid, finalCentroid] = sameCentroid( pathArchMat, initialFrame, maxFrame)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Variables
load(pathArchMat);
numCell=1;
repeatCentroid=1;

%Etiquetas a cada célula
for numFrame=initialFrame:maxFrame
    for numLayer=1:size(LayerCentroid)
        for numCentroidLayer= 1:size(LayerCentroid{numLayer,1})
            if LayerCentroid{numLayer,1}(numCentroidLayer, 1)==numFrame
                LayerCentroid{numLayer,1}(numCentroidLayer, 4)=numCell;
                numCell=numCell+1;             
            end
        end
    end   
end

%Seguimiento de una misma célula
for numFrame=initialFrame+1:maxFrame
    oldCentroid=ismember(round(centroids{numFrame}), pixel{numFrame-1},'rows');
    trackingCentroid{numFrame,1}=zeros(size(centroids{numFrame,1},1),6);
    for numCentroid=1:size(centroids{numFrame,1},1)
        if oldCentroid(numCentroid)==1
            matDis = pdist2(centroids{numFrame,1}(numCentroid, :), centroids{numFrame-1,1});  
            Ind=find(matDis==min(matDis));
            trackingCentroid{numFrame,1}(numCentroid,:)=[  centroids{numFrame-1,1}(Ind,:), numFrame-1, centroids{numFrame,1}(numCentroid, :), numFrame];
        
            
        end
    end
end
field1='ID';
field2='Centroid';
n=1;
% for numFrame=initialFrame:maxFrame
%     for numCentroid=1:size(centroids{numFrame,1},1)
%         finalCentroid{numFrame,1}(numCentroid,:)=[n,centroids{numFrame,1}(numCentroid,:)];
%         n=n+1;
%     end
% end

for numLayer=1:size(LayerCentroid)
    for numCentroidLayer=1:size(LayerCentroid{numLayer,1})
        coord=[LayerCentroid{numLayer,1}(numCentroidLayer,2), LayerCentroid{numLayer,1}(numCentroidLayer,3), LayerCentroid{numLayer,1}(numCentroidLayer,1)];
        finalCentroid{n,1}=LayerCentroid{numLayer,1}(numCentroidLayer,4);
        finalCentroid{n,2}=coord;
        n=n+1;
    end
end

for numFrame=initialFrame+1:maxFrame
    for numCentroid=1:size(centroids{numFrame,1},1)
        if trackingCentroid{numFrame,1}(numCentroid,1)~=0
            
                
                [cen, index] =ismember(trackingCentroid{numFrame,1}(numCentroid,1:3),vertcat(finalCentroid{:,2}), 'rows');
                
                    if cen==1
                        finalCentroid{end+1,1}(1,1)=finalCentroid{index,1}(1,1);
                        finalCentroid{end,2}(1,1:3)=trackingCentroid{numFrame,1}(numCentroid,4:6);
                        
                    end
                
        end
    end
end
% for numFrame=initialFrame:maxFrame
%     for numLayer=1:size(LayerCentroid)        
%         for numCentroidLayer=1:size(LayerCentroid{numLayer,1})
%             if LayerCentroid{numLayer,1}(numCentroidLayer, 1)==numFrame
%                 LayerCentroid{numLayer,1}(numCentroidLayer, 2:3)== trackingCentroid{numFrame,1}(numCentroid, )
%             end
%         end
%         
%     end
% end

finalCentroid=sortrows(finalCentroid, 1);
end

