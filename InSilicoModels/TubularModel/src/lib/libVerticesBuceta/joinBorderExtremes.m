function [pairOfVertices3DBorders]=joinBorderExtremes(dataVertIDApicalBord,dataVertIDBasalBord,verticesInfoExtreme)

    pairOfVertices3DBorders=[];
    for nVert=1:size(verticesInfoExtreme,1)
        if nVert+1 <= size(verticesInfoExtreme,1)
            restVerticesInfoExtreme=verticesInfoExtreme(nVert+1,:);
            vertID=verticesInfoExtreme{4};
            cellsInVert=verticesInfoExtreme{2};

            matchVertApical=cellfun(@(x) sum(ismember(cellsInVert,x))>=2,dataVertIDApicalBord(:,7));
            matchVertBasal=cellfun(@(x) sum(ismember(cellsInVert,x))>=2,dataVertIDBasalBord(:,7));
            matchVertApicoBasal=cellfun(@(x) sum(ismember(cellsInVert,x))>=2,verticesInfoExtreme(:,2));
            
            if sum(matchVertApical)>0
                pairOfVertices3DBorders(end+1,:)=[vertID,dataVertIDApicalBord{matchVertApical,3}];
            end
                
            if sum(matchVertBasal)>0
                pairOfVertices3DBorders(end+1,:)=[vertID,dataVertIDBasalBord{matchVertBasal,3}];
            end

            if sum(matchVertApicoBasal)>0
                pairOfVertices3DBorders(end+1,:)=[vertID,verticesInfoExtreme{matchVertBasal,4}];
            end
            
        end
    end
    



end