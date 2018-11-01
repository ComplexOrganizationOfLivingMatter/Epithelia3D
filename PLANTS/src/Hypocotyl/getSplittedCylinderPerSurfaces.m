function [layer1,layer2,cellsLayer1,cellsLayer2]=getSplittedCylinderPerSurfaces(img3d,cellsCorrectedLayer1)

    %get superficial cells in Layer 1
    cellsLayer1 = getSuperficialCells(img3d);
    layer1 = ismember(img3d,cellsLayer1).*img3d;
    
    propReg=regionprops3(layer1,'Volume');
    volumeCells=cat(1,propReg.Volume);
    minVolumeCellLayer1 = mean(volumeCells)/5;
    cells2deleteLayer1=find(volumeCells>0 & volumeCells<minVolumeCellLayer1);
    
    
    layer1(ismember(layer1,cells2deleteLayer1))=0;
    cellsLayer1 = cellsLayer1(~ismember(cellsLayer1,cells2deleteLayer1));
    
    if ~isempty(cellsCorrectedLayer1)
        cells2deleteLayer1 = unique([cells2deleteLayer1;setdiff(cellsLayer1,cellsCorrectedLayer1)]);
        cellsLayer1 = intersect(cellsLayer1,cellsCorrectedLayer1);        
        layer1(~ismember(layer1,cellsLayer1))=0;
    end
    
    %calculate cells in layer 2
    img3dWithoutLayer1 = img3d;
    img3dWithoutLayer1(ismember(img3d,unique([cellsLayer1;cells2deleteLayer1]))) = 0;
    cellsLayer2 = getSuperficialCells(img3dWithoutLayer1);
    
    layer2 = ismember(img3dWithoutLayer1,cellsLayer2).*img3dWithoutLayer1;
    
    propReg=regionprops3(layer2,'Volume');
    volumeCells=cat(1,propReg.Volume);
    minVolumeCellLayer2 = mean(volumeCells)/5;
    cells2deleteLayer2=find(volumeCells>0 & volumeCells<minVolumeCellLayer2);
    
    layer2(ismember(layer2,cells2deleteLayer2))=0;
    cellsLayer2 = cellsLayer2(~ismember(cellsLayer2,cells2deleteLayer2));
    
end
