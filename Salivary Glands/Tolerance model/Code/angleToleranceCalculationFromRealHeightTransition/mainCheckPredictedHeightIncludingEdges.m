function [resultOfComparisonMean,resultOfComparisonMax,resultOfComparisonMedian] = mainCheckPredictedHeightIncludingEdges(pathStructure,frame,cellsGroup,hCell,curvature,meanAngleScaled,meanAngleWithoutScaled,maxAngleScaled,maxAngleWithoutScaled,medianAngleScaled,medianAngleWithoutScaled)


addpath lib
    
    %Load label image
    load(pathStructure)
    
    if frame=='end'
        Img=Seq_Img_L{end};
    else
        Img=Seq_Img_L{frame};
    end
    
    %Get only 4 cells neighborhood image
    mask=Img;
    mask1=mask;mask2=mask;mask3=mask;mask4=mask;
    mask1(mask~=cellsGroup(1))=0;mask2(mask~=cellsGroup(2))=0;mask3(mask~=cellsGroup(3))=0;mask4(mask~=cellsGroup(4))=0;
    mask=mask1+mask2+mask3+mask4;
    Img=mask;
    
    %Calculate neighbors
    [~,sidesCells]=calculateNeighbours(Img);
    neigh2sides=find(sidesCells==2);
    neigh3sides=find(sidesCells==3);
    
    %calculate distance between 2 cells neighs or non neighs between them
    centr=regionprops(Img,'Centroid');
    centr=cat(1,centr.Centroid);
    cent2neigh=centr(neigh2sides,:);
    cent3neigh=centr(neigh3sides,:);

    cent2Dist=pdist(cent2neigh);
    cent3Dist=pdist(cent3neigh);

    %% APLYING MEAN
    %H transitions
    hTransitionScaledMean=((cent2Dist*curvature)/2)/tand(meanAngleScaled);
    %angleWithoutScaled
    hTransitionWithoutScaledMean=(cent2Dist/2)/tand(meanAngleWithoutScaled);
    
    %% APLYING MEDIAN
    %H transitions
    hTransitionScaledMedian=((cent2Dist*curvature)/2)/tand(medianAngleScaled);
    %angleWithoutScaled
    hTransitionWithoutScaledMedian=(cent2Dist/2)/tand(medianAngleWithoutScaled);
    
    %% APLYING MAX
    %H transitions
    hTransitionScaledMax=((cent2Dist*curvature)/2)/tand(maxAngleScaled);   
    %angleWithoutScaled
    hTransitionWithoutScaledMax=(cent2Dist/2)/tand(maxAngleWithoutScaled);
    
    
    if hTransitionScaledMean>hCell
        result1=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanScaled-' num2str(hTransitionScaledMean)];
    else
        result1=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanScaled-' num2str(hTransitionScaledMean)];
    end
    
    if hTransitionWithoutScaledMean>hCell
        result2=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanWithoutScaled-' num2str(hTransitionWithoutScaledMean)];
    else
        result2=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanWithoutScaled-' num2str(hTransitionWithoutScaledMean)];
    end
        
    resultOfComparisonMean={result1;result2};

    
    if hTransitionScaledMax>hCell
        result1=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxScaled-' num2str(hTransitionScaledMax)];
    else
        result1=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxScaled-' num2str(hTransitionScaledMax)];
    end
    if hTransitionWithoutScaledMax>hCell
        result2=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxWithoutScaled-' num2str(hTransitionWithoutScaledMax)];
    else
        result2=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxWithoutScaled-' num2str(hTransitionWithoutScaledMax)];
    end
        
    resultOfComparisonMax={result1;result2};
    
    
    
    if hTransitionScaledMedian>hCell
        result1=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianScaled-' num2str(hTransitionScaledMedian)];
    else
        result1=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianScaled-' num2str(hTransitionScaledMedian)];
    end
    if hTransitionWithoutScaledMedian>hCell
        result2=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianWithoutScaled-' num2str(hTransitionWithoutScaledMedian)];
    else
        result2=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianWithoutScaled-' num2str(hTransitionWithoutScaledMedian)];
    end
    
    resultOfComparisonMedian={result1;result2};
    
end

