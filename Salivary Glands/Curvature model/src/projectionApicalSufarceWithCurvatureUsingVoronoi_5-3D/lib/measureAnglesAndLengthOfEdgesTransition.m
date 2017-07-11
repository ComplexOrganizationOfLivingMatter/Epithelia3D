function [dataAngles] = measureAnglesAndLengthOfEdgesTransition(L_original,L_originalApical)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        [neighs_basal,~]=calculate_neighbours(L_original);
        [neighs_apical,~]=calculate_neighbours(L_originalApical);
        
        
        %check lost neighbors 
        Lossing={};
        for i=1:length(neighs_basal)
            Lossing{end+1,1} = setdiff(neighs_basal{i},neighs_apical{i});
        end
        
        pairOfLostNeigh=[];
        for i=1:length(Lossing) 
            if ~isempty(Lossing{i})
                pairOfLostNeigh(end+1:end+length(Lossing{i}),:)=[Lossing{i},ones(length(Lossing{i}),1)*i];
            end
        end
        pairOfLostNeigh=unique([min(pairOfLostNeigh,[],2),max(pairOfLostNeigh,[],2)],'rows');
        
        neighOfEdges=arrayfun(@(x,y) intersect(neighs_basal{[x y]}),pairOfLostNeigh(:,1),pairOfLostNeigh(:,2),'UniformOutput',false);
        for i=1:length(neighOfEdges)
            pairOfLostNeigh(i,3:2+length(neighOfEdges{i}))=neighOfEdges{i}';
        end
        
        if size(pairOfLostNeigh,2)>4
            [row,~]=find(pairOfLostNeigh(:,5)>0);
            pairOfLostNeigh(row,:)=[];
        end
        pairOfLostNeigh=pairOfLostNeigh(:,1:4);
        [row,~]=find(pairOfLostNeigh==0);
        pairOfLostNeigh(row,:)=[];
        
        %% Calculate vertices of edges for involved motif in transitions
        radius=3;
        se=strel('square',radius);
        vertices=cell(size(pairOfLostNeigh,1),2);
        angles=[];
        edgesLength=[];
        for i=1:size(pairOfLostNeigh,1)
            [H,W]=size(L_original);            
            BW1=zeros(H,W);BW2=BW1;BW3=BW1;BW4=BW1;borderImg=zeros(H,W);
            BW1(L_original==pairOfLostNeigh(i,1))=1;BW2(L_original==pairOfLostNeigh(i,2))=1;% 1 and 2 are neighs in apical, but not in basal
            BW3(L_original==pairOfLostNeigh(i,3))=1;BW4(L_original==pairOfLostNeigh(i,4))=1;
            BW1_dilate=imdilate(BW1,se);BW2_dilate=imdilate(BW2,se);BW3_dilate=imdilate(BW3,se);BW4_dilate=imdilate(BW4,se); %dilated mask
            borderImg(L_original==0)=1; 
            [row1,col1]=find((BW1_dilate.*BW2_dilate.*BW3_dilate.*borderImg)==1);
            [row2,col2]=find((BW1_dilate.*BW2_dilate.*BW4_dilate.*borderImg)==1);
            
            %doing planar the cylinder coordinates
            if abs(col1-col2)>(W/2)
                if col1>col2
                    col2=col2+W;
                else
                    col1=col1+W;
                end
            end
            
            vertices{i,1}=[row1,col1];
            vertices{i,2}=[row2,col2];
          
            if ~isempty(vertices{i,1}) && ~isempty(vertices{i,2})
                %made vector from vertices
                v1=vertices{i,2}-vertices{i,1};
                %angle between vector in X axis and v1
                angles(i,1)=rad2deg(atan2(norm(cross([v1,0],[0,1,0])),dot(v1,[0,1])));
                %length of edge
                edgesLength(i,1)=pdist([vertices{i,1};vertices{i,2}]);
            else
                angles(i,1)=NaN;
                edgesLength(i,1)=NaN;
            end

        end
            
        angles(angles>90)= 180-angles(angles>90);
        vertices=vertices(~isnan(angles),:);
        angles=angles(~isnan(angles));
        pairOfLostNeigh=pairOfLostNeigh(~isnan(angles),:);
        edgesLength=edgesLength(~isnan(edgesLength));
        
        dataAngles.cellularMotifs=pairOfLostNeigh;
        dataAngles.angles=angles;
        dataAngles.verticesEdges=vertices;
        dataAngles.edgeLength=edgesLength;
        dataAngles.numOfEdgesOfTransition=size(edgesLength,1);
        dataAngles.proportionAnglesLess15deg=sum(angles<15)/length(angles);
        dataAngles.proportionAnglesBetween15_30deg=sum(angles>=15 & angles < 30)/length(angles);
        dataAngles.proportionAnglesBetween30_45deg=sum(angles>=30 & angles < 45)/length(angles);
        dataAngles.proportionAnglesBetween45_60deg=sum(angles>=45 & angles < 60)/length(angles);
        dataAngles.proportionAnglesBetween60_75deg=sum(angles>=60 & angles < 75)/length(angles);
        dataAngles.proportionAnglesBetween75_90deg=sum(angles>=75 & angles <= 90)/length(angles);
        
end


