function [ vertices, neighboursVertices] = getVertices3D( L_img, neighbours )
% With a labelled image as input, the objective is get all vertex for each
% cell

ratio=4;
[xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio); 

neighboursVertices = buildTripletsOfNeighs( neighbours );%intersect dilatation of each cell of triplet
vertices = cell(size(neighboursVertices, 1), 1);

initBW1 =zeros(size(L_img));

initBW2 = zeros(size(L_img));

initBW3 = zeros(size(L_img));

initBorderImg = zeros(size(L_img));


for numTriplet = 1 : size(neighboursVertices,1)
    
    %Reset variables
    borderImg = initBorderImg;
    BW3 = initBW3;
    BW2 = initBW2;
    BW1 = initBW1;

    imgNeighs1 = L_img==neighboursVertices(numTriplet, 1);
    BW1(imgNeighs1)=1;
    
    imgNeighs2 = L_img==neighboursVertices(numTriplet, 2);
    BW2(imgNeighs2)=1;
    
    imgNeighs3 = L_img==neighboursVertices(numTriplet, 3);
    BW3(imgNeighs3)=1;
    
    % We first calculate the perimeter of the cell to improve efficiency
    % If the image is small, is better not to use bwperim
    % For larger images it improves a lot the efficiency
    bw1Perim = bwperim(BW1);
    BW1_dilate = imdilate(bw1Perim, ball);
    
    bw2Perim = bwperim(BW2);
    BW2_dilate = imdilate(bw2Perim, ball);
    
    bw3Perim = bwperim(BW3);
    BW3_dilate = imdilate(bw3Perim, ball);

    borderImg(L_img==0) = 1;
    
    [xPx, yPx, zPx] = findND((BW1_dilate .* BW2_dilate .* BW3_dilate .* borderImg) == 1);
    
    if length(xPx)>1
        vertices{numTriplet} = round(mean([xPx, yPx, zPx]));
    else
        vertices{numTriplet} = [xPx, yPx , zPx];
    end
end



%Correct false negative and positive

% imshow(L_img)
% 
% hold on
% for i=1:size(vertices,1), plot3(vertices(i,1),vertices(i,2), vertices(i,3),'*r'), end
% hold off

end

