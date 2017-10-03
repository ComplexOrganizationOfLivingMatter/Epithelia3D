function [ outerDataTransition,outerDataNoTransition ] = measureAnglesAndLengthOfEdges3Dcylinder( outerSurface,innerSurface)

    %% -- THIS CODE NEED TO BE REFACTOR WHEN MATLAB R2017B IS AVAILABLE -- %%


    %calculate neighbourings in apical and basal layers
    [neighs_outer,~]=calculate_neighbours3D(outerSurface);
    [neighs_inner,~]=calculate_neighbours3D(innerSurface);

    %classify neighbourings of basal
    pairOfNeighsOuter=(cellfun(@(x, y) [y*ones(length(x),1),x],neighs_outer',num2cell(1:size(neighs_outer,2))','UniformOutput',false));
    uniquePairOfNeighOuter=unique(vertcat(pairOfNeighsOuter{:}),'rows');
    uniquePairOfNeighOuter=unique([min(uniquePairOfNeighOuter,[],2),max(uniquePairOfNeighOuter,[],2)],'rows');

    outerData=struct('edgeLength',zeros(size(uniquePairOfNeighOuter,1),1),'edgeAngle',zeros(size(uniquePairOfNeighOuter,1),1));
    
    %loop to get edge length and angle for each pair of neighborings
    for i=1:size(uniquePairOfNeighOuter,1)
        mask1=zeros(size(outerSurface));
        mask2=zeros(size(outerSurface));
        mask1(outerSurface==uniquePairOfNeighOuter(i,1))=1;
        mask2(outerSurface==uniquePairOfNeighOuter(i,2))=1;
        
        %dilate neigh cells in 3D
        ratio=2;
        [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
        ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio); 
        mask3=imdilate(mask1,ball).*imdilate(mask2,ball);
        
        %%Regionprops3 to get data in 3-Dimensions. USE matlab2017b or
        %%later
        
%         edge1=regionprops(mask3,'MajorAxisLength','Orientation');
%         if edge1.MajorAxisLength > Wbasal/2
%             mask4=[mask3(:,round(Wbasal/2)+1:end) mask3(:,1:round(Wbasal/2))];
%             edge1=regionprops(mask4,'MajorAxisLength','Orientation');
%         end

        outerData(i).edgeLength=edge1(1).MajorAxisLength;
        outerData(i).edgeAngle=edge1(1).Orientation;
    end
    
    %get edges of transitions
    newInOuter=cellfun(@(x,y) setdiff(x,y),neighs_outer,neighs_inner,'UniformOutput',false);
   
    pairOfNewNeighsInOuter=cellfun(@(x, y) [y*ones(length(x),1),x],newInOuter',num2cell(1:size(neighs_outer,2))','UniformOutput',false);
    pairOfNewNeighsInOuter=unique(vertcat(pairOfNewNeighsInOuter{:}),'rows');
    pairOfNewNeighsInOuter=unique([min(pairOfNewNeighsInOuter,[],2),max(pairOfNewNeighsInOuter,[],2)],'rows');
    indexesOuterEdgesTransition=ismember(uniquePairOfNeighOuter,pairOfNewNeighsInOuter,'rows');
    
    
    %define transition edge length and angle
    outerDataTransition=struct('edgeLength',zeros(sum(indexesOuterEdgesTransition),1),'edgeAngle',zeros(sum(indexesOuterEdgesTransition),1));
    outerDataTransition.edgeLength=cat(1,outerData(indexesOuterEdgesTransition).edgeLength);
    outerDataTransition.edgeAngle=abs(cat(1,outerData(indexesOuterEdgesTransition).edgeAngle));
    
    %define no transition transition edge length and angle
    outerDataNoTransition.edgeLength=cat(1,outerData(logical(1-indexesOuterEdgesTransition)).edgeLength);
    outerDataNoTransition.edgeAngle=abs(cat(1,outerData(logical(1-indexesOuterEdgesTransition)).edgeAngle));

    %basalDataTransition
    anglesTransition=cat(1,outerDataTransition(:).edgeAngle);
    outerDataTransition.cellularMotifs=uniquePairOfNeighOuter(indexesOuterEdgesTransition,:);
    outerDataTransition.angles=anglesTransition;
    outerDataTransition.numOfEdges=length(anglesTransition);
    outerDataTransition.proportionAnglesLess15deg=sum(anglesTransition<=15)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween15_30deg=sum(anglesTransition>15 & anglesTransition <= 30)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween30_45deg=sum(anglesTransition>30 & anglesTransition <= 45)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween45_60deg=sum(anglesTransition>45 & anglesTransition <= 60)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween60_75deg=sum(anglesTransition>60 & anglesTransition <= 75)/length(anglesTransition);
    outerDataTransition.proportionAnglesBetween75_90deg=sum(anglesTransition>75 & anglesTransition <= 90)/length(anglesTransition);
    
    %basalDataNoTransition
    anglesNoTransition=cat(1,outerDataNoTransition(:).edgeAngle);
    outerDataNoTransition.cellularMotifs=uniquePairOfNeighOuter(logical(1-indexesOuterEdgesTransition),:);
    outerDataNoTransition.angles=anglesNoTransition;
    outerDataNoTransition.numOfEdges=length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesLess15deg=sum(anglesNoTransition<=15)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween15_30deg=sum(anglesNoTransition>15 & anglesNoTransition <= 30)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween30_45deg=sum(anglesNoTransition>30 & anglesNoTransition <= 45)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween45_60deg=sum(anglesNoTransition>45 & anglesNoTransition <= 60)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween60_75deg=sum(anglesNoTransition>60 & anglesNoTransition <= 75)/length(anglesNoTransition);
    outerDataNoTransition.proportionAnglesBetween75_90deg=sum(anglesNoTransition>75 & anglesNoTransition <= 90)/length(anglesNoTransition);
    
    

end

