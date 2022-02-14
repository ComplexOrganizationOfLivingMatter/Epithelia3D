clear all;
addpath(genpath('lib'));
voronoiRea = 1:10;
Sr=1:0.25:10;
nSeeds=200;
nRealizations=20;
initPath = fullfile('D:','Pedro','Epithelia3D','3D_laws','delaunayData','VoronoiRealizations');

 
for nVor = voronoiRea
   fileName = ['delaunayCyl_Voronoi' num2str(nVor) '_' num2str(nSeeds) 'seeds_sr10_18-Dec-2019.mat'];
   folderPath=fullfile(initPath,['Voronoi ' num2str(nVor)]);
   load(fullfile(folderPath,fileName),'neighsPerLayerGlobal','neighsAccumApicalToBasal');
   
   polDistPerSr = zeros(length(Sr)*2,8);
   polDist3DPerSr = zeros(length(Sr)*2,8);
   for nSr = 1:length(Sr)
      
       neighsSR = neighsPerLayerGlobal(:,nSr);
       neighs3DSR = neighsAccumApicalToBasal(:,nSr);
       poolDistSr = zeros(nRealizations,8);
       poolDist3DSr = zeros(nRealizations,8);
       for realization = 1:nRealizations
           polyDist = calculatePolygonDistribution(neighsSR{realization,:},1:length(horzcat(neighsSR{realization,:})));
           poolDistSr(realization,:)=horzcat(polyDist{2,:});
           
           polyDist3D = calculatePolygonDistribution(cellfun(@length,neighs3DSR{realization,:}),1:length(horzcat(cellfun(@length, neighs3DSR{realization,:}))));
           poolDist3DSr(realization,:)=horzcat(polyDist3D{2,:});
       end  
       
       meanPolDist = mean(poolDistSr);
       stdPolDist = std(poolDistSr);
       
       meanPolDist3D = mean(poolDist3DSr);
       stdPolDist3D = std(poolDist3DSr);
       
       polDistPerSr((nSr*2)-1:nSr*2,:)=[meanPolDist;stdPolDist];
       polDist3DPerSr((nSr*2)-1:nSr*2,:)=[meanPolDist3D;stdPolDist3D];
   end
   
   writetable(table(polDistPerSr),fullfile(initPath,['polyDist_basalSurfaces_Voronoi_' date '.xlsx']),'Sheet',['Voronoi' num2str(nVor)]);
   writetable(table(polDist3DPerSr),fullfile(initPath,['polyDist_3D_Voronoi_' date '.xlsx']),'Sheet',['Voronoi' num2str(nVor)]);

    
end