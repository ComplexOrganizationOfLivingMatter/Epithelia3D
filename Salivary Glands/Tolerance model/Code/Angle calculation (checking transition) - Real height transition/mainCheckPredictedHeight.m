function [resultOfComparisonMean,resultOfComparisonMax,resultOfComparisonMedian] = mainCheckPredictedHeight(pathStructure,frame,cellsGroup,hCell,curvature,meanAngleScaled,meanAngleScaled2,meanAngleWithoutScaled,meanAngleWithoutScaled2,maxAngleScaled,maxAngleScaled2,maxAngleWithoutScaled,maxAngleWithoutScaled2,medianAngleScaled,medianAngleScaled2,medianAngleWithoutScaled,medianAngleWithoutScaled2)


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
    hTransitionScaledMean2=((cent3Dist*curvature)/2)/tand(meanAngleScaled2);
    
    %angleWithoutScaled
    hTransitionWithoutScaledMean=(cent2Dist/2)/tand(meanAngleWithoutScaled);
    hTransitionWithoutScaledMean2=(cent3Dist/2)/tand(meanAngleWithoutScaled2);
    
    %% APLYING MEDIAN
    
    %H transitions
    hTransitionScaledMedian=((cent2Dist*curvature)/2)/tand(medianAngleScaled);
    hTransitionScaledMedian2=((cent3Dist*curvature)/2)/tand(medianAngleScaled2);
    
    %angleWithoutScaled
    hTransitionWithoutScaledMedian=(cent2Dist/2)/tand(medianAngleWithoutScaled);
    hTransitionWithoutScaledMedian2=(cent3Dist/2)/tand(medianAngleWithoutScaled2);
    
    %% APLYING MAX
    %H transitions
    hTransitionScaledMax=((cent2Dist*curvature)/2)/tand(maxAngleScaled);
    hTransitionScaledMax2=((cent3Dist*curvature)/2)/tand(maxAngleScaled2);
    
    %angleWithoutScaled
    hTransitionWithoutScaledMax=(cent2Dist/2)/tand(maxAngleWithoutScaled);
    hTransitionWithoutScaledMax2=(cent3Dist/2)/tand(maxAngleWithoutScaled2);
    
    
    if hTransitionScaledMean>hCell
        result1=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanScaled-' num2str(hTransitionScaledMean)];
    else
        result1=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanScaled-' num2str(hTransitionScaledMean)];
    end
    if hTransitionScaledMean2>hCell
        result2=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanScaled2-' num2str(hTransitionScaledMean2)];
    else
        result2=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanScaled2-' num2str(hTransitionScaledMean2)];
    end
    if hTransitionWithoutScaledMean>hCell
        result3=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanWithoutScaled-' num2str(hTransitionWithoutScaledMean)];
    else
        result3=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanWithoutScaled-' num2str(hTransitionWithoutScaledMean)];
    end
    if hTransitionWithoutScaledMean2>hCell
        result4=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanWithoutScaled2-' num2str(hTransitionWithoutScaledMean2)];
    else
        result4=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMeanWithoutScaled2-' num2str(hTransitionWithoutScaledMean2)];
    end
    
    resultOfComparisonMean={result1;result2;result3;result4};

    
    if hTransitionScaledMax>hCell
        result1=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxScaled-' num2str(hTransitionScaledMax)];
    else
        result1=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxScaled-' num2str(hTransitionScaledMax)];
    end
    if hTransitionScaledMax2>hCell
        result2=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxScaled2-' num2str(hTransitionScaledMax2)];
    else
        result2=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxScaled2-' num2str(hTransitionScaledMax2)];
    end
    if hTransitionWithoutScaledMax>hCell
        result3=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxWithoutScaled-' num2str(hTransitionWithoutScaledMax)];
    else
        result3=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxWithoutScaled-' num2str(hTransitionWithoutScaledMax)];
    end
    if hTransitionWithoutScaledMax2>hCell
        result4=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxWithoutScaled2-' num2str(hTransitionWithoutScaledMax2)];
    else
        result4=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMaxWithoutScaled2-' num2str(hTransitionWithoutScaledMax2)];
    end
    
    resultOfComparisonMax={result1;result2;result3;result4};
    
    
    
    if hTransitionScaledMedian>hCell
        result1=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianScaled-' num2str(hTransitionScaledMedian)];
    else
        result1=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianScaled-' num2str(hTransitionScaledMedian)];
    end
    if hTransitionScaledMedian2>hCell
        result2=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianScaled2-' num2str(hTransitionScaledMedian2)];
    else
        result2=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianScaled2-' num2str(hTransitionScaledMedian2)];
    end
    if hTransitionWithoutScaledMedian>hCell
        result3=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianWithoutScaled-' num2str(hTransitionWithoutScaledMedian)];
    else
        result3=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianWithoutScaled-' num2str(hTransitionWithoutScaledMedian)];
    end
    if hTransitionWithoutScaledMedian2>hCell
        result4=['Heigh of cell is LOWER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianWithoutScaled2-' num2str(hTransitionWithoutScaledMedian2)];
    else
        result4=['Heigh of cell is HIGHER than height of transition: hCell-' num2str(hCell) ' VS hTransitionMedianWithoutScaled2-' num2str(hTransitionWithoutScaledMedian2)];
    end
    
    resultOfComparisonMedian={result1;result2;result3;result4};
    
end

