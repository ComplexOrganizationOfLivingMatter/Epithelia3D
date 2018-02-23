function [ verticesInfo ] = calculateVertices( L_img, neighbours )
 
    % With a labelled image as input, the objective is get all vertex for each
    % cell

    ratio=4;
    se=strel('disk',ratio);


    neighboursVertices = buildTripletsOfNeighs( neighbours );%intersect dilatation of each cell of triplet
    vertices = cell(size(neighboursVertices, 1), 1);

    % We first calculate the perimeter of the cell to improve efficiency
    % If the image is small, is better not to use bwperim
    % For larger images it improves a lot the efficiency
    
    dilatedCells=cell(max(max(L_img)),1);
    for i=1:max(max(L_img))
        BW=zeros(size(L_img));
        BW(L_img==i)=1;
        BW_dilated=imdilate(bwperim(BW),se);
        dilatedCells{i}=BW_dilated;
    end
    
    borderImg=zeros(size(L_img));
    borderImg(L_img==0)=1;
    for numTriplet = 1 : size(neighboursVertices,1)

        BW1_dilate=dilatedCells{neighboursVertices(numTriplet, 1),1};
        BW2_dilate=dilatedCells{neighboursVertices(numTriplet, 2),1};
        BW3_dilate=dilatedCells{neighboursVertices(numTriplet, 3),1};
         

        %It is better use '&' than '.*' in this function
        [row,col]=find((BW1_dilate.*BW2_dilate.*BW3_dilate.*borderImg)==1);

        if length(row)>1
            vertices{numTriplet} = round(mean([row,col]));
        else
            vertices{numTriplet} = [row,col];
        end
    end

    verticesInfo.verticesPerCell = vertices;
    verticesInfo.verticesConnectCells = neighboursVertices;



end

