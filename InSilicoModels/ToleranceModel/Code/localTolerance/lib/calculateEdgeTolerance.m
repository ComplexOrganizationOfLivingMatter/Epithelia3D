function [tolerance] = calculateEdgeTolerance( Img,cell1,cell2,cell3,cell4 )


    %Gel only 4 cells neighborhood image
    mask=Img;
    mask1=mask;mask2=mask;mask3=mask;mask4=mask;
    mask1(mask~=cell1)=0;
    mask2(mask~=cell2)=0;
    mask3(mask~=cell3)=0;
    mask4(mask~=cell4)=0;
    mask=mask1+mask2+mask3+mask4;
    
    %Calculate neighbours
    [neighs_real,sides_cells]=calculate_neighbours(mask);
    centroids=regionprops(mask,'Centroid');
    centroids=cat(1,centroids.Centroid);
    
    cells3neig=find(sides_cells==3);
    cells2neig=find(sides_cells==2);
    
    %distance between couples of centroids. These couples are needed to
    %develop the imaginary circles.
    distEdge1=pdist([centroids((cells3neig(1)),:);centroids((cells3neig(2)),:)]);
    distEdge2=pdist([centroids((cells2neig(1)),:);centroids((cells2neig(2)),:)]);

    tolerance=abs(distEdge1-distEdge2)/2;
    
end

