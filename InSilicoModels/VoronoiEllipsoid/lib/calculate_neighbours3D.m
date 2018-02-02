function [ellipsoidInfo] = calculate_neighbours3D(L_img, ellipsoidInfo)

%% Generate neighbours
    ratio=8;
    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(cells~=0);                  %% Deleting cell 0 from range

    [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
    ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio);
    
    imgPerim = uint16(bwperim(L_img)) .* L_img;
    
    for cell = 1 : length(cells)
        %c = gpuArray(imgPerim==cells(cell)); %Maximum variable size allowed on the device is exceeded.
        BW_dilate = imdilate(imgPerim==cells(cell), ball);
        [x, y, z] = findND(BW_dilate);
        ellipsoidInfo.cellDilated{cell} = [uint16(x), uint16(y), uint16(z)];
        
        neighs=unique(L_img(BW_dilate));
        neighs_real{cells(cell), 1} = neighs(neighs ~= 0 & neighs ~= cells(cell));
    end
    ellipsoidInfo.neighbourhood = neighs_real;
end

