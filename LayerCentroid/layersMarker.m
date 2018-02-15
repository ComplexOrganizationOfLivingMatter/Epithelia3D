function [ LayerCentroid, centroids, pixel, xQuery, yQuery, initialFrame, newLayer] = layersMarker( LayerCentroid, centroids, pixel, numFrame, xQuery, yQuery, initialFrame, newLayer)

numLayer=1;
oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %The centroids of the new frame that are in the pixels of the previous one


while any (oldCentroids==0)
    
        x=LayerCentroid{numLayer,1}(:,2);
        y=LayerCentroid{numLayer,1}(:,3);
        
        for n=1:size(centroids{numFrame}(:, 1))
            
            if oldCentroids(n)==0 %So you do not catch repeated ones
                oldCentroids(n) = 1; %When I only take the centroids not repeated (0) I put this number to 1 so that I do not pick it up again in the next repetition
                if size(LayerCentroid{numLayer,1},1)<4 %If there are less than 3 centroids in the layer then that centroid goes directly to that layer
                    [LayerCentroid] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer);
                    
                else    
                    [kLayer{numLayer}]=boundary(x,y,0.7);
                    [inLayer{numLayer},onLayer{numLayer}] = inpolygon(xQuery{numFrame,1},yQuery{numFrame,1},x(kLayer{numLayer}),y(kLayer{numLayer}));
                    
                    if (inLayer{numLayer}(n)==0) || ((inLayer{numLayer}(n)==1) && (numFrame==initialFrame+1))
                        if(inLayer{1}(n)==1)
                            [LayerCentroid] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer);
                        elseif(inLayer{1}(n)==0)
                            [LayerCentroid] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, 1);
                        end
                    elseif (inLayer{numLayer}(n)==1)
                        if numLayer+1 > size(LayerCentroid, 1) %If there is no layer created
                            w=[xQuery{numFrame,1}(n), yQuery{numFrame,1}(n)];
                            LayerCentroid{numLayer+1, 1} = horzcat(numFrame, w);
                            %LayerPixel{numLayer+1, 1} = horzcat(numFrame, w);
                            newLayer=true;
                            
                        elseif newLayer==true %If there is layer created
                            if size(LayerCentroid{numLayer+1,1},1)<51%201
                                [LayerCentroid] = addToLayer( xQuery, yQuery, numFrame, n, LayerCentroid, numLayer+1);
                            else
                                %It should be stored for when layer pass is analyzed and so on
                                oldCentroids(n) = 0; %I put it back to 0 because in the next layer I want you to analyze this centroid again
                            end
                        end
                    end
                end
            end
        end
        numLayer=numLayer+1;
end

end

