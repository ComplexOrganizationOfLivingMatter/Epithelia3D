function [image3dInfo] = calculateNeighbours3D(L_img)

    %% Generate neighbours
    se = strel('sphere',3);
    cells=1:max(max(max(L_img)));
    imgPerim = uint16(bwperim(L_img)) .* uint16(L_img);
    
    neighs_real=cell(length(cells),1);
    
    for numCell = 1 : length(cells)
        %Dilating cell of interest
        BW_dilate = imdilate(imgPerim==cells(numCell), se);
        indxCellDilated = find(BW_dilate);
        [x,y,z]=ind2sub(size(BW_dilate),indxCellDilated);
%           shp=alphashape(x,y,z);
%           figure;plot(shp)      
        image3dInfo.cellDilated{numCell} = [uint16(x), uint16(y), uint16(z)];
        neighs=unique(L_img(indxCellDilated));
        neighs_real{cells(numCell), 1} = neighs(neighs ~= 0 & neighs ~= cells(numCell));
    end

    image3dInfo.neighbourhood = neighs_real;

end

