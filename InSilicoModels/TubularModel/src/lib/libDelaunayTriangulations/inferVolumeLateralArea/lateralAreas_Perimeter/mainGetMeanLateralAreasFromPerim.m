clear all 
close all
xlsFiles=dir('perimData\tablePerim_*.xls');


for nFile = 1:size(xlsFiles,1)
    
   tableData = table2array(readtable(fullfile(xlsFiles(nFile).folder,xlsFiles(nFile).name)));
   cellIds = tableData(:,1);
   cellPerim = tableData(:,2:end);
   nRealizations = 20;
   cellLateralArea = zeros(size(cellPerim));

   if contains(xlsFiles(nFile).name, 'Voronoi')
        wImg = 512;
        R = wImg/(2*pi);
        sr = 1:0.25:10;
        
        %extract <lateral area(s)>
       
   else
       R = 1;
       sr = [1,1.4167,1.8334,2.25,2.6668,3.0835,3.5];  
   end
   
   for nSr = 1:length(sr)
        R_sb = R*sr(nSr);
        %getting LateralArea from trapecio's integrative rule
        cellLateralArea(:,nSr)=(R_sb - R*sr(nSr-1)).*(cellPerim(:,nSr-1)+cellPerim(:,nSr))/2+cellLateralArea(:,nSr-1);           
   end
   
   
    
   %classify per realizations
   idsPerRealization = cell(1,nRealizations);
   nRea =1;
   idsPerRealization{nRea}=1;
   for nIds = 2:length(cellIds)
       if cellIds(nIds)>cellIds(nIds-1) %%|| abs(cellIds(nIds)-cellIds(nIds-1))<35
        idsPerRealization{nRea} = [idsPerRealization{nRea},nIds];
       else
        nRea = nRea+1;
        idsPerRealization{nRea} = [idsPerRealization{nRea},nIds];
       end
   end
   tableMeans = table();
   tableMeansNorm = table();
   for nRealization = 1:nRealizations
       cellLatAreRea = cellLateralArea(idsPerRealization{nRealization},:);
       %normalize between the medium total cell LateralArea
       meanCellLateralAreaRea = mean(cellLatAreRea);
       stdCellLateralAreaRea = std(cellLatAreRea);
       meanCellLateralAreaReaNorm = meanCellLateralAreaRea./(meanCellLateralAreaRea(end));
       stdCellLateralAreaReaNorm = stdCellLateralAreaRea./(meanCellLateralAreaRea(end));
       tableMeans = [tableMeans; array2table([meanCellLateralAreaRea;stdCellLateralAreaRea])];
       tableMeansNorm = [tableMeansNorm; array2table([meanCellLateralAreaReaNorm;stdCellLateralAreaReaNorm])];
   end
   
   mkdir(fullfile(xlsFiles(nFile).folder,'MeanLateralArea'));
   path2save = fullfile(xlsFiles(nFile).folder,'MeanLateralArea');
   writetable(tableMeans,[path2save '\MeanPerim_' xlsFiles(nFile).name(end-21:end)])
   writetable(tableMeansNorm,[path2save '\MeanPerimNormalized_' xlsFiles(nFile).name(end-21:end)])
end