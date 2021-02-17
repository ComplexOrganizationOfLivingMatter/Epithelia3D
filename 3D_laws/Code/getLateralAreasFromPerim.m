clear all 
close all

folder2load = '..\delaunayData\geometryMeasurementsVoronoiTubes\perimeters\';
path2save = '..\delaunayData\geometryMeasurementsVoronoiTubes\lateralAreas\';
mkdir(path2save);

xlsFiles=dir([folder2load 'tablePerim_*.xls']);

srApiToBasal = 1:0.25:10;
srBasToApical = 10:-0.25:1;
SRs = {srApiToBasal,srBasToApical};
nameSurfaces = {'apicalToBasal', 'basalToApical'};
 wImg = 512;
for kindSr = 1:2
    sr = SRs{kindSr};  

    for nFile = 1:size(xlsFiles,1)

       tableData = table2array(readtable(fullfile(xlsFiles(nFile).folder,xlsFiles(nFile).name)));
       cellIds = tableData(:,1);
       cellPerim = tableData(:,2:end);
       
       if kindSr ==2
           cellPerim = cellPerim(:,end:-1:1);
       end
       nRealizations = 20;
       cellLateralArea = zeros(size(cellPerim));
        
       %extract <lateral area(s)>
       R = wImg/(2*pi);
       sr = 1:0.25:10;

       for nSr = 2:length(sr)
            R_sb = R*sr(nSr);
            %getting LateralArea from trapecio's integrative rule
            cellLateralArea(:,nSr)=abs(R_sb - R*sr(nSr-1)).*(cellPerim(:,nSr-1)+cellPerim(:,nSr))/2+cellLateralArea(:,nSr-1);           
       end

       %classify per realizations
       idsPerRealization = cell(1,nRealizations);
       nRea =1;
       idsPerRealization{nRea}=1;
       for nIds = 2:length(cellIds)
           if cellIds(nIds)>cellIds(nIds-1)
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

       writetable(tableMeans,[path2save '\LateralAreas_' xlsFiles(nFile).name(end-21:end-4) '_' nameSurfaces{kindSr} '.xls'])
       writetable(tableMeansNorm,[path2save '\LateralAreasNormalized_' xlsFiles(nFile).name(end-21:end-4) '_' nameSurfaces{kindSr} '.xls'])
    end
end