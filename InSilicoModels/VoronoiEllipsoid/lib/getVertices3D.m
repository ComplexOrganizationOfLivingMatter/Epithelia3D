function [ vertices, neighboursVertices] = getVertices3D( L_img, neighbours )
% With a labelled image as input, the objective is get all vertex for each
% cell

ratio=3;
[xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio); 

neighboursVertices = buildTripletsOfNeighs( neighbours );%intersect dilatation of each cell of triplet

vertices = zeros(size(neighboursVertices));
for numTriplet = 1 : size(neighboursVertices,1)
    BW1=zeros(size(L_img));
    BW2=zeros(size(L_img));
    BW3=zeros(size(L_img));
    borderImg=zeros(size(L_img));
    
    BW1(L_img==neighboursVertices(numTriplet, 1))=1;
    BW2(L_img==neighboursVertices(numTriplet, 2))=1;
    BW3(L_img==neighboursVertices(numTriplet, 3))=1;
    
    BW1_dilate=imdilate(BW1, ball);
    BW2_dilate=imdilate(BW2, ball);
    BW3_dilate=imdilate(BW3, ball);
    
    borderImg(L_img==0) = 1;
    
    [xPx, yPx, zPx]=findND((BW1_dilate.*BW2_dilate.*BW3_dilate.*borderImg)==1);
    
    if length(xPx)>1
        vertices(numTriplet) = round(mean([xPx, yPx, zPx]));
    else
        vertices(numTriplet) = [xPx, yPx , zPx];
    end
end


%Correct false negative and positive

% imshow(L_img)
% 
% hold on
% for i=1:size(vertices,1), a=vertices{1,i}; plot(a(2),a(1),'*r'), end
% hold off

end

