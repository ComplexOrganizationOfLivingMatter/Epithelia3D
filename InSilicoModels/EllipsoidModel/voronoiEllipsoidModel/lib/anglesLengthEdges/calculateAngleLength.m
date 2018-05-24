function [ellipsoidInfo] = calculateAngleLength(ellipsoidInfo)
    
    if ~isfield(ellipsoidInfo,'neighbourhood')
        ellipsoidInfo=calculate_neighbours3D(ellipsoidInfo.img3DLayer,ellipsoidInfo);
    end
    neighs=ellipsoidInfo.neighbourhood;
    totalPairs=cellfun(@(x, y) [y*ones(length(x),1),x],neighs,num2cell(1:length(neighs))','UniformOutput',false);
    totalPairs=unique(vertcat(totalPairs{:}),'rows');
    totalPairs=unique([min(totalPairs,[],2),max(totalPairs,[],2)],'rows');   

    angleLengthEdge = cell(size(totalPairs,1),5);

    for i = 1 : size(totalPairs,1)

        coordinatesCell1=ellipsoidInfo.cellDilated{totalPairs(i,1)};
        coordinatesCell2=ellipsoidInfo.cellDilated{totalPairs(i,2)};
        sharedCoordIndex=ismember(coordinatesCell1,coordinatesCell2,'rows');
        sharedCoordinates=coordinatesCell1(sharedCoordIndex,:);

        mask3D=false(size(ellipsoidInfo.img3DLayer));
        indexesMask=sub2ind(size(mask3D),sharedCoordinates(:,1),sharedCoordinates(:,2),sharedCoordinates(:,3));
        mask3D(indexesMask)=1;
        
        shp=alphaShape(double(sharedCoordinates(:,1)),double(sharedCoordinates(:,2)),double(sharedCoordinates(:,3)));
        figure;plot(shp);
                

%         maskSkel=bwskel(logical(mask3D));
%         maskSkelOpen=bwareaopen(maskSkel,4,26);
%         CC = bwconncomp(maskSkelOpen,26);
        
        maskSkel=bwskel(mask3D,'MinBranchLength',8);
        indCoord=find(maskSkel);
        [x,y,z]=ind2sub(size(maskSkel),indCoord);
        lengthEdge=max(pdist([x,y,z]));
        figure;plot3(x,y,z,'o')
         
        propsEdge=regionprops3(maskSkel,'PrincipalAxisLength','Orientation','Centroid');

%         [x,y,z]=ind2sub(size(mask3),indSkel);
%         plot3(x,y,z,'o')
        

        anglesEdge=cat(1,propsEdge.Orientation);
        centroidCoord=cat(1,propsEdge.Centroid);            
        principalAxisLength=cat(1,propsEdge.PrincipalAxisLength);

        angleLengthEdge{i,1}=totalPairs(i,:);
        angleLengthEdge{i,2}=anglesEdge;
        angleLengthEdge{i,3}=lengthEdge;
        angleLengthEdge{i,4}=centroidCoord;
        angleLengthEdge{i,5}=principalAxisLength;
        
    end
    
    tableEdges=cell2table(angleLengthEdge,'VariableNames',{'idCells' 'angleEdge' 'lengthEdge' 'centroid' 'principalAxesLength'});
    
    ellipsoidInfo.edgesOrientation=tableEdges;
    
    
    
end

