function [totalImages] = unrollingHypocot(name,rangeY,layer1,layer2)

        setOfImages = {layer1.outerSurface,layer1.innerSurface,layer2.outerSurface,layer2.innerSurface};
        totalImages = cell(length(setOfImages),1);
        c=colorcube(4500);
        orderRand=randperm(4500);
        c(orderRand(1),:)=[0 0 0];

        uniqueOuter2 = unique(layer2.outerSurface) ;
        uniqueInner2 = unique(layer2.innerSurface) ;
        noValidCells=setdiff(uniqueInner2,uniqueOuter2);

        setLayerNames = {'outerMaskLayer1','innerMaskLayer1','outerMaskLayer2','innerMaskLayer2'};
        
        for nImg = 1 : length(setOfImages)
            img3d = setOfImages{nImg};
%             img3d=permute(img3d,[1 3 2]);
            img3d(ismember(img3d,noValidCells))=0;

%             mask3d=false(size(img3d));
%             mask3d(img3d>0)=1;
% 
% 
%             [x,y,z]=ind2sub(size(mask3d),find(mask3d==1));
%             shp=alphaShape(x,y,z,200);
%             %     plot(shp)
%             [qx,qy,qz]=ind2sub(size(mask3d),find(mask3d>=0));
%             tf = inShape(shp,qx,qy,qz);
% 
%             mask3d=zeros(size(mask3d));
%             indFilImg=sub2ind(size(mask3d),qx(tf),qy(tf),qz(tf));
%             mask3d(indFilImg)=1;


            load(['data\' name '\maskLayers\certerAndRadiusPerZ.mat'],'centers')

            imgFinalCoordinates=cell(size(img3d,3),1);
            centroids=centers{nImg};

            %         centroidX=mean(cellfun(@(x) x(3),centroids));
            %         centroidY=mean(cellfun(@(x) x(1),centroids));

            for coordZ = 1 : size(img3d,3)
                centroidCoordZ = centroids{rangeY(1)-1+coordZ};
                centroidX = centroidCoordZ(3);
                centroidY = centroidCoordZ(1);

                %% Create perimeter mask               
                mask=false(size(img3d(:,:,1)));
                mask(img3d(:,:,coordZ)>0)=1;
                [x,y]=find(mask);

                zPerimMask = imread(['data\' name '\maskLayers\' setLayerNames{nImg} '\' num2str(rangeY(1)-1+coordZ) '.bmp']);
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
                deployedImg(coordZ,1:length(rowOfCoord)) = rowOfCoord;
            end

            %        figure;imshow(deployedImg,c(orderRand,:))
            totalImages{nImg} = deployedImg;

        end
    
    
end

