function verticesNoValidCellsInfo = getVerticesNoValidCellsDelaunayLloyd(pairNoValidCells,tripletSeeds,hMin,hMax,wSR)

    vertices = cell(size(pairNoValidCells,1), 1);
    neighboursVertices = cell(size(pairNoValidCells,1), 1);
    
    for nPairs = 1 : size(pairNoValidCells,1)
       
        pairCells = pairNoValidCells(nPairs,:);
        pairCells = pairCells(pairCells>0);
        
        seed1 = tripletSeeds(pairCells(1),:);
        seed2 = tripletSeeds(pairCells(2),:);
        
        [~,closeLim] = min([seed1(1)-hMin,hMax-seed1(1)]);
        
        if closeLim == 1
           limRef = hMin; 
        else
           limRef = hMax;  
        end
               
        %solve distance equation sqrt((X - x1)^2 + (yRef - y1)^2) = sqrt((X - x2)^2 + (yRef - y2)^2)       
        xValue = ( seed2(2)^2 + (limRef - seed2(1))^2 - seed1(2)^2 - (limRef - seed1(1))^2 )/(2*seed2(2) - 2*seed1(2));
        xValue = xValue - wSR;
        
        vertices{nPairs} = [limRef,xValue];
        neighboursVertices{nPairs} = pairCells;
        
    end
    
    
    verticesNoValidCellsInfo.verticesPerCell = vertices;
    verticesNoValidCellsInfo.verticesConnectCells = neighboursVertices;
    

end

