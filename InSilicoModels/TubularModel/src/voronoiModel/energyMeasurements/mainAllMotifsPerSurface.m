addpath lib
addpath libEnergy

surfaceRatios= [1 1/0.9 1/0.8 1/0.7 1/0.6 1/0.5 1/0.4 1/0.3 1/0.2 1/0.1];

apicalReductions=[0 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];


numSeeds=200;%[50,100,200,400];
numRandoms=20;
numSurfaces=length(surfaceRatios);

typeProjection= 'reduction';
relativePath= ['..\..\..\data\voronoiModel\' typeProjection  '\512x1024_'];



for nSeeds=numSeeds
        
    for i=1:numSurfaces
        tableEnergy=table();
          
        for nRand=1:numRandoms
            
            if ~isempty(strfind(typeProjection,'expansion'))
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalProjection')            
                surfaceRatio=surfaceRatios(i);
                indexImage=10-(1/(surfaceRatio)*10)+1;
                L_img=listLOriginalProjection.L_originalProjection{indexImage};
                ['surface ratio - expansion: ' num2str(surfaceRatio) ]
            
            else
                load([relativePath num2str(nSeeds) 'seeds\Image_' num2str(nRand) '_Diagram_5\Image_' num2str(nRand) '_Diagram_5.mat'],'listLOriginalApical')            
                indexImage=10-10*apicalReductions(i);
                surfaceRatio=1/(1-apicalReductions(i));
                L_img=listLOriginalApical.L_originalApical{indexImage};
                ['surface ratio - reduction: ' num2str(surfaceRatio) ]
            
            
            end
            
            ['number of randomization: ' num2str(nRand)]
            
            %calculate neighbourings in apical and basal layers
            [neighs,~]=calculateNeighbours(L_img);

            %no valid cells. No valid in apical or basal
            noValidCells=unique([L_img(1,:),L_img(size(L_img,1),:)]);
           
            [ dataEnergy ] = getEnergyFromAllMotifs(L_img,neighs,noValidCells);
            dataEnergy.nRand=nRand*ones(size(dataEnergy.H1,1),1);
            dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.H1,1),1);
            dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.H1,1),1);
                
            %filtering 10 data for each realization  
            sumTableEnergy=struct2table(dataEnergy);
            nanIndex=(isnan(sumTableEnergy.H1));
            sumTableEnergy=sumTableEnergy(~nanIndex,:);

            %storing all data and filtered 10 data per realization (IF there are more than 10)
            tableEnergy=[tableEnergy;sumTableEnergy];
                
        end
            
       
        directory2save=['..\..\..\data\voronoiModel\energyMeasurements\' typeProjection '\AllMotifs\' num2str(nSeeds) 'seeds\' date '\'];
        mkdir(directory2save);
        
        writetable(tableEnergy,[directory2save 'allMotifsEnergy_' num2str(nSeeds) 'seeds_surfaceRatio_' num2str(surfaceRatio) '_' date  '.xls'])
        
        
    end
end