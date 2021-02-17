clear all
%calculate volume, area apical, basal, lateral, perimeter apical, basal,
%intercalations

voronoiOfInterest = 1:10;
SRs=1.25:0.25:10;
allSRs = 1:0.25:10;
nRealizations = 20;

wImg = 512;
R = wImg/(2*pi);

pathData = '..\delaunayData\geometryMeasurementsVoronoiTubes';
path
filesAreas = dir(fullfile(pathData,'areas','*Voronoi*xls'));
filesPerims = dir(fullfile(pathData,'perimeters','tablePerim_Voronoi_*xls'));

path2save = fullfile(pathData,'volumeAreaPerimIntercalations_VoronoiTubes_apicalToBasal');
if ~exist(path2save,'dir')
    mkdir(path2save)
end

idsSRs = ismember(allSRs,SRs);


% averageVolumeV1_s10 = 41501171.2595563;
% averagePerimApicalV1 = 408.8351431;
% averagePerimV1_s10 = 1282.297676;
% averageAreaApicalV1 = 10418.191542;
% averageAreaV1_s10 = 102669.356842;
% averageAreaLateralV1_s10 = 674797.6656;

for nVor = voronoiOfInterest

        %match nVor and nFile
        fileNames = struct2cell(filesAreas);
        idFile = cellfun(@(x) contains(x,['Voronoi_' num2str(nVor) '.xls']),fileNames(1,:));
        
        %% get volumes, area apical and area basal
        tableData = readtable(fullfile(filesAreas(idFile).folder,filesAreas(idFile).name));
        tableNums = table2array(tableData);
        cellIds = tableNums(:,1);
        cellAreas = tableNums(:,3:2:end);
        cellVolumes = zeros(size(cellAreas));
        for nSr = 2:length(allSRs)
            R_sb = R*allSRs(nSr);
            %getting volume from trapecio's integrative rule
            cellVolumes(:,nSr)=(R_sb - R*allSRs(nSr-1)).*(cellAreas(:,nSr-1)+cellAreas(:,nSr))/2+cellVolumes(:,nSr-1);           
        end
      
        %match nVor and nFile
        fileNames = struct2cell(filesPerims);
        idFile = cellfun(@(x) contains(x,['Voronoi_' num2str(nVor) '.xls']),fileNames(1,:));
        
        %get area lateral, perimeter apical and perimeter basal
        tableData = table2array(readtable(fullfile(filesPerims(idFile).folder,filesPerims(idFile).name)));
        cellPerim = tableData(:,2:end);
        cellLateralArea = zeros(size(cellPerim));
        
        for nSr = 2:length(allSRs)
            R_sb = R*allSRs(nSr);
            %getting LateralArea from trapecio's integrative rule
            cellLateralArea(:,nSr)=(R_sb - R*allSRs(nSr-1)).*(cellPerim(:,nSr-1)+cellPerim(:,nSr))/2+cellLateralArea(:,nSr-1);           
        end

        %get cell intercalations
        load(fullfile(pathData,['Voronoi ' num2str(nVor)],['delaunayCyl_Voronoi' num2str(nVor) '_200seeds_sr10_18-Dec-2019.mat']),'numTransitionsApicalToBasal')
        
        
        selectedCellVolumes = cellVolumes(:,idsSRs);
        selectedBasalAreas = cellAreas(:,idsSRs);
        selectedLateralAreas = cellLateralArea(:,idsSRs);
        selectedBasalPerims = cellPerim(:,idsSRs);  
        selectedIntercalations = numTransitionsApicalToBasal(:,idsSRs);
        
        cellsAreaApical = cellAreas(:,1);
        cellsPerimApical = cellPerim(:,1);
        for nSr = 1:length(SRs)
           cellsVolumeSR = selectedCellVolumes(:,nSr);
           cellsAreaBasalSR = selectedBasalAreas(:,nSr);
           cellsPerimBasalSR = selectedBasalPerims(:,nSr);
           cellsLateralAreaSR = selectedLateralAreas(:,nSr);
           intercalationsSR=horzcat(selectedIntercalations{:,nSr})';
           table2save = array2table([cellIds, cellsVolumeSR, cellsAreaApical, cellsAreaBasalSR,cellsLateralAreaSR,cellsPerimApical,cellsPerimBasalSR,intercalationsSR],'VariableNames',{'id','volume','apicalArea','basalArea','lateralArea','apicalPerim','basalPerim','nIntercalations'});
           
           writetable(table2save,fullfile(path2save,['V' num2str(nVor) '_s' num2str(SRs(nSr)) '_volumeAreaPerimIntercalation_' date '.xls']))
        end
        

end