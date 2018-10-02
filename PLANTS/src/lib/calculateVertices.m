function [ verticesInfo ] = calculateVertices( L_img, neighbours,ratio)
 
    % With a labelled image as input, the objective is get all vertex for each
    % cell

    se=strel('disk',ratio);
    neighboursVertices = buildTripletsOfNeighs( neighbours );%intersect dilatation of each cell of triplet
    vertices = cell(size(neighboursVertices, 1), 1);
    
    
    % We first calculate the perimeter of the cell to improve efficiency
    % If the image is small, is better not to use bwperim
    % For larger images it improves a lot the efficiency
    dilatedCells=cell(max(max(L_img)),1);
    W=size(L_img,2);
    
    
    for i=1:max(max(L_img))
        BW=zeros(size(L_img));
        BW(L_img==i)=1;
        BW_dilated=imdilate(bwperim(BW),se);
        dilatedCells{i}=BW_dilated;
    end
    
    %the overlapping between dilated cells will be the vertex
    borderImg=zeros(size(L_img));
    borderImg(L_img==0)=1;
    for numTriplet = 1 : size(neighboursVertices,1)
              
        BW1_dilate=dilatedCells{neighboursVertices(numTriplet, 1),1};
        BW2_dilate=dilatedCells{neighboursVertices(numTriplet, 2),1};
        BW3_dilate=dilatedCells{neighboursVertices(numTriplet, 3),1};
         

        %It is better use '&' than '.*' in this function
        [row,col]=find((BW1_dilate.*BW2_dilate.*BW3_dilate.*borderImg)==1);

%         %in case of vertices in X extremes... expanding the image
%         if isempty(row) && isempty(col)
%             [row,col]=find((imdilate([BW1_dilate,BW1_dilate],[1,1;1,1]).*imdilate([BW2_dilate,BW2_dilate],[1,1;1,1]).*imdilate([BW3_dilate,BW3_dilate],[1,1;1,1]).*[borderImg,borderImg])==1);
%             if round(mean(col))>W
%                col= W;
%                row=mean(row);
%             end
%         end
        
        if length(row)>1
            if ~ismember(round(mean(col)),col)
                vertices{numTriplet,1}=round(mean([row(col > mean(col)),col(col > mean(col))]));
                vertices{numTriplet,2}=round(mean([row(col < mean(col)),col(col < mean(col))]));
            else
                vertices{numTriplet} = round(mean([row,col]));
            end
        else
            vertices{numTriplet} = [row,col];
        end
        
    end

    
    
    %storing vertices and deleting artefacts
    verticesInfo.verticesPerCell = vertices;
    verticesInfo.verticesConnectCells = neighboursVertices;

    notEmptyCells=cellfun(@(x) ~isempty(x),verticesInfo.verticesPerCell,'UniformOutput',true);
    if size(verticesInfo.verticesPerCell,2)==2
        verticesInfo.verticesPerCell=[verticesInfo.verticesPerCell(notEmptyCells(:,1),1);verticesInfo.verticesPerCell(notEmptyCells(:,2),2)];
        verticesInfo.verticesConnectCells=[verticesInfo.verticesConnectCells(notEmptyCells(:,1),:);verticesInfo.verticesConnectCells(notEmptyCells(:,2),:)];
    else
        verticesInfo.verticesPerCell=verticesInfo.verticesPerCell(notEmptyCells,:);
        verticesInfo.verticesConnectCells=verticesInfo.verticesConnectCells(notEmptyCells,:);
    end
    
    indexes=cellfun(@(x) length(x)==2,verticesInfo.verticesPerCell);
    verticesInfo.verticesPerCell=verticesInfo.verticesPerCell(indexes,:);
    verticesInfo.verticesConnectCells=verticesInfo.verticesConnectCells(indexes,:);
   
    %test vertices higher than W
    outOfRange = cellfun(@(x) x(:,2)>W , verticesInfo.verticesPerCell);
    if sum(outOfRange)>0
        verticesPerCellOutlayerCorrected=cellfun(@(x) [x(1),W] ,verticesInfo.verticesPerCell(outOfRange),'UniformOutput',false);
        verticesInfo.verticesPerCell(outOfRange)=verticesPerCellOutlayerCorrected;
    end
end

