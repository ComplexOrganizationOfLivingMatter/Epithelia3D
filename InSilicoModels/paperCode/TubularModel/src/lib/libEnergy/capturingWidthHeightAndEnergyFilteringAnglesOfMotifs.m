function [edgeLength,sumEdgesOfEnergy,edgeAngle,H1Length,H2Length,W1Length,W2Length,validIndex]=capturingWidthHeightAndEnergyFilteringAnglesOfMotifs(verticesPerCell,vertices,pairValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved,W,borderCells,arrayValidVerticesBorderLeft,arrayValidVerticesBorderRight)
    %In this function we calculate the source data for the line tension model


    %initial four cells motifs
    fourCellsMotifs=[pairValidCellsPreserved,cellsInMotifNoContactValidCellsPreserved];

    %cell 1 and 2, are the cells in contact. Cell 3 and 4 are not touching between them into the four cell motif.
    %neighbourings-> cell 1-[2,3,4] ; cell 2- [1,3,4]; cell 3- [1,2]; cell 4- [1,2];

    %vertices shared by cells 1 and 2
    verticesCell_1_2=arrayfun(@(x,y) intersect(verticesPerCell{x},verticesPerCell{y}), pairValidCellsPreserved(:,1),pairValidCellsPreserved(:,2),'UniformOutput',false);
    allVerticesCell_1_2=arrayfun(@(x,y) unique([verticesPerCell{x}',verticesPerCell{y}']), pairValidCellsPreserved(:,1),pairValidCellsPreserved(:,2),'UniformOutput',false);
    
    %vertices shared between cell 3 and cells 1 & 2
    verticesCell_3=cellfun(@(x,y) intersect(x,verticesPerCell{y}),allVerticesCell_1_2,table2cell(array2table((cellsInMotifNoContactValidCellsPreserved(:,1)))),'UniformOutput', false);
    %vertices shared between cell 4 and cells 1 & 2
    verticesCell_4=cellfun(@(x,y) intersect(x,verticesPerCell{y}),allVerticesCell_1_2,table2cell(array2table((cellsInMotifNoContactValidCellsPreserved(:,2)))),'UniformOutput', false);
    
    %H1, H2, W1 and W2 default, calculation
    vertH1default=cellfun(@(x,y) setdiff(x,y),verticesCell_3,verticesCell_1_2,'UniformOutput',false);
    vertH2default=cellfun(@(x,y) setdiff(x,y),verticesCell_4,verticesCell_1_2,'UniformOutput',false);
    vertW1default=cellfun(@(x,y,z) intersect(verticesPerCell{x},[y;z]), table2cell(array2table(pairValidCellsPreserved(:,1))),vertH1default,vertH2default,'UniformOutput',false);
    vertW2default=cellfun(@(x,y,z) intersect(verticesPerCell{x},[y;z]), table2cell(array2table(pairValidCellsPreserved(:,2))),vertH1default,vertH2default,'UniformOutput',false);

    %delete vertices with problems
    notEmptyIndex=cell2mat(cellfun(@(x,y,z,zz,zzz) (length(x)==2 & length(y)==2 & length(z)==2 & length(zz)==2 & ~isempty(zzz)),vertH1default,vertH2default,vertW1default,vertW2default,verticesCell_1_2,'UniformOutput',false));
    indexEdges3CellsMotifs=cellfun(@(x) (length(x) > 2),verticesCell_1_2);
    
    noValidIndex = ~notEmptyIndex | indexEdges3CellsMotifs;
    if sum(noValidIndex)>0 
        verticesCell_1_2(noValidIndex,:)={NaN};
        vertH1default(noValidIndex,:)={NaN};
        vertH2default(noValidIndex,:)={NaN};
        vertW1default(noValidIndex,:)={NaN};
        vertW2default(noValidIndex,:)={NaN};
        verticesCell_3(noValidIndex,:)={NaN};
        verticesCell_4(noValidIndex,:)={NaN};
    end
    
    
    
    %initializing variables
    edgeLength=nan(length(verticesCell_1_2),1);
    edgeAngle=nan(length(verticesCell_1_2),1);
    H1Length=nan(length(verticesCell_1_2),1);
    H2Length=nan(length(verticesCell_1_2),1);
    W1Length=nan(length(verticesCell_1_2),1);
    W2Length=nan(length(verticesCell_1_2),1);
    sumEdgesOfEnergy=nan(length(verticesCell_1_2),1);
    verticesBorderLeft=vertices.verticesPerCell(logical(arrayValidVerticesBorderLeft));
    verticesBorderRight=vertices.verticesPerCell(logical(arrayValidVerticesBorderRight));
    
    
    
    %testing angle and edge length
    for i=1:length(verticesCell_1_2)
       
        if ~isnan(verticesCell_1_2{i}) 
        
            try
                %length and angle in central edge
                [edgeLength(i), edgeAngle(i)] = edgeLengthAnglesCalculation([vertices.verticesPerCell{verticesCell_1_2{i}(1,1)};vertices.verticesPerCell{verticesCell_1_2{i}(2,1)}],borderCells,verticesBorderLeft,verticesBorderRight,vertices,fourCellsMotifs(i,:),W);

                %length and angle in sourrounding edges
                [edge1Length, edge1Angle] = edgeLengthAnglesCalculation([vertices.verticesPerCell{vertH1default{i}(1,1)};vertices.verticesPerCell{vertH1default{i}(2,1)}],borderCells,verticesBorderLeft,verticesBorderRight,vertices,fourCellsMotifs(i,:),W);
                [edge2Length, edge2Angle] = edgeLengthAnglesCalculation([vertices.verticesPerCell{vertH2default{i}(1,1)};vertices.verticesPerCell{vertH2default{i}(2,1)}],borderCells,verticesBorderLeft,verticesBorderRight,vertices,fourCellsMotifs(i,:),W);
                [edge3Length, edge3Angle] = edgeLengthAnglesCalculation([vertices.verticesPerCell{vertW1default{i}(1,1)};vertices.verticesPerCell{vertW1default{i}(2,1)}],borderCells,verticesBorderLeft,verticesBorderRight,vertices,fourCellsMotifs(i,:),W);
                [edge4Length, edge4Angle] = edgeLengthAnglesCalculation([vertices.verticesPerCell{vertW2default{i}(1,1)};vertices.verticesPerCell{vertW2default{i}(2,1)}],borderCells,verticesBorderLeft,verticesBorderRight,vertices,fourCellsMotifs(i,:),W);

                %detecting who is W and who H depending on its angle
                if (mean([edge1Angle,edge2Angle]) < 30 && mean([edge3Angle,edge4Angle]) > 60) || ...
                        (mean([edge1Angle,edge2Angle]) > 60 && mean([edge3Angle,edge4Angle]) > 60)
                    if (edge1Angle+edge2Angle)>(edge3Angle+edge4Angle)
                        W1Length(i)=edge1Length;
                        W2Length(i)=edge2Length;
                        H1Length(i)=edge3Length;
                        H2Length(i)=edge4Length;
                    else
                        W1Length(i)=edge3Length;
                        W2Length(i)=edge4Length;
                        H1Length(i)=edge1Length;
                        H2Length(i)=edge2Length;
                    end

                    %get sum of energies
                    sumEdgesOfEnergy(i) = getSumOfEnergyEdges(edgeLength(i),verticesCell_1_2{i},verticesCell_3{i},verticesCell_4{i},vertices,borderCells,verticesBorderLeft,verticesBorderRight,fourCellsMotifs(i,:),W);
                end
            catch
                disp(['skip measurement of energy in vertex ' num2str(i)])
            end
        end
    end
    
    validIndex=~isnan(edgeLength);
        
end

