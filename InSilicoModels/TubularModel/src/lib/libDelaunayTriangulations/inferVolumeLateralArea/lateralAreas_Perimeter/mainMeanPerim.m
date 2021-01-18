clear all 
close all
xlsFiles=dir('perimData\tablePerim^2*.xls');


for nFile = 1:size(xlsFiles,1)
    
   tableData = table2array(readtable(fullfile(xlsFiles(nFile).folder,xlsFiles(nFile).name)));
   cellIds = tableData(:,1);
   cellPerim = tableData(:,2:end);
   nRealizations = 20;

   if contains(xlsFiles(nFile).name, 'Voronoi')
        wImg = 512;
        R = wImg/(2*pi);
        sr = 1:0.25:10;
        
        %extract <lateral area(s)>
       
   else
       R = 1;
       sr = [1,1.4167,1.8334,2.25,2.6668,3.0835,3.5];  
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
       cellPerimRea = cellPerim(idsPerRealization{nRealization},:);
       %normalize between the medium total cell LateralArea
       meanCellPerimRea = mean(cellPerimRea);
       stdCellPerimRea = std(cellPerimRea);
       meanCellPerimReaNorm = meanCellPerimRea./(meanCellPerimRea(end));
       stdCellPerimReaNorm = stdCellPerimRea./(meanCellPerimRea(end));
       tableMeans = [tableMeans; array2table([meanCellPerimRea;stdCellPerimRea])];
       tableMeansNorm = [tableMeansNorm; array2table([meanCellPerimReaNorm;stdCellPerimReaNorm])];
   end
   
   mkdir(fullfile(xlsFiles(nFile).folder,'MeanPerim^2'));
   path2save = fullfile(xlsFiles(nFile).folder,'MeanPerim^2');
   writetable(tableMeans,[path2save '\MeanPerim^2_' xlsFiles(nFile).name(end-21:end)])
   writetable(tableMeansNorm,[path2save '\MeanPerim^2Normalized_' xlsFiles(nFile).name(end-21:end)])
end