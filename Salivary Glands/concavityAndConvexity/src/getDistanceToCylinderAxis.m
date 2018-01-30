function [convexityTable]=getDistanceToCylinderAxis(cylinderAxisImg,cellMaskImg,filePath,T)

    %conversor factor micrometers to pixels
    pixels=1024;
    microns=320.5;
	convFactor=pixels/microns;


    %calculate neighbours
    [neighs,~]=calculateNeighbours(cellMaskImg);
    
    %calculate centroids
    centroids=regionprops(cellMaskImg,'Centroid'); %#ok<MRPBW>
    centroids=cat(1,centroids.Centroid); 
    centroids=[centroids(:,2),centroids(:,1)];
    %pairs of neighs
    indCell=1:length(neighs);
    pairNeighs=cellfun(@(x,y) [repmat(y,size(x,1),1),x],neighs,num2cell(indCell),'UniformOutput',false);
    pairNeighs=cat(1,pairNeighs{:,:});
    pairNeighs=[min(pairNeighs,[],2),max(pairNeighs,[],2)];
    pairNeighs=unique(pairNeighs,'rows');
    
    %filter the desired pair of neighs and theirs measured radius
    %get desired pair of neighs
    folders=table2cell(T(:,1));
    pairsIndexes=cell2mat(cellfun(@(x) ~isempty(strfind(x,filePath)),folders,'UniformOutput',false));
    pairsNeighsDesired=table2array(T(pairsIndexes,2:3));
    pairsNeighsDesired=cell2mat(cellfun(@(x) str2num(x),pairsNeighsDesired,'UniformOutput',false));
    pairNeighs=pairNeighs(ismember(pairNeighs,pairsNeighsDesired,'rows'),:);
    %get radius of gland
    glandDiameterMicrons=table2array(T(pairsIndexes,12));
    glandRadiusPixels=(cell2mat(cellfun(@(x) str2num(x),glandDiameterMicrons,'UniformOutput',false))*convFactor)/2;
    
    
    %cylinder axis coordinates
    [axisRow,axisCol]=ind2sub(size(cylinderAxisImg),find(cylinderAxisImg==1));
    
    xDistance=zeros(size(pairNeighs,1),1);
    xDistanceCyl=zeros(size(pairNeighs,1),1);
    yDistance=zeros(size(pairNeighs,1),1);
    cellFilenames=cell(size(pairNeighs,1),1);
    for i=1:size(pairNeighs,1)
              
        %get closest coordinates to cylinder axis from centroids
        distCent=pdist2(centroids(pairNeighs(i,:),:),[axisRow,axisCol]);
        [distCentCylAxis,ia]=min(distCent,[],2);
        closestCoordCylCent1=[axisRow(ia(1)),axisCol(ia(1))];
        closestCoordCylCent2=[axisRow(ia(2)),axisCol(ia(2))];
        
        %get intermediate points between both cylinder axis points, and
        %extrapolate them to the drawn original axis. Necessary to calculate distance along the
        %original cylinder axis.
        intermediateCoordCyl(1,:)=mean([closestCoordCylCent1;closestCoordCylCent2]);%average
        intermediateCoordCyl(2,:)=mean([intermediateCoordCyl(1,:);closestCoordCylCent2]);%1st quartile
        intermediateCoordCyl(3,:)=mean([intermediateCoordCyl(1,:);closestCoordCylCent1]);%3rd quartile
        
        distCenterCoordCyl=pdist2(intermediateCoordCyl,[axisRow,axisCol]);
        [~,ia]=min(distCenterCoordCyl,[],2);
        closestIntermediateCoordCyl(1,:)=[axisRow(ia(1)),axisCol(ia(1))];
        closestIntermediateCoordCyl(2,:)=[axisRow(ia(2)),axisCol(ia(2))];
        closestIntermediateCoordCyl(3,:)=[axisRow(ia(3)),axisCol(ia(3))];
        
        %check intersection between cylinder axis and centroids edge.
        %Necessary to calculate the X distance
        x1=[closestCoordCylCent1(1),closestIntermediateCoordCyl(3,1),closestIntermediateCoordCyl(1,1),closestIntermediateCoordCyl(2,1),closestCoordCylCent2(1)];
        y1=[closestCoordCylCent1(2),closestIntermediateCoordCyl(3,2),closestIntermediateCoordCyl(1,2),closestIntermediateCoordCyl(2,2),closestCoordCylCent2(2)];
        x2=[centroids(pairNeighs(i,1),1),centroids(pairNeighs(i,2),1)];
        y2=[centroids(pairNeighs(i,1),2),centroids(pairNeighs(i,2),2)];
        [rowInters,~]=polyxpoly(x1,y1,x2,y2);
        
        
        %represent edges between centroids and between cylinder axis points
        imshow(cellMaskImg)
        hold on
        mapshow(y1,x1,'Marker','.')
        mapshow(y2,x2,'Marker','.')
        for k=1:length(neighs)
            text(centroids(k,2),centroids(k,1),sprintf('%d',k),'HorizontalAlignment','center','VerticalAlignment','middle','Color',[1 0 0],'FontSize',20);
        end
        print(gcf,'-dbmp',['..\data\' filePath num2str(pairNeighs(i,1)) '-' num2str(pairNeighs(i,2))])
        
        close all
        
        %get distances of centroids in the deployed cylinder.
        disCentCylAxisDeployedCyl=glandRadiusPixels(i)*asin(distCentCylAxis/glandRadiusPixels(i));

        %get [X,Y] coordinates        
        if isempty(rowInters)
            xDistance(i,1)= abs(distCentCylAxis(1)-distCentCylAxis(2));
            xDistanceCyl(i,1)=abs(disCentCylAxisDeployedCyl(1)-disCentCylAxisDeployedCyl(2));
        else
            xDistance(i,1)= abs(distCentCylAxis(1)+distCentCylAxis(2));
            xDistanceCyl(i,1)=abs(disCentCylAxisDeployedCyl(1)+disCentCylAxisDeployedCyl(2));
        end
        yDistance(i,1)= sum([pdist2(closestIntermediateCoordCyl(2,:),[closestIntermediateCoordCyl(1,:);closestCoordCylCent2]),pdist2(closestIntermediateCoordCyl(3,:),[closestIntermediateCoordCyl(1,:);closestCoordCylCent1])]);
        
        

    end
    
    %organize results in table-struct
    cellFilenames(:)={filePath};
    convexityTable.name=cellFilenames;
    convexityTable.label1=pairNeighs(:,1);
    convexityTable.label2=pairNeighs(:,2);
    convexityTable.x=xDistance;
    convexityTable.xCyl=xDistanceCyl;
    convexityTable.y=yDistance;
    convexityTable=struct2table(convexityTable);
end

