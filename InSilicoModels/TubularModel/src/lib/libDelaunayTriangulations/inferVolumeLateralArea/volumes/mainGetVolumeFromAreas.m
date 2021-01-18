xlsFiles=dir('folderAreas\*xls');


for nFile = 1:size(xlsFiles,1)
    
   tableData = readtable(fullfile(xlsFiles(nFile).folder,xlsFiles(nFile).name));
   tableNums = cellfun(@(x) str2double(x),table2array(tableData(2:end,:)));
   cellIds = tableNums(:,1);
   cellAreas = tableNums(:,3:2:end);
   nRealizations = 20;
   cellVolumes = zeros(size(cellAreas));

   if contains(xlsFiles(nFile).name, 'Voronoi')
        wImg = 512;
        R = 512/(2*pi);
        sr = 1:0.25:10;
        
        %extract <V(s)> and <V(s)^2> - <V(s)>^2
       
   else
       R = 1;
       sr = [1,1.4167,1.8334,2.25,2.6668,3.0835,3.5];  
       cellAreas(:,2) = cellAreas(:,2)*sr(2);
       cellAreas(:,3) = cellAreas(:,2)*sr(3);
       cellAreas(:,4) = cellAreas(:,2)*sr(4);
       cellAreas(:,5) = cellAreas(:,2)*sr(5);
       cellAreas(:,6) = cellAreas(:,2)*sr(6);
       cellAreas(:,7) = cellAreas(:,2)*sr(7);
   end
   
   for nSr = 2:length(sr)
        R_sb = R*sr(nSr);
        %getting volume from trapecio's integrative rule
        cellVolumes(:,nSr)=(R_sb - R*sr(nSr-1)).*(cellAreas(:,nSr-1)+cellAreas(:,nSr))/2+cellVolumes(:,nSr-1);           
   end
   
   
    
   %classify per realizations
   idsPerRealization = cell(1,nRealizations);
   nRea =1;
   idsPerRealization{nRea}=1;
   for nIds = 2:length(cellIds)
       if cellIds(nIds)>cellIds(nIds-1) || abs(cellIds(nIds)-cellIds(nIds-1))<35
       idsPerRealization{nRea} = [idsPerRealization{nRea},nIds];
       else
        nRea = nRea+1;
        idsPerRealization{nRea} = [idsPerRealization{nRea},nIds];
       end
   end
   cellVolumesPerReal = cell(1,nRealizations);
   tableMeans = table();
   tableMeansNorm = table();
   for nRealization = 1:nRealizations
       cellVolRea = cellVolumes(idsPerRealization{nRealization},:);
       %normalize between the medium total cell volume
       meanCellVolumeRea = mean(cellVolRea);
       stdCellVolumeRea = std(cellVolRea);
       meanCellVolumeReaNorm = meanCellVolumeRea./(meanCellVolumeRea(end));
       stdCellVolumeReaNorm = stdCellVolumeRea./(meanCellVolumeRea(end));
       tableMeans = [tableMeans; array2table([meanCellVolumeRea;stdCellVolumeRea])];
       tableMeansNorm = [tableMeansNorm; array2table([meanCellVolumeReaNorm;stdCellVolumeReaNorm])];
   end
   
   path2save = xlsFiles(nFile).folder;
   writetable(tableMeans,[path2save '\volumes_' xlsFiles(nFile).name(end-12:end)])
   writetable(tableMeansNorm,[path2save '\volumesNormalized_' xlsFiles(nFile).name(end-12:end)])
end