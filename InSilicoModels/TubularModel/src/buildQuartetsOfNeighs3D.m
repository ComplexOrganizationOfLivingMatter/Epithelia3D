function clustersOfNeighs3D = buildQuartetsOfNeighs3D(image3DInfo)

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
               clustersOfNeighs3D(end+1,1:2)={coordVert,motif};               
            end
        end        
    end

end
