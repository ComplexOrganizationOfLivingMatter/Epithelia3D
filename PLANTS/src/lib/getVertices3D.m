function [ verticesInfo ] = getVertices3D( L_img, setOfCells, neigbourhoodInfo )
    % With a labelled image as input, the objective is get all vertex for each
    % cell
    setOfCells=setOfCells(setOfCells~=0);
    neighbours=neigbourhoodInfo.neighbourhood;
    indicesCells=ismember(1:length(neighbours),setOfCells);
    neighbours(~indicesCells)={nan};
    neighboursVertices = buildTripletsOfNeighs( neighbours );%intersect dilatation of each cell of triplet
    vertices = cell(size(neighboursVertices, 1), 1);
    binaryL_img=L_img>0;

    % We first calculate the perimeter of the cell to improve efficiency
    % If the image is small, is better not to use bwperim
    % For larger images it improves a lot the efficiency
    %imgPerim = uint16(bwperim(L_img)) .* L_img;

    for numTriplet = 1 : size(neighboursVertices,1)

        BW1_dilate = false(size(L_img));
        BW2_dilate = false(size(L_img));
        BW3_dilate = false(size(L_img));
        pxs = neigbourhoodInfo.cellDilated{neighboursVertices(numTriplet, 1)};
        BW1_dilate(sub2ind(size(L_img), pxs(:, 1), pxs(:, 2), pxs(:, 3))) = 1;
        pxs = neigbourhoodInfo.cellDilated{neighboursVertices(numTriplet, 2)};
        BW2_dilate(sub2ind(size(L_img), pxs(:, 1), pxs(:, 2), pxs(:, 3))) = 1;
        pxs = neigbourhoodInfo.cellDilated{neighboursVertices(numTriplet, 3)};
        BW3_dilate(sub2ind(size(L_img), pxs(:, 1), pxs(:, 2), pxs(:, 3))) = 1;

        %It is better use '&' than '.*' in this function
         indxCellDilated = find(BW1_dilate & BW2_dilate & BW3_dilate & binaryL_img);
         [xPx, yPx, zPx]=ind2sub(size(BW1_dilate),indxCellDilated);

        if length(xPx)>1
            vertices{numTriplet} = round(mean([xPx, yPx, zPx]));
        else
            vertices{numTriplet} = [xPx, yPx , zPx];
        end
    end

    indicesValid=cellfun(@(x) ~isempty(x),vertices);
    vertices=vertices(indicesValid,:);
    verticesInfo.verticesPerCell = vertices;
    verticesInfo.verticesConnectCells = neighboursVertices(indicesValid,:);

    %Correct false negative and positive

    % imshow(L_img)
    % 
    % hold on
    %     for i=1:size(vertices,1), plot3(vertices{i}(1),vertices{i}(2), vertices{i}(3),'*r'), end
    % hold off

end

