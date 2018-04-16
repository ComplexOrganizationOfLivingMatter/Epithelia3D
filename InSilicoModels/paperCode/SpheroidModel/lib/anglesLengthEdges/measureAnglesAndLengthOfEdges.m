function [ basalDataTransition,basalDataNoTransition ] = measureAnglesAndLengthOfEdges( L_apical,L_basal,neighsApical,neighsBasal,validCells,resolutionTreshold)
%MEASUREANGLESANDLENGTHOFEDGES

    %classify neighbourings of basal
    pairOfNeighsBasal=(cellfun(@(x, y) [y*ones(length(x),1),x],neighsBasal',num2cell(1:size(neighsBasal,2))','UniformOutput',false));
    uniquePairOfNeighBasal=unique(vertcat(pairOfNeighsBasal{:}),'rows');
    uniquePairOfNeighBasal=unique([min(uniquePairOfNeighBasal,[],2),max(uniquePairOfNeighBasal,[],2)],'rows');
    lengthEdgeOuter=zeros(size(uniquePairOfNeighBasal,1),1);
    angleEdgeOuter=zeros(size(uniquePairOfNeighBasal,1),1);
    
    totalCellsDilatedOuter=cell(max(unique(uniquePairOfNeighBasal)),1);
    for nCell=1:max(unique(uniquePairOfNeighBasal))
        if ismember(nCell,unique(uniquePairOfNeighBasal))
            se=strel('disk',2);
            maskOuter=zeros(size(L_basal));
            maskOuter(L_basal==nCell)=1;
            totalCellsDilatedOuter{nCell}=imdilate(maskOuter,se);
        end
    end
    
    %loop to get edge length and angle for each pair of neighborings
    indexesPassingTreshold=zeros(size(uniquePairOfNeighBasal,1),1)==1;
    for i=1:size(uniquePairOfNeighBasal,1)
        if any(ismember(uniquePairOfNeighBasal(i,:),validCells))
            maskOuter=bwlabel(totalCellsDilatedOuter{uniquePairOfNeighBasal(i,1)}.*totalCellsDilatedOuter{uniquePairOfNeighBasal(i,2)});
            edge1Outer=[];
            edge1Outer=regionprops(maskOuter,'MajorAxisLength','Orientation');
            if ~isempty(edge1Outer)
                [lengthEdgeOuter(i),indexMax]=max(vertcat(edge1Outer.MajorAxisLength));
                [x2,y2]=find(L_apical==uniquePairOfNeighBasal(i,1));
                [x1,y1]=find(L_apical==uniquePairOfNeighBasal(i,2));
                [distCellsApical]=pdist2([x1,y1],[x2,y2]);
                lengthEdgeInner=min(min(distCellsApical));
                %treshold to measure a motif due to lack of resolution = 5 pixels
                if ~isempty(lengthEdgeInner) && ~isempty(lengthEdgeOuter(i))
                    if (lengthEdgeInner==2 || lengthEdgeInner >resolutionTreshold) && (lengthEdgeOuter(i) > (resolutionTreshold+2))
                        angleEdgeOuter(i)=edge1Outer(indexMax).Orientation;
                        indexesPassingTreshold(i)=1;
                    end
                end
            end
        end
    end
    
    uniquePairOfNeighBasal=uniquePairOfNeighBasal(indexesPassingTreshold,:);
    lengthEdgeOuter=lengthEdgeOuter(indexesPassingTreshold);
    angleEdgeOuter=angleEdgeOuter(indexesPassingTreshold);
    %get edges of transitions
    Lossing=cellfun(@(x,y) setdiff(x,y),neighsBasal,neighsApical,'UniformOutput',false);
   
    pairOfLostNeigh=cellfun(@(x, y) [y*ones(length(x),1),x],Lossing',num2cell(1:size(neighsBasal,2))','UniformOutput',false);
    pairOfLostNeigh=unique(vertcat(pairOfLostNeigh{:}),'rows');
    pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
    indexesEdgesTransition=ismember(uniquePairOfNeighBasal,pairOfLostNeigh,'rows');
    
    %define transition edge length and angle
    basalDataTransition=struct('edgeLength',zeros(sum(indexesEdgesTransition),1),'edgeAngle',zeros(sum(indexesEdgesTransition),1));
    basalDataTransition.edgeLength=cat(1,lengthEdgeOuter(indexesEdgesTransition));
    basalDataTransition.edgeAngle=abs(cat(1,angleEdgeOuter(indexesEdgesTransition)));
    
    %define no transition transition edge length and angle
    basalDataNoTransition.edgeLength=cat(1,lengthEdgeOuter(logical(1-indexesEdgesTransition)));
    basalDataNoTransition.edgeAngle=abs(cat(1,angleEdgeOuter(logical(1-indexesEdgesTransition))));

    %basalDataTransition
    basalDataTransition.cellularMotifs=uniquePairOfNeighBasal(indexesEdgesTransition,:);
    basalDataTransition.numOfEdges=length(basalDataTransition.edgeAngle);
    anglesTransition=vertcat(basalDataTransition.edgeAngle);
    basalDataTransition.proportionAnglesLess15deg=sum(anglesTransition<=15)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween15_30deg=sum(anglesTransition>15 & anglesTransition <= 30)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween30_45deg=sum(anglesTransition>30 & anglesTransition <= 45)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween45_60deg=sum(anglesTransition>45 & anglesTransition <= 60)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween60_75deg=sum(anglesTransition>60 & anglesTransition <= 75)/length(anglesTransition);
    basalDataTransition.proportionAnglesBetween75_90deg=sum(anglesTransition>75 & anglesTransition <= 90)/length(anglesTransition);
    
    %basalDataNoTransition
    basalDataNoTransition.cellularMotifs=uniquePairOfNeighBasal(logical(1-indexesEdgesTransition),:);
    basalDataNoTransition.numOfEdges=length(basalDataNoTransition.edgeAngle);
    anglesNoTransition=vertcat(basalDataNoTransition.edgeAngle);
    basalDataNoTransition.proportionAnglesLess15deg=sum(anglesNoTransition<=15)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween15_30deg=sum(anglesNoTransition>15 & anglesNoTransition <= 30)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween30_45deg=sum(anglesNoTransition>30 & anglesNoTransition <= 45)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween45_60deg=sum(anglesNoTransition>45 & anglesNoTransition <= 60)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween60_75deg=sum(anglesNoTransition>60 & anglesNoTransition <= 75)/length(anglesNoTransition);
    basalDataNoTransition.proportionAnglesBetween75_90deg=sum(anglesNoTransition>75 & anglesNoTransition <= 90)/length(anglesNoTransition);
end

