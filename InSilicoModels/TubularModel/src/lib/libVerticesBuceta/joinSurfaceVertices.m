function [pairOfVertices3D,verticesInfoExtreme,clusterOfNeighs] =joinSurfaceVertices(dataVertID,clusterOfNeighs,clusterOfNeighsAux,verticesInfoExtreme,verticesInfoExtremeAux,radius)

    pairOfVertices3D=zeros(size(dataVertID,1),2);
    for nVert=1:size(dataVertID,1)
        vert2Join=dataVertID(nVert,:);
        vertId=vert2Join{3};
        cellsInVert=vert2Join{end};
        
        matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,clusterOfNeighs(:,3));
        indexesMatch=find(matchVert);
        if ~isempty(indexesMatch)
            [~,ind]=min(abs(cell2mat(clusterOfNeighs(matchVert,4))-radius));
            pairOfVertices3D(nVert,:) = [vertId clusterOfNeighs{indexesMatch(ind),1}];
        %try match with extremes
        else
            matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,verticesInfoExtreme(:,2));
            indexesMatch=find(matchVert);
            %possible problem of resolution (usage of aux)
            if  isempty(indexesMatch)
                disp(['vertice ' num2str(vertId) ' without couple'])
                matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,verticesInfoExtremeAux(:,2));
                indexesMatch=find(matchVert);
                if  isempty(indexesMatch)
                    matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,clusterOfNeighsAux(:,3));
                    indexesMatch=find(matchVert);
                    if  isempty(indexesMatch)
                        disp('impossible matching. Maybe it matches with the other surface')
                    else
                        [~,ind]=min(abs(cell2mat(clusterOfNeighsAux(matchVert,4))-radius));
                        clusterOfNeighs(end+1,1:7)=[clusterOfNeighsAux(indexesMatch(ind),1:2),{clusterOfNeighs{end,3}+1},clusterOfNeighsAux(indexesMatch(ind),4:end)];
                        pairOfVertices3D(nVert,:) = [vertId clusterOfNeighs{end,3}];
                    end                        
                else
                    [~,ind]=min(abs(cell2mat(verticesInfoExtremeAux(matchVert,3))-radius));
                    verticesInfoExtreme(end+1,1:4)=[verticesInfoExtremeAux(indexesMatch(ind),1:3),{verticesInfoExtreme{end,4}+1}];
                    pairOfVertices3D(nVert,:) = [vertId verticesInfoExtreme{end,4}];
                end
            else
               [~,ind]=min(abs(cell2mat(verticesInfoExtreme(matchVert,3))-radius));
               pairOfVertices3D(nVert,:) = [vertId verticesInfoExtreme{indexesMatch(ind),4}];
            end
        end
    end

end
