function [ basalDataTransition,basalDataNoTransition ] = measureAnglesAndLengthOfEdges( L_basal,L_apical)

    %calculate neighbourings in apical and basal layers
    [neighs_basal,~]=calculateNeighbours(L_basal);
    [neighs_apical,~]=calculateNeighbours(L_apical);

    %classify neighbourings of basal
    pairOfNeighsBasal=(cellfun(@(x, y) [y*ones(length(x),1),x],neighs_basal',num2cell(1:size(neighs_basal,2))','UniformOutput',false));
    uniquePairOfNeighBasal=unique(vertcat(pairOfNeighsBasal{:}),'rows');
    uniquePairOfNeighBasal=unique([min(uniquePairOfNeighBasal,[],2),max(uniquePairOfNeighBasal,[],2)],'rows');
    basalData=struct('edgeLength',zeros(size(uniquePairOfNeighBasal,1),1),'edgeAngle',zeros(size(uniquePairOfNeighBasal,1),1));
    
    %loop dilating all cells
    cellsDilated=cell(max(max(uniquePairOfNeighBasal)),1);
    se=strel('disk',2);
    for i=1:max(max(uniquePairOfNeighBasal))
     mask1=zeros(size(L_basal));
     mask1(L_basal==i)=1;
     cellsDilated{i}=imdilate(mask1,se);
    end
    
    %loop to get edge length and angle for each pair of neighborings
    for i=1:size(uniquePairOfNeighBasal,1)
        mask2=cellsDilated{uniquePairOfNeighBasal(i,1)}.*cellsDilated{uniquePairOfNeighBasal(i,2)};
        edge1=regionprops(mask2,'MajorAxisLength','Orientation');
        basalData(i).edgeLength=sum(vertcat(edge1.MajorAxisLength));
        basalData(i).edgeAngle=edge1.Orientation;
    end
    
    %get edges of transitions
    Lossing=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
   
    pairOfLostNeigh=cellfun(@(x, y) [y*ones(length(x),1),x],Lossing',num2cell(1:size(neighs_basal,2))','UniformOutput',false);
    pairOfLostNeigh=unique(vertcat(pairOfLostNeigh{:}),'rows');
    pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
    indexesEdgesTransition=ismember(uniquePairOfNeighBasal,pairOfLostNeigh,'rows');
    
    
    %define transition edge length and angle
    basalDataTransition=struct('edgeLength',zeros(sum(indexesEdgesTransition),1),'edgeAngle',zeros(sum(indexesEdgesTransition),1));
    basalDataTransition.edgeLength=cat(1,basalData(indexesEdgesTransition).edgeLength);
    basalDataTransition.edgeAngle=abs(cat(1,basalData(indexesEdgesTransition).edgeAngle));
    
    %define no transition transition edge length and angle
    basalDataNoTransition.edgeLength=cat(1,basalData(logical(1-indexesEdgesTransition)).edgeLength);
    basalDataNoTransition.edgeAngle=abs(cat(1,basalData(logical(1-indexesEdgesTransition)).edgeAngle));
    
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

