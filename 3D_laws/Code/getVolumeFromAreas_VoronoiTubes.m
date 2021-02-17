clear all
xlsFiles=dir('..\Results\geometryMeasurementsVoronoiTubes\areas\*xls');
path2save = '..\Results\geometryMeasurementsVoronoiTubes\volumes\';
mkdir(path2save);
       


srApiToBasal = 1:0.25:10;
srBasToApical = 10:-0.25:1;
SRs = {srApiToBasal,srBasToApical};
nameSurfaces = {'apicalToBasal', 'basalToApical'};
wImg = 512;

for kindSr = 1:2
    sr = SRs{kindSr};  
    for nFile = 1:size(xlsFiles,1)

       tableData = readtable(fullfile(xlsFiles(nFile).folder,xlsFiles(nFile).name));
       tableNums = table2array(tableData);
       cellIds = tableNums(:,1);
       cellAreas = tableNums(:,3:2:end);
       if kindSr ==2
           cellAreas = cellAreas(:,end:-1:1);
       end
       nRealizations = 20;
       cellVolumes = zeros(size(cellAreas));

       %extract <V(s)> and <V(s)^2> - <V(s)>^2
       R = wImg/(2*pi);

       for nSr = 2:length(sr)
            R_sb = R*sr(nSr);
            %getting volume from trapecio's integrative rule
            cellVolumes(:,nSr)=abs(R_sb - R*sr(nSr-1)).*(cellAreas(:,nSr-1)+cellAreas(:,nSr))/2+cellVolumes(:,nSr-1);           
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
       tableMeansVol = table();
       tableMeansVolNorm = table();
       for nRealization = 1:nRealizations
           cellVolRea = cellVolumes(idsPerRealization{nRealization},:);
           cellAreaRea = cellAreas(idsPerRealization{nRealization},:);
           %normalize between the medium total cell volume
           meanCellVolumeRea = mean(cellVolRea);
           meanCellAreaRea = mean(cellAreaRea);
           stdCellVolumeRea = std(cellVolRea);
           meanCellVolumeReaNorm = meanCellVolumeRea./(meanCellVolumeRea(end));
           stdCellVolumeReaNorm = stdCellVolumeRea./(meanCellVolumeRea(end));
           tableMeansVol = [tableMeansVol; array2table([meanCellVolumeRea;stdCellVolumeRea])];
           tableMeansVolNorm = [tableMeansVolNorm; array2table([meanCellVolumeReaNorm;stdCellVolumeReaNorm])];
       end

       
       writetable(tableMeansVol,[path2save '\volumes_' xlsFiles(nFile).name(end-12:end-4) '_' nameSurfaces{kindSr} '.xls'])
       writetable(tableMeansVolNorm,[path2save '\volumesNormalized_' xlsFiles(nFile).name(end-12:end-4) '_' nameSurfaces{kindSr} '.xls'])
    end
end