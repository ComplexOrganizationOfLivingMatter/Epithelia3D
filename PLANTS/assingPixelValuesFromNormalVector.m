function labelMask = assingPixelValuesFromNormalVector(mask,imgLayer,typeLayer)

    cent = regionprops(mask,'Centroid');
    cent = [cent.Centroid(2) cent.Centroid(1)];
    
    perimMask = bwperim(mask);
    [allY,allX] = find(perimMask);
    labelMask = uint16(zeros(size(perimMask)));
    [H,W]=size(perimMask);
    
    for nPx = 1 : length(allY)
        xPx = allX(nPx);
        yPx = allY(nPx);
        
        if imgLayer(xPx,yPx) == 0
        
            % Create a line from point 1 to point 2
            spacing = 0.4;
            expandedxPx=xPx+(xPx-cent(1));
            expandedyPx=yPx+(yPx-cent(2));
            
            numSamples = ceil(sqrt((expandedxPx-cent(1))^2+(expandedyPx-cent(2))^2) / spacing);
            x = linspace(cent(1), expandedxPx, numSamples);
            y = linspace(cent(2), expandedyPx, numSamples);
            xy = round([x',y']);
            dxy = abs(diff(xy, 1));
            duplicateRows = [0; sum(dxy, 2) == 0];

            finalXY = xy(~duplicateRows,:);
            
            %delimite pixels into the image
            ind = (finalXY(:,2) > 0 & finalXY(:,2) < H) & (finalXY(:,1) > 0 & finalXY(:,1) < W);
            finalX = finalXY(ind, 1);
            finalY = finalXY(ind, 2);
            
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
                labelMask(xPx,yPx) = 0;
            end
        else
            labelMask(yPx,xPx) = imgLayer(yPx,xPx);
        end
        
    end
end