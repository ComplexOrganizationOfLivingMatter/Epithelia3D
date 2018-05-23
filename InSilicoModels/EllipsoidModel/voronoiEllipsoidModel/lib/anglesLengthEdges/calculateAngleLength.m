function [anglesEdge, lengthEdge] = calculateAngleLength(neigh1,neigh2,ellipsoidInfo)


    coordinatesCell1=ellipsoidInfo.cellDilated{neigh1};
    coordinatesCell2=ellipsoidInfo.cellDilated{neigh2};
    
    sharedCoordIndex=ismember(coordinatesCell1,coordinatesCell2,'rows');
    
    sharedCoordinates=coordinatesCell1(sharedCoordIndex,:,:);
    
    indexesMask=sub2ind(size(mask3D),sharedCoordinates(:,1),sharedCoordinates(:,2),sharedCoordinates(:,3));
    
    mask3D=zeros(size(ellipsoidInfo.img3DLayer));
    mask3D(indexesMask)=1;
    
    propsEdge=regionprops3(mask3D,'PrincipalAxisLength','Orientation');
    
    anglesEdge=cat(1,propsEdge.Orientation);
    lengthEdge=cat(1,propsEdge.PrincipalAxisLength);
    
end

