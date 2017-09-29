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

initBorderImg = L_img==0;

% We first calculate the perimeter of the cell to improve efficiency
% If the image is small, is better not to use bwperim
% For larger images it improves a lot the efficiency
L_imgPerim = bwperim(L_img).* L_img;

for numTriplet = 1 : size(neighboursVertices,1)
    
    %Reset variables
    BW3 = initBW3;
    BW2 = initBW2;
    BW1 = initBW1;

    imgNeighs1 = L_imgPerim==neighboursVertices(numTriplet, 1);
    BW1(imgNeighs1)=1;
    
    imgNeighs2 = L_imgPerim==neighboursVertices(numTriplet, 2);
    BW2(imgNeighs2)=1;
    
    imgNeighs3 = L_imgPerim==neighboursVertices(numTriplet, 3);
    BW3(imgNeighs3)=1;
    
    BW1_dilate = imdilate(BW1, ball);
    BW2_dilate = imdilate(BW2, ball);
    BW3_dilate = imdilate(BW3, ball);

    %It is better use '&' than '.*' in this function
    [xPx, yPx, zPx] = findND(BW1_dilate & BW2_dilate & BW3_dilate & initBorderImg);
    
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

