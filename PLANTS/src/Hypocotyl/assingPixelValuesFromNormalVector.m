function labelMask = assingPixelValuesFromNormalVector(mask,imgLayer,typeLayer)

    cent = regionprops(mask,'Centroid');
    cent = cent.Centroid(:)';
    
    perimMask = bwperim(mask);
    [allY,allX] = find(perimMask);
    labelMask = uint16(zeros(size(perimMask)));
    [H,W]=size(perimMask);
    for nPx = 1 : length(allY)
        xPx = allX(nPx);
        yPx = allY(nPx);
        
        if imgLayer(yPx,xPx) == 0
        
            % Create a line from point 1 to point 2
            spacing = 0.4;
            expandedxPx=xPx+(xPx-cent(1))/5;
            expandedyPx=yPx+(yPx-cent(2))/5;
            
            [x, y] = Drawline2D(cent(1), cent(2), expandedxPx, expandedyPx);
            finalXY = unique(round([x',y']),'rows');
            
            %delimite pixels into the image
            ind = (finalXY(:,2) > 0 & finalXY(:,2) < H) & (finalXY(:,1) > 0 & finalXY(:,1) < W);
            finalX = finalXY(ind, 1);
            finalY = finalXY(ind, 2);
%             figure;imshow(imgLayer,colorcube(4500))
%             hold on; plot(finalX,finalY,'*')
%             
%             close all
            indicesRow = sub2ind(size(perimMask),finalY,finalX);
            labelIndices = imgLayer(indicesRow);
            validLabels = labelIndices~=0;
            if sum(validLabels)>0
                finalX = finalX(validLabels);
                finalY = finalY(validLabels);
                if strcmp(typeLayer,'outer')==1
                   [~,ind]= min(pdist2([xPx,yPx],[finalX,finalY]));
                else
                   [~,ind]= min(pdist2(cent,[finalX,finalY]));
                end
                labelMask(yPx,xPx) = imgLayer(finalY(ind),finalX(ind));
            else
                labelMask(yPx,xPx) = 0;
            end
        else
            labelMask(yPx,xPx) = imgLayer(yPx,xPx);
        end
        
    end
end