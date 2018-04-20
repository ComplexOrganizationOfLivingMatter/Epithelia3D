function [ vertices,neighboursVertices ] = getVertices( L_img,neighs )
% With a labelled image as input, the objective is get all vertex for each
% cell

ratio=3;
se=strel('square',ratio);

[H,W,~]=size(L_img);


tripletsOfNeighs=buildTripletsOfNeighs( neighs );%intersect dilatation of each cell of triplet


for i=1 : size(tripletsOfNeighs,1)
    BW1=zeros(H,W);BW2=zeros(H,W);BW3=zeros(H,W);borderImg=zeros(H,W);
    BW1(L_img==tripletsOfNeighs(i,1))=1;
    BW2(L_img==tripletsOfNeighs(i,2))=1;
    BW3(L_img==tripletsOfNeighs(i,3))=1;
    BW1_dilate=imdilate(BW1,se);
    BW2_dilate=imdilate(BW2,se);
    BW3_dilate=imdilate(BW3,se);
    borderImg(L_img==0)=1; 
    [row,col]=find((BW1_dilate.*BW2_dilate.*BW3_dilate.*borderImg)==1);
    if length(row)>1
        vertices{i}=round(mean([row,col]));
    else
        vertices{i}=[row,col];
    end
    
    neighboursVertices{i} = tripletsOfNeighs(i,:);

end


%Correct false negative and positive
%[vertices,neighboursVertices]=refineVertices(vertices,neighboursVertices);

% imshow(L_img)
% 
% hold on
% for i=1:size(vertices,2), a=vertices{1,i}; plot(a(2),a(1),'*r'), end
% hold off

end

