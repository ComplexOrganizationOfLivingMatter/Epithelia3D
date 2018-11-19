function [layer1,layer2,layer3,cellsLayer1,cellsLayer2,cellsLayer3]=getSplittedCylinderPerSurfaces(img3d,cellsCorrectedLayer1)

    %get superficial cells in Layer 1
    [cellsLayer1,cellsLayer1WithoutFilter] = getSuperficialCells(img3d);
    layer1 = uint16(ismember(img3d,cellsLayer1)).*img3d;
    
    propReg=regionprops3(layer1,'Volume');
    volumeCells=cat(1,propReg.Volume);
    minVolumeCellLayer1 = max(volumeCells)/5;
    cells2deleteLayer1=find(volumeCells>0 & volumeCells<minVolumeCellLayer1);
    
    
    layer1(ismember(layer1,cells2deleteLayer1))=0;
    cellsLayer1 = cellsLayer1(~ismember(cellsLayer1,cells2deleteLayer1));
    
    if ~isempty(cellsCorrectedLayer1)
        cellsLayer1 = intersect(cellsLayer1,cellsCorrectedLayer1);        
        layer1(~ismember(layer1,cellsLayer1))=0;
    end
    
    %calculate cells in layer 2
    previousCells = unique(cellsLayer1WithoutFilter);
    
    img3dWithoutPreviousCells = img3d;
    img3dWithoutPreviousCells(ismember(img3d,previousCells)) = 0;
    [cellsLayer2,cellsLayer2WithoutFilter] = getSuperficialCells(img3dWithoutPreviousCells);
    
    layer2 = uint16(ismember(img3dWithoutPreviousCells,cellsLayer2)).*img3dWithoutPreviousCells;
    
    propReg=regionprops3(layer2,'Volume');
    volumeCells=cat(1,propReg.Volume);
    minVolumeCellLayer2 = max(volumeCells)/5;
    cells2deleteLayer2=find(volumeCells>0 & volumeCells<minVolumeCellLayer2);
    
    layer2(ismember(layer2,cells2deleteLayer2))=0;
    cellsLayer2 = cellsLayer2(~ismember(cellsLayer2,cells2deleteLayer2));
    
    %calculate cells in layer 3
    previousCells = unique([previousCells;cellsLayer2WithoutFilter]);
    img3dWithoutPreviousCells(ismember(img3dWithoutPreviousCells,previousCells)) = 0;
    [cellsLayer3,~] = getSuperficialCells(img3dWithoutPreviousCells);
        
    layer3 = uint16(ismember(img3dWithoutPreviousCells,cellsLayer3)).*img3dWithoutPreviousCells;

    propReg=regionprops3(layer3,'Volume');
    volumeCells=cat(1,propReg.Volume);
    minVolumeCellLayer3 = max(volumeCells)/5;
    cells2deleteLayer3=find(volumeCells>0 & volumeCells<minVolumeCellLayer3);
    layer3(ismember(layer3,cells2deleteLayer3))=0;
    cellsLayer3 = cellsLayer3(~ismember(cellsLayer3,cells2deleteLayer3));  
    
end
