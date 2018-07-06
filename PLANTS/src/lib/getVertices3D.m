function [ neigbourhoodInfo] = getVertices3D( L_img, neighbours,neigbourhoodInfo )
% With a labelled image as input, the objective is get all vertex for each
% cell
neighboursVertices = buildTripletsOfNeighs( neighbours );%intersect dilatation of each cell of triplet
vertices = cell(size(neighboursVertices, 1), 1);

initBorderImg = L_img==0;


% We first calculate the perimeter of the cell to improve efficiency
% If the image is small, is better not to use bwperim
% For larger images it improves a lot the efficiency
%imgPerim = uint16(bwperim(L_img)) .* L_img;

for numTriplet = 1 : size(neighboursVertices,1)
    
    BW1_dilate = zeros(size(L_img), 'uint16');
    pxs = neigbourhoodInfo.cellDilated{neighboursVertices(numTriplet, 1)};
    BW1_dilate(sub2ind(size(L_img), pxs(:, 1), pxs(:, 2), pxs(:, 3))) = neighboursVertices(numTriplet, 1);
    BW2_dilate = zeros(size(L_img), 'uint16');
    pxs = neigbourhoodInfo.cellDilated{neighboursVertices(numTriplet, 2)};
    BW2_dilate(sub2ind(size(L_img), pxs(:, 1), pxs(:, 2), pxs(:, 3))) = neighboursVertices(numTriplet, 2);
    BW3_dilate = zeros(size(L_img), 'uint16');
    pxs = neigbourhoodInfo.cellDilated{neighboursVertices(numTriplet, 3)};
    BW3_dilate(sub2ind(size(L_img), pxs(:, 1), pxs(:, 2), pxs(:, 3))) = neighboursVertices(numTriplet, 3);

    %It is better use '&' than '.*' in this function
    [xPx, yPx, zPx] = findND(BW1_dilate & BW2_dilate & BW3_dilate & initBorderImg);
    
    if length(xPx)>1
        vertices{numTriplet} = round(mean([xPx, yPx, zPx]));
    else
        vertices{numTriplet} = [xPx, yPx , zPx];
    end
end

neigbourhoodInfo.verticesPerCell = vertices;
neigbourhoodInfo.verticesConnectCells = neighboursVertices;

%Correct false negative and positive

% imshow(L_img)
% 
% hold on
% for i=1:size(vertices,1), plot3(vertices(i,1),vertices(i,2), vertices(i,3),'*r'), end
% hold off

end

