function  [pairOfVertices3DApicoBasal,verticesInfoExtreme] = joinVerticesApicoBasal(clusterOfNeighs,verticesInfoExtreme,verticesInfoExtremeAux)
    pairOfVertices3DApicoBasal=[];
    [~,b]=sort(cell2mat(clusterOfNeighs(:,4)));
    sortClusterOfNeighs=clusterOfNeighs(b,:);
    for nVert=1:size(sortClusterOfNeighs,1)
        vertId=sortClusterOfNeighs{nVert,1};
        cellsInVert=double(sortClusterOfNeighs{nVert,3});
        
        if nVert+1 < size(sortClusterOfNeighs,1)
            restOfClusterOfNeighs=sortClusterOfNeighs(nVert+1:end,:);
            matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))>=3,restOfClusterOfNeighs(:,3));
            indexesMatch=find(matchVert);
            if ~isempty(indexesMatch)
                if length(indexesMatch)<3
                    pairOfVertices3DApicoBasal(end+1,:) = [vertId restOfClusterOfNeighs{indexesMatch(1),1}];
                    if length(indexesMatch)==2
                        pairOfVertices3DApicoBasal(end+1,:) = [vertId restOfClusterOfNeighs{indexesMatch(2),1}];
                    end
                else
                    pairOfVertices3DApicoBasal(end+1,:) = [vertId restOfClusterOfNeighs{indexesMatch(1),1}];
                    memberFound=1;
                    cont=0;
                    while (memberFound~=0 && cont < length(indexesMatch))
                        cont=cont+1;
                        memberFound=sum(ismember(restOfClusterOfNeighs{indexesMatch(1),3},restOfClusterOfNeighs{indexesMatch(cont),3}))>=3;
                    end
                    if memberFound==0
                        pairOfVertices3DApicoBasal(end+1,:) = [vertId restOfClusterOfNeighs{indexesMatch(cont),1}];
                    end
                end
            %If the vertex has no pair, check the borders
            else
                matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,verticesInfoExtreme(:,2));
                if sum(matchVert)>0
                    pairOfVertices3DApicoBasal(end+1,:) = [vertId verticesInfoExtreme{matchVert(1),4}];
                    if sum(matchVert)>1
                        pairOfVertices3DApicoBasal(end+1,:) = [vertId verticesInfoExtreme{matchVert(2),4}];
                    end
                else
                    matchVert=cellfun(@(x) sum(ismember(cellsInVert,x))==3,verticesInfoExtremeAux(:,2));
                    indexesMatch=find(matchVert);
                    if isempty(indexesMatch)
                        disp(['vertice ' num2str(vertId) ' without couple'])
                    else
                        verticesInfoExtreme(end+1,1:4)=[verticesInfoExtremeAux(indexesMatch,1:3),{verticesInfoExtreme{end,4}+1}];
                        pairOfVertices3DApicoBasal(end+1,:) = [vertId verticesInfoExtreme{end,4}];
                    end
                end
            end
        end
        
    end
end