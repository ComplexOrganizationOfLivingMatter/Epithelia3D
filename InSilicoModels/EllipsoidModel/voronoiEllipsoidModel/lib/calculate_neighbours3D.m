function [ellipsoidInfo] = calculate_neighbours3D(L_img, ellipsoidInfo)

    %% Generate neighbours
    se = strel('sphere',3);
    cells=unique(L_img);
    cells=cells(cells~=0); 
    imgPerim = uint16(bwperim(L_img)) .* L_img;
    
    neighs_real=cell(length(cells));
    
    for numCell = 1 : length(cells)
        %Dilating cell of interest
        BW_dilate = imdilate(imgPerim==cells(numCell), se);
        
        %Capturing the boundingBox from dilated cell
        s=regionprops3(BW_dilate,'BoundingBox');

        %boundBox=[ulf_x ulf_y ulf_z width_x width_y width_z];
        %ulf_x, ulf_y, and ulf_z specify the upper-left front corner of the cuboid. 
        %width_x, width_y, and width_z specify the width of the cuboid along each dimension.
        boundBox=cat(1,s.BoundingBox);

        %bounding box with cell dilated info
        imageBox=BW_dilate(boundBox(1):(boundBox(1)+boundBox(4)),...
            boundBox(2):(boundBox(2)+boundBox(5)),boundBox(3):(boundBox(3)+boundBox(6)));
        %bounding box from L_img
        imageLabelBox=L_img(boundBox(1):(boundBox(1)+boundBox(4)),...
            boundBox(2):(boundBox(2)+boundBox(5)),boundBox(3):(boundBox(3)+boundBox(6)));

        indxCellDilatedBoundingBox = find(imageBox);
        [x,y,z]=ind2sub(size(imageBox),indxCellDilatedBoundingBox);
        ellipsoidInfo.cellDilated{numCell} = [uint16(x+boundBox(1)), uint16(y+boundBox(2)), uint16(z+boundBox(3))];
        ellipsoidInfo.cellBoundingBox{numCell} = boundBox;
        
        neighs=unique(imageLabelBox(imageBox));
        neighs_real{cells(numCell), 1} = neighs(neighs ~= 0 & neighs ~= cells(numCell));
    end

    ellipsoidInfo.neighbourhood = neighs_real;

end

