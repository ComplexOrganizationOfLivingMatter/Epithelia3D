function [finalImage,validCells,noValidCells] = getFinalImageAndNoValidCells(layerImage,c)

    labelMask=zeros(size(layerImage));
    perimMask=false(size(layerImage));
    
    %open area
    %This is really doing nothing
    areaValid=bwareaopen(layerImage,15);
    layerImage(~areaValid)=0;
    %sum(sum(~areaValid & layerImage~=0))
    
    %% delete strange shapes and get perimeters for watershed
    cellsLayer=unique(layerImage);
    cellsLayer=cellsLayer(cellsLayer~=0);
    
    for nCell = cellsLayer'
       
        mask = zeros(size(labelMask));
        mask(layerImage == nCell) = 1;
        mask = bwareaopen(mask,5);
        %mask = imfill(mask, 'holes');
        maskDilated = imdilate(mask,strel('disk',3));
        maskEroded = imerode(maskDilated,strel('disk',3));
        labelMask(maskEroded)=nCell;
        maskErodedPerim = bwperim(maskEroded);
        % It is not the perim the zone of 0s or the border
        dilatedSurroundingCells = imdilate(layerImage~=nCell, strel('disk', 1));
        perimMask(maskErodedPerim & dilatedSurroundingCells)=1;
    end
    %figure;imshow(labelMask,c)
    labelMaskPerim=labelMask;
    labelMaskPerim(perimMask)=0;
    %figure;imshow(labelMaskPerim,c)
    validArea=bwareaopen(labelMaskPerim,20,4);
    labelMaskPerim(~validArea)=0;
    
    %% Watershed
    maskDist=bwdist(labelMaskPerim>0);
    maskWater=watershed(maskDist,4);
    %figure;imshow(maskWater,c)
    maskWater(labelMask==0)=0;
    validArea=bwareaopen(maskWater,20,4);
    maskWater(~validArea)=0;

    %figure;imshow(maskWater,c)
    
    %% relabel cells with original labels
    centroids = regionprops(maskWater,'Centroid');
    centroids = round(cat(1,centroids.Centroid));
    cellsWater = unique(maskWater);
    cellsWater=cellsWater(cellsWater~=0);
    
    finalImage=zeros(size(maskWater));
    for nCell = cellsWater'
        finalImage(maskWater==nCell)=labelMask(centroids(nCell,2),centroids(nCell,1));
    end
    %figure;imshow(finalImage,c)

    %% Get valid & no valid Cells
    maskNoValidCell=imdilate(imdilate(finalImage>0,strel('disk',2))==0,strel('disk',5));
    noValidCells = unique(finalImage(maskNoValidCell));   
    borderCells = unique([unique(finalImage(1:2,:));unique(finalImage(end-1:end,:));unique(finalImage(:,1:2));unique(finalImage(:,end-1:end))]);
    noValidCells = unique([noValidCells;borderCells]);  
    
    validCells = setdiff(unique(finalImage),noValidCells);
    
    noValidCells = noValidCells(noValidCells~=0);
    %figure;imshow(ismember(finalImage,noValidCells))

    
    
end