function [ basalDataTransition,basalDataNoTransition ] = measureAnglesAndLengthOfEdges( L_basal,neighs_basal,neighs_apical,noValidCells,neighThres)
%MEASUREANGLESANDLENGTHOFEDGES calculate the edge length and angle from all
%the possible edges classifing between transition and non-transition edges

    %classify neighbourings of basal
    pairOfNeighsBasal=(cellfun(@(x, y) [y*ones(length(x),1),x],neighs_basal',num2cell(1:length(neighs_basal)),'UniformOutput',false));
    uniquePairOfNeighBasal=unique(vertcat(pairOfNeighsBasal{:}),'rows');
    uniquePairOfNeighBasal=unique([min(uniquePairOfNeighBasal,[],2),max(uniquePairOfNeighBasal,[],2)],'rows');
    %dicard pair of neigh, when the 2 cells are no valid cells
    uniquePairOfNeighBasal= uniquePairOfNeighBasal(sum(ismember(uniquePairOfNeighBasal,noValidCells),2) < 2,:);
    
    basalData=struct('edgeLength',zeros(size(uniquePairOfNeighBasal,1),1),'edgeAngle',zeros(size(uniquePairOfNeighBasal,1),1));
    
    %loop dilating all cells
    cellsDilated=cell(max(max(uniquePairOfNeighBasal)),1);
    se=strel('disk',neighThres-2);
    for nCell=unique(uniquePairOfNeighBasal)'
        mask=zeros(size(L_basal));
        mask(L_basal==nCell)=1;
        cellsDilated{nCell}=logical(imdilate(mask,se));
    end
    
    %loop to get edge length and angle for each pair of neighborings
    for nCell=1:size(uniquePairOfNeighBasal,1)
        mask=cellsDilated{uniquePairOfNeighBasal(nCell,1)}.*cellsDilated{uniquePairOfNeighBasal(nCell,2)};
        edge1=regionprops(mask,'MajorAxisLength','Orientation');
%         if isempty(edge1)
%             basalData.edgeLength(nCell)=nan;
%             basalData.edgeAngle(nCell)=nan;
%         else
            basalData.edgeLength(nCell)=sum(vertcat(edge1.MajorAxisLength));
            basalData.edgeAngle(nCell)=edge1.Orientation;
%         end
    end
    
    %get edges of transitions
    Lossing=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
   
    pairOfLostNeigh=cellfun(@(x, y) [y*ones(length(x),1),x],Lossing',num2cell(1:length(neighs_basal)),'UniformOutput',false);
    pairOfLostNeigh=unique(vertcat(pairOfLostNeigh{:}),'rows');
    pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
    indexesEdgesTransition=ismember(uniquePairOfNeighBasal,pairOfLostNeigh,'rows');
    
    
    %define transition edge length and angle
    basalDataTransition=struct('edgeLength',zeros(sum(indexesEdgesTransition),1),'edgeAngle',zeros(sum(indexesEdgesTransition),1));
    basalDataTransition.edgeLength=cat(1,basalData.edgeLength(indexesEdgesTransition));
    basalDataTransition.edgeAngle=abs(cat(1,basalData.edgeAngle(indexesEdgesTransition)));
    
    %define no transition transition edge length and angle
    basalDataNoTransition.edgeLength=cat(1,basalData.edgeLength(logical(1-indexesEdgesTransition)));
    basalDataNoTransition.edgeAngle=abs(cat(1,basalData.edgeAngle(logical(1-indexesEdgesTransition))));
    
    %basalDataTransition
    anglesTransition=cat(1,basalDataTransition(:).edgeAngle);
    basalDataTransition.cellularMotifs=uniquePairOfNeighBasal(indexesEdgesTransition,:);
    basalDataTransition.numOfEdges=length(anglesTransition);
    basalDataTransition.proportionAnglesLess15deg=sum(anglesTransition<=15)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween15_30deg=sum(anglesTransition>15 & anglesTransition <= 30)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween30_45deg=sum(anglesTransition>30 & anglesTransition <= 45)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween45_60deg=sum(anglesTransition>45 & anglesTransition <= 60)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween60_75deg=sum(anglesTransition>60 & anglesTransition <= 75)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween75_90deg=sum(anglesTransition>75 & anglesTransition <= 90)/length(anglesTransition);
    
    %basalDataNoTransition
    anglesNoTransition=cat(1,basalDataNoTransition(:).edgeAngle);
    basalDataNoTransition.cellularMotifs=uniquePairOfNeighBasal(logical(1-indexesEdgesTransition),:);
    basalDataNoTransition.numOfEdges=length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesLess15deg=sum(anglesNoTransition<=15)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween15_30deg=sum(anglesNoTransition>15 & anglesNoTransition <= 30)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween30_45deg=sum(anglesNoTransition>30 & anglesNoTransition <= 45)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween45_60deg=sum(anglesNoTransition>45 & anglesNoTransition <= 60)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween60_75deg=sum(anglesNoTransition>60 & anglesNoTransition <= 75)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween75_90deg=sum(anglesNoTransition>75 & anglesNoTransition <= 90)/length(anglesNoTransition);
    
    
    
end

