function [totalImages] = unrollingHypocot(folder,name,rangeY,layer1,layer2)

        setOfImages = {layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface};
        totalImages = cell(length(setOfImages),1);
        c=colorcube(max([max(layer1.outerSurface(:)),max(layer2.outerSurface(:))]));
        orderRand=randperm(max([max(layer1.outerSurface(:)),max(layer2.outerSurface(:))]));
        c(orderRand(1),:)=[0 0 0];

        uniqueOuter2 = unique(layer2.outerSurface) ;
        uniqueInner2 = unique(layer2.innerSurface) ;
        noValidCells=setdiff(uniqueInner2,uniqueOuter2);

        setLayerNames = {'outerMaskLayer1','innerMaskLayer1','outerMaskLayer2','innerMaskLayer2'};
        
        for nImg = 1 : length(setOfImages)
            img3d = setOfImages{nImg};
            
            axesLength = regionprops3(img3d>0,'PrincipalAxisLength');
            [~,orderLengAxis] = sort(cat(1,axesLength.PrincipalAxisLength));

            img3d=permute(img3d,orderLengAxis);
            img3d(ismember(img3d,noValidCells))=0;

            load([folder name '\maskLayers\certerAndRadiusPerZ.mat'],'centers')

            imgFinalCoordinates=cell(size(img3d,3),1);
            centroids=centers{nImg};

            for coordZ = 1 : size(img3d,3)
                centroidCoordZ = centroids{rangeY(1)-1+coordZ};
                centroidX = centroidCoordZ(3);
                centroidY = centroidCoordZ(1);

                %% Create perimeter mask               
                mask=false(size(img3d(:,:,1)));
                mask(img3d(:,:,coordZ)>0)=1;
                [x,y]=find(mask);

                zPerimMask = imread([folder name '\maskLayers\' setLayerNames{nImg} '\' num2str(rangeY(1)-1+coordZ) '.bmp']);
                zPerimMask=bwperim(zPerimMask);
                [xPerim,yPerim]=find(zPerimMask);

                %angles coord perim regarding centroid
                anglePerimCoord = atan2(yPerim - centroidY, xPerim - centroidX);
                %find the sorted order
                [anglePerimCoordSort,~] = sort(anglePerimCoord);

                %% labelled mask
                maskLabel=img3d(:,:,coordZ);
                %angles label coord regarding centroid
                angleLabelCoord = atan2(y - centroidY, x - centroidX);

                %% Assing label to pixels of perimeters
                %If a perimeter coordinate have no label pixels in a range of pi/45 radians, it label is 0
                orderedLabels = zeros(1,length(anglePerimCoordSort));
                for nCoord = 1:length(anglePerimCoordSort)
                    [M,ind]=min(abs(angleLabelCoord - anglePerimCoordSort(nCoord)));
                    if M < pi/135
                        orderedLabels(nCoord)=maskLabel(x(ind(1)),y(ind(1)));
                    else
                        orderedLabels(nCoord)=0;
                    end
                end

                imgFinalCoordinates{coordZ} = orderedLabels;

            end

            %% Reconstruct deployed img
            ySize=max(cellfun(@length, imgFinalCoordinates));
            deployedImg = zeros(size(img3d,3),ySize);

            for coordZ = 1 : size(img3d,3)
                rowOfCoord = imgFinalCoordinates{coordZ};
                nEmptyPixels = 0;
                if length(rowOfCoord) < ySize
                    nEmptyPixels = floor((ySize - length(rowOfCoord)) / 2);
                end
                deployedImg(coordZ, 1 + nEmptyPixels : length(rowOfCoord) + nEmptyPixels) = rowOfCoord;
            end

                    figure;imshow(deployedImg,c(orderRand,:))
            totalImages{nImg} = deployedImg;

        end
    
    
end

