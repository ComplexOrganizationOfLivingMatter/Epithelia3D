

relativePath='results\ProcessedImg\';

addpath('src\lib')
addpath('src\libEnergy')

tableEnergy=table();

for i = [1:5, 7]
    motifsNames=dir([relativePath '50epib_' num2str(i) '\SegmentedMotifs\*.tif']);

    motifsNames={motifsNames(:).name};
    
    for j=1:length(motifsNames)
    
        Img=im2bw(imread([relativePath '50epib_' num2str(i) '\SegmentedMotifs\' motifsNames{j}]));
        
        Img_w = double(watershed(Img));
        [neighs,~]=calculateNeighbours(Img_w);
        
        noValidCells=unique([Img_w(1,1),Img_w(1,end),Img_w(end,end),Img_w(end,1)]);
        verticesInfo=calculateVertices(Img_w,neighs);
        
        emptyVertices=cellfun(@(x) ~isempty(x),verticesInfo.verticesPerCell,'UniformOutput',true);
        verticesInfo.verticesPerCell=verticesInfo.verticesPerCell(emptyVertices,:);
        verticesInfo.verticesConnectCells=verticesInfo.verticesConnectCells(emptyVertices,:);
       
        neighsValid=cellfun(@(x) setdiff(x,noValidCells),neighs,'UniformOutput',false);
        
        
        if strcmp(motifsNames{j},'Motif_14 end_022.tif')
            
        end
        
       
        %get couples of edges
        pairCell=cellfun(@(x, y) [y*ones(length(x),1),x],neighs',num2cell(1:size(neighs,2))','UniformOutput',false);
        pairCell=unique(vertcat(pairCell{:}),'rows');
        pairCell=unique([min(pairCell,[],2),max(pairCell,[],2)],'rows');   
    
        %all vertices
        verticesPerCell=arrayfun(@(x) find(sum(x==verticesInfo.verticesConnectCells,2)), 1:max(max(Img_w)), 'UniformOutput', false);

        %vertices of edges transition
        verticesOfEdges=arrayfun(@(x,y) intersect(verticesPerCell{x},verticesPerCell{y}), pairCell(:,1),pairCell(:,2),'UniformOutput',false);
        fourCellsMotifs=cellfun(@(x) unique(horzcat(verticesInfo.verticesConnectCells(x,:))),verticesOfEdges, 'UniformOutput', false);
        validPairs1=cell2mat(cellfun(@(x) isempty(intersect(noValidCells,x)) & length(x)==4 ,fourCellsMotifs,'UniformOutput',false));

        if sum(validPairs1)==0
            validPairs1=cell2mat(cellfun(@(x) length(setdiff(x,noValidCells))==4 ,fourCellsMotifs,'UniformOutput',false));
            fourCellsMotifsValidCells={setdiff(fourCellsMotifs{validPairs1,:},noValidCells)};
        else
            fourCellsMotifsValidCells=fourCellsMotifs(validPairs1,:);
        end
        
        pairCellValidCells=pairCell(validPairs1,:);
        

        cellsInMotifContactingCellsEdge=cell2mat(arrayfun(@(x) setdiff(fourCellsMotifsValidCells{x},pairCellValidCells(x,:))',1:size(pairCellValidCells,1), 'UniformOutput', false));
    
        dataEnergy.nEpibolium= i;
        dataEnergy.motif= motifsNames{j}(1:end-11);
        
        ['epibolium:' num2str(i) ' motif:' motifsNames{j}]
        
        
        
        [dataEnergy.EdgeLength,dataEnergy.SumEdgesOfEnergy,dataEnergy.EdgeAngle,dataEnergy.H1,dataEnergy.H2,dataEnergy.W1,dataEnergy.W2,notEmptyIndexes]=capturingWidthHeightAndEnergy(verticesPerCell,verticesInfo,pairCellValidCells,cellsInMotifContactingCellsEdge);
   
        dataEnergy.nEpibolium=dataEnergy.nEpibolium(notEmptyIndexes);
        dataEnergy.motif={dataEnergy(notEmptyIndexes,:).motif};
        dataEnergy.H1=dataEnergy.H1(notEmptyIndexes);
        dataEnergy.H2=dataEnergy.H2(notEmptyIndexes);
        dataEnergy.W1=dataEnergy.W1(notEmptyIndexes);
        dataEnergy.W2=dataEnergy.W2(notEmptyIndexes);
        dataEnergy.SumEdgesOfEnergy=dataEnergy.SumEdgesOfEnergy(notEmptyIndexes);
        dataEnergy.EdgeLength=dataEnergy.EdgeLength(notEmptyIndexes);
        dataEnergy.EdgeAngle=dataEnergy.EdgeAngle(notEmptyIndexes);
    
        sumTableEnergy=struct2table(dataEnergy);
        nanIndex=isnan(sumTableEnergy.H1);
        sumTableEnergy=sumTableEnergy(~nanIndex,:);
        
        tableEnergy=[tableEnergy;sumTableEnergy];

        
    end
    
end
directory2save='results\energyMeasurements\';
mkdir(directory2save);

writetable(tableEnergy,[directory2save 'zebrafishEnergyMeasurements_' date '.xls'],'sheet','Hoja1')
