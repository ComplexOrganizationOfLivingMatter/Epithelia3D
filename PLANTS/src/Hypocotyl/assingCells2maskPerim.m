function [layer1,layer2] = assingCells2maskPerim(sampleName,resizeFactor,rangeY,cellsLayer1,cellsLayer2)

    load(['data\' sampleName '\image3d_' strrep(sampleName,' ','_') '.mat'],'img3d');
    nameMaskInner1=['data\' sampleName '\maskLayers\innerMaskLayer1\'];
    nameMaskInner2=['data\' sampleName '\maskLayers\innerMaskLayer2\'];
    nameMaskOuter1=['data\' sampleName '\maskLayers\outerMaskLayer1\'];
    nameMaskOuter2=['data\' sampleName '\maskLayers\outerMaskLayer2\'];
    
    img3d=uint16(img3d);
%     img3dResized=imresize3(img3d,resizeFactor,'Method','nearest');
    img3dResizedLimits=img3d(:,rangeY(1):rangeY(2),:);
    totalCells=unique(img3dResizedLimits);
    
    cellsNoLayer1=setdiff(totalCells,cellsLayer1);
    cellsNoLayer2=setdiff(totalCells,cellsLayer2);
    
    maskLayer1=img3dResizedLimits;
    maskLayer2=img3dResizedLimits;

    maskLayer1(ismember(img3dResizedLimits,cellsNoLayer1))=0;
    maskLayer2(ismember(img3dResizedLimits,cellsNoLayer2))=0;
    
    
    labelOuterLayer1 = cell(size(img3dResizedLimits,2),1);
    labelInnerLayer1 = cell(size(img3dResizedLimits,2),1);
    labelOuterLayer2 = cell(size(img3dResizedLimits,2),1);
    labelInnerLayer2 = cell(size(img3dResizedLimits,2),1);

    for nY = 1 : size(img3dResizedLimits,2)
        
        maskInner1=imread([nameMaskInner1 num2str(nY+rangeY(1)-1) '.bmp']);
        maskInner2=imread([nameMaskInner2 num2str(nY+rangeY(1)-1) '.bmp']);
        maskOuter1=imread([nameMaskOuter1 num2str(nY+rangeY(1)-1) '.bmp']);
        maskOuter2=imread([nameMaskOuter2 num2str(nY+rangeY(1)-1) '.bmp']);
        
        imgYLayer1 = permute(maskLayer1(:,nY,:),[1,3,2]); 
        imgYLayer2 = permute(maskLayer2(:,nY,:),[1,3,2]); 
        
        labelOuterLayer1{nY} = assingPixelValuesFromNormalVector(maskOuter1,imgYLayer1,'outer');
        labelInnerLayer1{nY} = assingPixelValuesFromNormalVector(maskInner1,imgYLayer1,'inner');
        labelOuterLayer2{nY} = assingPixelValuesFromNormalVector(maskOuter2,imgYLayer2,'outer');
        labelInnerLayer2{nY} = assingPixelValuesFromNormalVector(maskInner2,imgYLayer2,'inner');
        
        
    end
    
    layer1.outerSurface = cat(3,labelOuterLayer1{:});
    layer1.innerSurface = cat(3,labelInnerLayer1{:});
    layer2.outerSurface = cat(3,labelOuterLayer2{:});
    layer2.innerSurface = cat(3,labelInnerLayer2{:});

end

