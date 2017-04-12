function [tolerance] = calculateEdgeTolerance( Img,sides_cells)
    
    %Calculate centroids
    centroids=regionprops(Img,'Centroid');
    centroids=cat(1,centroids.Centroid);
    
    cells3neig=find(sides_cells==3);
    cells2neig=find(sides_cells==2);
    
    %distance between couples of centroids. These couples are needed to
    %develop the imaginary circles.
    distEdge1=pdist([centroids((cells3neig(1)),:);centroids((cells3neig(2)),:)]);
    distEdge2=pdist([centroids((cells2neig(1)),:);centroids((cells2neig(2)),:)]);

    tolerance=abs(distEdge1-distEdge2)/2;
        
end

