function [maskNewCyl] = extrapolate3DCylinder2Dplane(img3D,radii,centers,hType)
    

    [allX,allY,allZ]=ind2sub(size(img3D),find(img3D>0));
    radiusAverage=round(mean(vertcat(radii{:})));
    
    maskNewCyl=zeros(ceil(2*pi*radiusAverage),max(allY));
    maskInd=zeros(ceil(2*pi*radiusAverage),max(allY));

    for nInd = 1 : length(allX)
        
        %3D to 2D by angle
        centroidYCircle=centers{allY(nInd)};
        if contains(hType,'B')
           angleWithCentroid = atan2d((allZ(nInd)-centroidYCircle(1)),(allX(nInd)-centroidYCircle(3)));       
        else
           angleWithCentroid = atan2d((allZ(nInd)-centroidYCircle(3)),(allX(nInd)-centroidYCircle(1)));
        end
        newX=ceil(deg2rad(wrapTo360(angleWithCentroid))*radiusAverage);
        newY=allY(nInd);
        
        %if the image possition is busy, choose the longest
        if maskNewCyl(newX,newY)==0
            maskNewCyl(newX,newY)=img3D(allX(nInd),allY(nInd),allZ(nInd));
            maskInd(newX,newY)=nInd;
        else
            newDist=pdist2(centroidYCircle,[allX(nInd),allY(nInd),allZ(nInd)]);
            oldDist=pdist2(centroidYCircle,[allX(maskInd(newX,newY)),allY(maskInd(newX,newY)),allZ(maskInd(newX,newY))]);
            
            if newDist > oldDist
                maskNewCyl(newX,newY)=img3D(allX(nInd),allY(nInd),allZ(nInd));
                maskInd(newX,newY)=nInd;
            end
            
        end
%         figure;imshow(maskNewCyl)
%         close all
    end

    
end

