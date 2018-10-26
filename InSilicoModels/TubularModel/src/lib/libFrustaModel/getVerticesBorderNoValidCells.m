function [ verticesNoValidCellsInfo ] = getVerticesBorderNoValidCells(L_img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    ratio=4;  
    
    borderLimitUp=zeros(size(L_img));
    borderLimitDown=borderLimitUp;
    borderLimitUp(1,:)=1;
    borderLimitDown(end,:)=1;
    
    mask=zeros(size(L_img));
    mask(L_img>0)=1;
    
    verticesMask=((borderLimitUp+borderLimitDown)-mask);
    verticesMask(verticesMask<0)=0;
    
    verticesInLimit=bwlabel(verticesMask);

    vertices = cell(max(max((verticesInLimit))), 1);
    neighboursVertices = cell(max(max((verticesInLimit))), 1);
    
    for j=1:max(max((verticesInLimit)))
        
       
        
        BW=zeros(size(L_img));
        BW(verticesInLimit==j)=1;
        BW_dilated=imdilate(bwperim(BW),[1 1 1]);      
        
        [row,col]=find(verticesInLimit==j);
            
        cellsNeigh=unique(BW_dilated.*L_img);
        cellsNeigh=cellsNeigh(cellsNeigh~=0);
        
        if length(cellsNeigh)<2
           if col==size(L_img,2) 
                cellsNeigh=[cellsNeigh;L_img(row,1)];
           else if col == 1
                   cellsNeigh=[cellsNeigh;L_img(row,end)];
               end
           end
        end
        if length(row)> 1
           row = round(mean(row));
           col = round(mean(col));
        end
        vertices{j}=[row,col];
        neighboursVertices{j}=cellsNeigh;
        
        
    end
    
    verticesNoValidCellsInfo.verticesPerCell = vertices;
    verticesNoValidCellsInfo.verticesConnectCells = neighboursVertices;
    
    
end

