function [pairOfVertices3DBorders]=joinBorderExtremes(dataVertIDApicalBord,dataVertIDBasalBord,verticesInfoExtreme)

    pairOfVertices3DBorders=[];
    for nVert=1:size(verticesInfoExtreme,1)
        if nVert < size(verticesInfoExtreme,1)
            restVerticesInfoExtreme=verticesInfoExtreme(nVert+1,:);
        else
            restVerticesInfoExtreme(1,1:2)={0,0};
        end
            vertID=verticesInfoExtreme{nVert,4};
            cellsInVert=verticesInfoExtreme{nVert,2};

            matchVertApical=cellfun(@(x) sum(ismember(cellsInVert,x))>=2,dataVertIDApicalBord(:,7));
            matchVertBasal=cellfun(@(x) sum(ismember(cellsInVert,x))>=2,dataVertIDBasalBord(:,7));
            matchVertApicoBasal=cellfun(@(x) sum(ismember(cellsInVert,x))>=2,restVerticesInfoExtreme(:,2));
            
            if sum(matchVertApical)>0
                pairOfVertices3DBorders=[pairOfVertices3DBorders;ones(length([dataVertIDApicalBord{matchVertApical,3}]),1)*vertID,vertcat(dataVertIDApicalBord{matchVertApical,3})];
            end
                
            if sum(matchVertApicoBasal)>0
                pairOfVertices3DBorders=[pairOfVertices3DBorders;ones(length([verticesInfoExtreme{matchVertApicoBasal,4}]),1)*vertID,vertcat(verticesInfoExtreme{matchVertApicoBasal,4})];
            end
            
            if sum(matchVertBasal)>0 && (sum(matchVertApicoBasal)==0 || sum(matchVertApical)==0)
                pairOfVertices3DBorders=[pairOfVertices3DBorders;ones(length([dataVertIDBasalBord{matchVertBasal,3}]),1)*vertID,vertcat(dataVertIDBasalBord{matchVertBasal,3})];
            end
    end
    



end