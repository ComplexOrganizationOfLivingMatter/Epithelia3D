function [tableVerticesConnection2D,tableVerticesCoord2D]=extrapolateVerticesCyl2D(tableVerticesConnection,tableVerticesCoord,centers,rangeY,radii)

    radiusAverage=round(mean(vertcat(radii{rangeY(1):rangeY(2)})));
%     sizeImage=[2*pi*radiusAverage,rangeY(2)-rangeY(1)];
%     a=radiusAverage+1;
%     b=radiusAverage+1;

    tableVerticesCoord2D=zeros(size(tableVerticesCoord,1),3);
    
    for i = 1:size(tableVerticesCoord,1)
        coordVert=tableVerticesCoord{i,:};
        
        if coordVert(3)>=rangeY(1) && coordVert(3)<=rangeY(2)
            centroidY=centers{coordVert(3)};
            angleWithCentroid = atan2d((coordVert(4)-centroidY(3)),(coordVert(2)-centroidY(1)));
            
            newX=round(deg2rad(wrapTo360(angleWithCentroid))*radiusAverage);
            newY=coordVert(3)-rangeY(1)+1;
%             newXcyl = a+radiusAverage*cosd(angleWithCentroid);
%             newYcyl = b+radiusAverage*sind(angleWithCentroid);
            
            
            
            tableVerticesCoord2D(i,:) = [tableVerticesCoord{i,1},newX,newY];
        end

    end

    vertIDsOutRange=find(cellfun(@(x) sum(x==0)>0,mat2cell(tableVerticesCoord2D,ones(size(tableVerticesCoord2D,1),1),3)));
    
    arrayVertConn=table2array(tableVerticesConnection);
    [indX,~]=find(ismember(arrayVertConn,vertIDsOutRange));
    tableVerticesConnection2D=tableVerticesConnection;
    tableVerticesConnection2D(unique(indX),:)=[];
    [~,indUnique]=unique(sort(table2array(tableVerticesConnection2D),2),'rows');    
    tableVerticesConnection2D=tableVerticesConnection2D(indUnique,:);
    tableVerticesCoord2D=array2table([[1:max(tableVerticesCoord2D(:,1))]',tableVerticesCoord2D(1:max(tableVerticesCoord2D(:,1)),2),tableVerticesCoord2D(1:max(tableVerticesCoord2D(:,1)),3)],'VariableNames',{'verticeID','coordX','coordY'});
end