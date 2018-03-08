%main
%we analyse the energy measurements from the expanded cylindrical voronoi
%images

addpath lib
addpath libEnergy

surfaceRatios= [0 1/0.9 1/0.8 1/0.7 1/0.6 1/0.5 1/0.4 1/0.3 1/0.2 1/0.1];


apicalReductions=[0 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];


numSeeds=[50,100,200,400];
numRandoms=20;

typeProjection= 'reduction';
relativePath= ['..\..\data\voronoiModel\' typeProjection '\512x1024_'];

if ~isempty(strfind(typeProjection,'expansion'))
    numSurfaces=length(surfaceRatios);
else
    numSurfaces=length(apicalReductions);
end


for nSeeds=numSeeds
        
    for i=1:numSurfaces
        tableNoTransitionEnergy=table();
        tableNoTransitionEnergyFiltering200data=table();
    
        for nRand=1:numRandoms
            
            if ~isempty(strfind(typeProjection,'expansion'))
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
                L_img=listLOriginalProjection.L_originalProjection{1};
                surfaceRatio=surfaceRatios(i);
                
                ['surface ratio - expansion: ' num2str(surfaceRatio) ]
                
            else
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalApical')            
                indexImage=10-10*apicalReductions(i);
                surfaceRatio=1/(1-apicalReductions(i));
                L_img=listLOriginalApical.L_originalApical{end};
                ['surface ratio - reduction: ' num2str(surfaceRatio) ]
            
            
            
            end
            
            
            ['number of randomization: ' num2str(nRand)]
            
            
            %calculate neighbourings in apical layers
            [neighs,~]=calculateNeighbours(L_img);
            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_img(1,:),L_img(size(L_img,1),:)]);
            
            %get vertices apical
            [vertices]=calculateVertices(L_img,neighs);
            notEmptyCells=cellfun(@(x) ~isempty(x),vertices.verticesPerCell,'UniformOutput',true);
            vertices.verticesPerCell=vertices.verticesPerCell(notEmptyCells,:);
            vertices.verticesConnectCells=vertices.verticesConnectCells(notEmptyCells,:);

            %get vertices in new basal
            if ~isempty(strfind(typeProjection,'expansion'))
                verticesProjection.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*surfaceRatio)],vertices.verticesPerCell,'UniformOutput',false);
                verticesProjection.verticesConnectCells=vertices.verticesConnectCells;
                dataEnergy = getEnergyFromEdges( L_img,neighs,noValidCells,vertices,verticesProjection,surfaceRatio);
            else
                verticesProjection.verticesPerCell=cellfun(@(x) [x(1,1),round(x(1,2)*(1-apicalReductions(i)))],vertices.verticesPerCell,'UniformOutput',false);
                verticesProjection.verticesConnectCells=vertices.verticesConnectCells;
                dataEnergy = getEnergyFromEdges( L_img,neighs,noValidCells,vertices,verticesProjection,(1-apicalReductions(i)));
            end
            
            
            
            dataEnergy.nRand=nRand*ones(size(dataEnergy.H1,1),1);
            dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.H1,1),1);
            dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.H1,1),1);

            %filtering 10 data for each realization  
            sumTableEnergy=struct2table(dataEnergy);
            nanIndex=isnan(sumTableEnergy.H1);
            sumTableEnergy=sumTableEnergy(~nanIndex,:);
            pos = randperm(size(sumTableEnergy,1));
            if length(pos)>=10
                pos = pos(1:10);
            end

            %storing all data and filtered 10 data per realization (IF there are more than 10)
            tableNoTransitionEnergy=[tableNoTransitionEnergy;sumTableEnergy];
            tableNoTransitionEnergyFiltering200data=[tableNoTransitionEnergyFiltering200data;sumTableEnergy(pos,:)];
            
                                            
        end
            
       
        directory2save=['..\..\data\vertexModel\energyMeasurements\' typeProjection '\' num2str(nSeeds) 'seeds\' date '\'];
        mkdir(directory2save);
        
        writetable(tableNoTransitionEnergy,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date '.xls'])
        writetable(tableNoTransitionEnergyFiltering200data,[directory2save 'allFrustaEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_filter200measurements_' date '.xls'])
        
        
    end
end