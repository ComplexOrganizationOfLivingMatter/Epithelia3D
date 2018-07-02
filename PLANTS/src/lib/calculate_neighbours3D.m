function [neighbourhoodInfo] = calculate_neighbours3D(L_img)
    %% Generate neighbours
    se = strel('sphere',1);
    cells=unique(L_img)';
    cells=cells(cells~=0);
%     imgPerim = uint16(bwperim(L_img)) .* L_img;
    L_img=uint16(L_img);
    neighs_real=cell(max(cells),1);
    
    for numCell = cells
        %Dilating cell of interest
        BW_dilate = imdilate(L_img==numCell, se);
        indxCellDilated = find(BW_dilate);
        [x,y,z]=ind2sub(size(BW_dilate),indxCellDilated);
%           shp=alphashape(x,y,z);
%           figure;plot(shp)      
        neighbourhoodInfo.cellDilated{numCell} = [uint16(x), uint16(y), uint16(z)];
        neighs=unique(L_img(indxCellDilated));
        neighs_real{numCell, 1} = neighs(neighs ~= 0 & neighs ~= numCell);
    end

    neighbourhoodInfo.neighbourhood = neighs_real;

end

