function uniqueClustersOfNeighs3D = buildClustersOfNeighs3D(image3DInfo,reductionFactor,centerImage)

    clustersOfNeighs3D={};
    for nCell=1:length(image3DInfo.neighbourhood)
       
        idxCellDilated=image3DInfo.cellDilated{nCell};
        neighsCellDilated=image3DInfo.neighbourhood{nCell};
        
        for nNeigh=1:length(neighsCellDilated)
            idxNeighCellDilated=image3DInfo.cellDilated{neighsCellDilated(nNeigh)};
            commomInd=ismember(idxCellDilated(:,1:3),idxNeighCellDilated,'rows');
            idxCellDilated(:,end+1)=commomInd*neighsCellDilated(nNeigh);
        end
        
        overlappedPixels = sum(idxCellDilated(:,4:end) > 0,2);
        %pixels overlapping 4 or more cells
        pixelsWithCross=overlappedPixels >= 3;
        
        crossCells = idxCellDilated(pixelsWithCross,4:end);
        idxCellDilated = idxCellDilated(pixelsWithCross,1:end);
        if sum(sum(crossCells))>0
            scutoidsMotifs=unique(crossCells,'rows');
            for nMotif=1:size(scutoidsMotifs,1)
               studiedMotif=scutoidsMotifs(nMotif,:);
               nFoldVertexCoord=idxCellDilated(ismember(crossCells,studiedMotif,'rows'),1:3);
               if size(nFoldVertexCoord,1)>1
                    coordVert=mean(nFoldVertexCoord);
               else
                    coordVert=nFoldVertexCoord;
               end
               motif=sort([nCell studiedMotif(studiedMotif~=0)]);
               coordOriginal=coordVert*reductionFactor;
               clustersOfNeighs3D(end+1,1:3)={coordOriginal,motif,pdist2(coordOriginal(1:2),centerImage)};               
            end
        end        
    end
    
    % convert to string and later unique
    C = cellfun(@(x) sprintf('%.99f ',x),clustersOfNeighs3D(:,2),'UniformOutput',false) ;
    [~,k] = unique(C,'stable');
    uniqueClustersOfNeighs3D = clustersOfNeighs3D(k,:);
 

end
