
numSeeds=[10,20,50,100,200,400];
pathVoronoiImages='..\..\data\expansion\512x1024_';
pathRoot2save='..\..\data\concavityAndConvexity\expansion\512x1024_';
numDiagrams=20;
numProjections=10;
nbins = 10;

for nSeeds=5:length(numSeeds)
    for i=1:numDiagrams   
        for j=1:numProjections
            path2load=[pathVoronoiImages num2str(numSeeds(nSeeds)) 'seeds\Image_' num2str(i) '_Diagram_5\Image_' num2str(i) '_Diagram_5.mat'];
            load(path2load,'listLOriginalProjection','listSeedsProjected');
            img=listLOriginalProjection.L_originalProjection{j,1};
            listSeeds=listSeedsProjected.seedsApical{j,1};
            
            %testing convexity of edges per cell
            [propConvexity,propStraightEdges]=testConvexity(img,listSeeds);
            
            f=figure('Visible','off');
            h1=histogram(propConvexity,nbins,'Normalization','probability');
            h1.BinWidth = 0.1;ylim([0,1]);xlim([0,1]); xlabel('percentage of convexity'); ylabel('frequency');
            path2save=[pathRoot2save num2str(numSeeds(nSeeds)) 'seeds\Image_' num2str(i) '_Diagram_5\'];
            mkdir(path2save);
            saveas(f,[path2save num2str(listLOriginalProjection.surfaceRatio(j,1)) '.tiff'], 'tif')
            close
            
        end
    end
end

