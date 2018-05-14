load('neighbours_layer2.mat');
load('E:\Tina\pseudostratifiedEpithelia\LayerAnalysis\layerAnalysisVoronoi_16-Oct-2017.mat');
load('E:\Tina\pseudostratifiedEpithelia\LayerAnalysis\imgVoronoi2D_16-Oct-2017.mat');
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\LayersCentroids2.mat');
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingLayer2.mat');

%Variables
folderNumber=2;

%It takes the first column (cell id) and the third column (the layer to which the cell belongs)
for numLayer=1:size(LayerCentroid,1)
    for numC=1:size(finalCentroid,1)
        if finalCentroid{numC,3}(:)==numLayer
            cell_layer(numC,1)=finalCentroid{numC,1};
            cell_layer(numC,2)=finalCentroid{numC,3};
        end
    end
    
end

%It takes the unique id and the layer to which it belongs
cell_layer=unique(cell_layer,'rows');

%The nucleus and their neighbors are divided by layer
for numLayer=1:size(LayerCentroid,1)
    for numTrans=1:size(neighs_real,2)
        if cell_layer(numTrans,2)==numLayer
            all_neighs_layer{numLayer, numTrans}=neighs_real{1, numTrans};
        end
    end
end

%Remove neighbors which are from other layers
for numLayer=1:size(all_neighs_layer,1)
    for numTrans=1:size(all_neighs_layer,2)
        if isempty(all_neighs_layer{numLayer, numTrans})== 0
            for numNeighs=1:size(all_neighs_layer{numLayer, numTrans},1)
                if all_neighs_layer{numLayer, numTrans}(numNeighs,3)==numLayer 
                    neighs_layer{numLayer, numTrans}(numNeighs,:) = all_neighs_layer{numLayer, numTrans}(numNeighs,:);
                end
            end
        end
    end
end

%Zeros are removed
emptyCells=cell2mat(cellfun(@(x) isempty(x) ,neighs_layer,'UniformOutput', false));
neighs_layer(emptyCells)={0};
neighs_layer=cellfun(@(x) x(x(:,1)~=0,:) ,neighs_layer,'UniformOutput', false);


var=1;
numTrans=1;
for numLayer=1:size(neighs_layer,1)
    for numCell=1:size(neighs_layer,2)
        if isempty(neighs_layer{numLayer, numCell})== 0
            for numNeighs=1:size(neighs_layer{numLayer, numCell},1)
                
                transition{numLayer, numCell}(var,numTrans)=numCell; %Cojo la celula principal
                var=var+1;
                
                cellToComparate=neighs_layer{numLayer, numCell}(numNeighs,1);
                transition{numLayer, numCell}(var,numTrans)=cellToComparate;
                
                for numNeighs2=2:size(neighs_layer{numLayer, numCell},1)
                    newCellToComparate=neighs_layer{numLayer, numCell}(numNeighs2,1);
                    
                    if any(neighs_layer{numLayer, newCellToComparate}(:,1) == cellToComparate)
                        var =var+1;
                        transition{numLayer, numCell}(var,numTrans)=newCellToComparate;
                        if size(transition{numLayer, numCell}(:,numTrans),1)==4 && transition{numLayer, numCell}(4,numTrans)~=0
                            ult=transition{numLayer,numCell}(3,numTrans);
                            if any(neighs_layer{numLayer, newCellToComparate}(:,1)==ult)==0
                                transition{numLayer, numCell}(:,numTrans)=[];
                                var=1;
                            else
                                break;
                            end
                        end
                    end
                end
                
                if size(transition{numLayer, numCell},2)==numTrans
                    if (size(transition{numLayer, numCell}(:,numTrans),1) <4) || any(transition{numLayer, numCell}(:,numTrans)==0)
                        transition{numLayer, numCell}(:,numTrans)=[];
                        var=1;
                    elseif size(transition{numLayer, numCell}(:,numTrans),1) >= 4
                        numTrans=numTrans+1;
                        var=1;
                    end
                end
            end
            var=1;
            numTrans=1;
        end
    end
end

% Now that we have the result we have to clean it so that 
% the same transition does not come out many times and organize
% the result.
num=1;
for numLayer=1:size(transition,1)
    for numTrans=1:size(transition,2)
        if isempty(transition{numLayer, numTrans})== 0
            uniTrans=(unique(sort(transition{numLayer,numTrans},1)', 'rows'))';
            transitions{numLayer, num}=uniTrans;
            num=num+1;
        end
    end
    joinLayer=horzcat(transitions{numLayer, :});
    transition_layer{numLayer,1}=(unique(sort(joinLayer,1)', 'rows'))';
    transition_layer{numLayer,2}=size(transition_layer{numLayer,1},2);
    num=1;
end

%Transitions in the same Z
acum=1;
clear var
for numZ = 1:size(Img,2)-1 
    cents=regionprops(Img{1,numZ}, 'Centroid');
    cellFrame=vertcat(cents.Centroid);
    numZ
    [neighs_Z,sides_cellsZ]=calculateNeighbours(Img{1,numZ});
    for numLayer=1:size(transition_layer,1)
        for numTrans=1:transition_layer{numLayer,2}
            clear trans 
            trans=transition_layer{numLayer,1}(1:4, numTrans);
            for cellTrans=1:4
                if trans(cellTrans,1) <= size(cellFrame,1)
                    if isnan(cellFrame(trans(cellTrans,1)))==0
                        [isNeighbours, sum] = neighbour_frame(neighs_Z, trans, cellTrans);
                        if isNeighbours == 1
                            transition_layer_frame{numLayer,numZ}(cellTrans,numTrans)=trans(cellTrans,1);
                           
                            motive(cellTrans,1)=trans(cellTrans,1);
                            motive(cellTrans,2)=sum;
                        end
                    end
                end
            end
            if exist ('motive', 'var')
                if size(find(motive(:,2)==2),1)==4 || size(transition_layer_frame{numLayer,numZ}(:,numTrans),1) < 4 || any(transition_layer_frame{numLayer,numZ}(:,numTrans)==0)
                    transition_layer_frame{numLayer,numZ}(:,numTrans)=[];
                else
                     motive_trans_cross{numLayer,numZ}(:,numTrans)=motive(:,2);
                end
                clear motive
            end
        end
    end
end

% Loop to clear the transition_layer_frame variable from incomplete / invalid transitions
acum=1;
for numLayer=1:size(transition_layer_frame,1)
    for numZ=1:size(transition_layer_frame,2)
        if isempty(transition_layer_frame{numLayer,numZ})==0
            for numTrans=1:size(transition_layer_frame{numLayer,numZ},2)
                if all(transition_layer_frame{numLayer,numZ}(:,numTrans))~=0 %&& size(transition_layer_frame{numLayer,numZ}(:,numTrans),1)==4
                    transitionLayerFrame{numLayer,numZ}(:,acum)=transition_layer_frame{numLayer,numZ}(:,numTrans);
                    motiveTransCross{numLayer,numZ}(:,acum)=motive_trans_cross{numLayer,numZ}(:,numTrans);
                     acum=acum+1;
                end
            end
        end
        acum=1;
    end
end

for numLayer=1:size(transitionLayerFrame,1)
    joinTrans=horzcat(transitionLayerFrame{numLayer, :});
    trans_layer{numLayer,1}=(unique(sort(joinTrans,1)', 'rows'))';
    trans_layer{numLayer,2}=size(trans_layer{numLayer,1},2);
end


% This loop calculates all the frames that appear in the same transition

acum=1;
for numLayer=1:size(transitionLayerFrame,1)
    for numTransLayer=1:size(trans_layer{numLayer,1},2) %Se recorre las trans por capas
        transActual=trans_layer{numLayer,1}(:, numTransLayer);        
        for numZ=1:size(transitionLayerFrame,2)
            for numTransFrame=1:size(transitionLayerFrame{numLayer,numZ},2)
                if transitionLayerFrame{numLayer,numZ}(:,numTransFrame) == transActual
                    allFrameMotive{numLayer, numTransLayer}(acum,1)=numZ;
                    acum=acum+1;       
                end
            end
        end
        acum=1;
    end
    
end

% Now it is checked if the first and last frame that appears the transition
% change of neighbors between the same cells of the reason. If it varies they
% are saved and if not.
acum=1;
for numLayer=1:size(allFrameMotive,1)
    for numTransLayer=1:size(trans_layer{numLayer,1},2)
        transActual=trans_layer{numLayer,1}(:, numTransLayer);
            minZ=allFrameMotive{numLayer, numTransLayer}(1,1);
            maxZ=allFrameMotive{numLayer, numTransLayer}(end,1);
            for numTransFrame=1:size(transitionLayerFrame{numLayer, minZ},2)   
                if transitionLayerFrame{numLayer,minZ}(:,numTransFrame) == transActual
                    firstMotive=motiveTransCross{numLayer,minZ}(:,numTransFrame);
                    break
                end
            end
            for numTransFrame=1:size(transitionLayerFrame{numLayer, maxZ},2)
                if transitionLayerFrame{numLayer,maxZ}(:,numTransFrame) == transActual
                    finalMotive=motiveTransCross{numLayer,maxZ}(:,numTransFrame);
                    break
                end
            end
            
            if firstMotive~=finalMotive
                trans_Layer_Final{numLayer, 1}(:,acum)=trans_layer{numLayer,1}(:, numTransLayer);
                trans_Layer_Final{numLayer, 2}=acum;
                acum=acum+1;
            end
        
    end
    acum=1;
end

% The final variables are filtered with the last modification.
acum=1;
for numLayer=1:size(trans_Layer_Final,1)
    for numZ=1: size(transitionLayerFrame,2)
        for numTransLayer=1:size(trans_Layer_Final{numLayer,1},2)
            transActual=trans_Layer_Final{numLayer,1}(:, numTransLayer);
            for numTrans=1:size(transitionLayerFrame{numLayer,numZ},2)
                if transitionLayerFrame{numLayer,numZ}(:,numTrans) == transActual
                    transition_Layer_Frame{numLayer,numZ}(:,acum)=transitionLayerFrame{numLayer,numZ}(:,numTrans);
                    motiveFrame{numLayer,acum}(:,numTrans)=motiveTransCross{numLayer,numZ}(:,numTrans);
                    acum=acum+1;
                end
            end
        end
         acum=1;
    end
end

% Save the result to a .mat file
finalFileName=['transition_layers_frame' sprintf('%d',folderNumber) '.mat'];
save(finalFileName, 'neighs_layer', 'transitionLayerFrame', 'transition_Layer_Frame', 'trans_Layer_Final', 'motiveFrame');












