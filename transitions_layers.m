load('neighbours_layer1.mat');
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample1\LayersCentroids1.mat');
load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample1\trackingCentroids1.mat');

LayerCentroid(LayerCentroid{5,1})=[];

for numLayer=1:size(LayerCentroid,1)
    for numC=1:size(finalCentroid,1)
        if finalCentroid{numC,3}(:)==numLayer
            cell_layer(numC,1)=finalCentroid{numC,1};
            cell_layer(numC,2)=finalCentroid{numC,3};
        end
    end
    
end

cell_layer=unique(cell_layer,'rows');

for numLayer=1:size(LayerCentroid,1)
    for numCell=1:size(neighs_real,2)
        if cell_layer(numCell,2)==numLayer
            all_neighs_layer{numLayer, numCell}=neighs_real{1, numCell};
        end
    end
end

for numLayer=1:size(all_neighs_layer,1)
    for numCell=1:size(all_neighs_layer,2)
        if isempty(all_neighs_layer{numLayer, numCell})== 0
            for numNeighs=1:size(all_neighs_layer{numLayer, numCell},1)
                if all_neighs_layer{numLayer, numCell}(numNeighs,3)==numLayer %|| isempty(all_neighs_layer{numLayer, numCell})== 0
                    neighs_layer{numLayer, numCell}(numNeighs,:) = all_neighs_layer{numLayer, numCell}(numNeighs,:);
                end
            end
        end
        %Bucle de abajo aquí ?
    end
end


emptyCells=cell2mat(cellfun(@(x) isempty(x) ,neighs_layer,'UniformOutput', false));
neighs_layer(emptyCells)={0};
neighs_layer=cellfun(@(x) x(x(:,1)~=0,:) ,neighs_layer,'UniformOutput', false);


var=1;
numTrans=1;
for numLayer=1:size(neighs_layer,1)
%     numLayer
    for numCell=1:size(neighs_layer,2)
%         numCell
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

%Ahora que tenemos el resultado tenemos que limpiarlo para que no salga la
%misma transición muchas veces y organizar el resultado. Por último,
%salvarlo.
num=1;
for numLayer=1:size(transition,1)
    for numCell=1:size(transition,2)
        if isempty(transition{numLayer, numCell})== 0
            uniTrans=(unique(sort(transition{numLayer,numCell},1)', 'rows'))';
            transitions{numLayer, num}=uniTrans;
            num=num+1;
        end
    end
    joinLayer=horzcat(transitions{numLayer, :});
    transition_layer{numLayer,1}=(unique(sort(joinLayer,1)', 'rows'))';
    transition_layer{numLayer,2}=size(transition_layer{numLayer,1},2);
    num=1;
end

% Save the result to a .mat file
%finalFileName=['transition_layers' sprintf('%d',folderNumber) '.mat'];
save('transition_layers1.mat', 'transition_layer');












