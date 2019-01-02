
clear all
close all
files = dir('**/Salivary gland/**/Results/3d_layers_info.mat');

numberOfSurfaceRatios = 11;
%namesSR = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],1:numberOfSurfaceRatios,'UniformOutput', false);
for numFile = 1:length(files)
    
    load(fullfile(files(numFile).folder, files(numFile).name));
    load(fullfile(files(numFile).folder, 'valid_cells.mat'));
    if exist(fullfile(files(numFile).folder, 'glandDividedInSurfaceRatios.mat'), 'file')
        load(fullfile(files(numFile).folder, 'glandDividedInSurfaceRatios.mat'))
    else
        [infoPerSurfaceRatio, neighbours] = divideObjectInSurfaceRatios(labelledImage, basalLayer, apicalLayer, validCells, noValidCells, colours, files(numFile).folder);
    end

    if ~exist('meanNeighsScutoidsPerSF_ValidCells', 'var')
        GeometricalMeasurementsPerSurfaceRatio={infoPerSurfaceRatio{:,4}};
        NeighsScutoidsPerSF=zeros(numberOfSurfaceRatios,5);
        for GlandsSF=1:numberOfSurfaceRatios
            ActualGland=GeometricalMeasurementsPerSurfaceRatio{1,GlandsSF};
            ActualGland(noValidCells,:)=[];
            NeighsScutoidsPerSF(GlandsSF,:)=[mean(cell2mat(ActualGland.Total_neighbours)),std(cell2mat(ActualGland.Total_neighbours)),mean(ActualGland.Scutoids),std(ActualGland.Scutoids),mean(ActualGland.Surface_Ratio)];
        end
        meanNeighsScutoidsPerSF_ValidCells=array2table(NeighsScutoidsPerSF,'VariableNames',{'mean_neigh3D','std_neigh3D','mean_PercScutoids','std_PercScutoids','Surface_Ratio'});
        save(fullfile(files(numFile).folder, 'glandDividedInSurfaceRatios.mat'), 'infoPerSurfaceRatio', 'neighbours','meanNeighsScutoidsPerSF_ValidCells');
    end
    neighsSurface = cell(numberOfSurfaceRatios,1);
    neighsAccumSurfaces = cell(numberOfSurfaceRatios,1);
    areaCells = cell(numberOfSurfaceRatios,1);
    volumes = cell(numberOfSurfaceRatios,1);

    neighsSurface{1} = neighbours{1}';
    neighsAccumSurfaces{1} = neighbours{1}';

    infoOfCells = infoPerSurfaceRatio{1, 4};

    areaCells(1) = {infoOfCells.Basal_area};
    volumes(1) = {infoOfCells.Volume};

    for idSR = 2:numberOfSurfaceRatios
        neighsSurface{idSR} = neighbours{idSR}';
        neighsAccumSurfaces{idSR} = cellfun(@(x,y) unique([x;y]),neighsAccumSurfaces{idSR-1},neighsSurface{idSR},'UniformOutput',false);

        infoOfCells = infoPerSurfaceRatio{idSR, 4};
        areaCells(idSR) = {infoOfCells.Basal_area};
        volumes(idSR) = {infoOfCells.Volume};
    end

    areaCellsPerSurfaceRealization = cat(2,areaCells{:});
    volumePerSurfaceRealization = cat(2,volumes{:});
    neighsSurface = cat(1,neighsSurface{:})';
    neighsAccumSurfaces = cat(1,neighsAccumSurfaces{:})';

    numNeighPerSurfaceRealization = cellfun(@(x) length(x),neighsSurface);
    numNeighAccumPerSurfacesRealization = cellfun(@(x) length(x),neighsAccumSurfaces);

    numNeighOfNeighPerSurfacesRealization = zeros(size(neighsSurface));
    numNeighOfNeighAccumPerSurfacesRealization = zeros(size(neighsSurface));
    for nSR = 1:numberOfSurfaceRatios
        numNeighOfNeighPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighPerSurfaceRealization(x,nSR)))/length(x),neighsSurface(:,nSR));
        numNeighOfNeighAccumPerSurfacesRealization(:,nSR) = cellfun(@(x) sum(vertcat(numNeighAccumPerSurfacesRealization(x,nSR)))/length(x),neighsAccumSurfaces(:,nSR));
    end

    %%
    meanNumNeighPerSurfaceRealization = mean(numNeighAccumPerSurfacesRealization(validCells, :), 1);
    numCells = repmat(length(validCells), 1, size(meanNumNeighPerSurfaceRealization, 2));
    stdNumNeighPerSurfaceRealization = std(numNeighAccumPerSurfacesRealization(validCells, :), 1);
    totalAreaPerSR = sum(areaCellsPerSurfaceRealization(validCells, :));

    surfaceRatioOfGland = vertcat(infoPerSurfaceRatio{:, 2})';

    infoEuler3D{numFile, 1} = vertcat(meanNumNeighPerSurfaceRealization, stdNumNeighPerSurfaceRealization, surfaceRatioOfGland, numCells)';
    infoEuler3D{numFile, 2} = meanNeighsScutoidsPerSF_ValidCells;
%     numNeighPerSurface{numFile, 1} = array2table(numNeighPerSurfaceRealization(validCells, :),'VariableNames',namesSR);
%     numNeighAccumPerSurfaces{numFile, 1} = array2table(numNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
%     numNeighOfNeighPerSurface{numFile, 1} = array2table(numNeighOfNeighPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
%     numNeighOfNeighAccumPerSurface{numFile, 1} = array2table(numNeighOfNeighAccumPerSurfacesRealization(validCells, :),'VariableNames',namesSR);
%     areaCellsPerSurface{numFile, 1} = array2table(areaCellsPerSurfaceRealization(validCells,:),'VariableNames',namesSR);
%     volumePerSurface{numFile, 1} = array2table(volumePerSurfaceRealization(validCells,:),'VariableNames',namesSR);


    %Scutoids per number of sides
    numberOfSides = 3:10;
    [~, sidesCorrespondance] = ismember(numNeighAccumPerSurfacesRealization(:, 1), numberOfSides);
    winningNeighbours = numNeighAccumPerSurfacesRealization - numNeighAccumPerSurfacesRealization(:, 1);
   
    for numNumberOfSide = 1:length(numberOfSides)
        meanWinningPerSide(numNumberOfSide, :) = mean(winningNeighbours(sidesCorrespondance == numNumberOfSide, :), 1);
    end
    meanWinningPerSidePerFile{numFile, 1} = meanWinningPerSide;
end

dim = ndims(meanWinningPerSidePerFile{1});          %# Get the number of dimensions for your arrays
M = cat(dim+1,meanWinningPerSidePerFile{:});        %# Convert to a (dim+1)-dimensional matrix
meanWinningPerSide_Total = mean(M,dim+1, 'omitnan');  %# Get the mean across arrays

infoEuler3DCat = cat(1, infoEuler3D{:,1});

%figure;
myfittypeLog10=fittype('a +b*log10(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
myfittypePoly=fittype('a +b*x',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
goodnesslog = cell(size(infoEuler3D, 1), 1);
outputlog = cell(size(infoEuler3D, 1), 1);
rSquareslog = zeros(size(infoEuler3D, 1),1);
coefAlog = zeros(size(infoEuler3D, 1),1);
coefBlog = zeros(size(infoEuler3D, 1),1);
goodnessPol = cell(size(infoEuler3D, 1), 1);
outputPol = cell(size(infoEuler3D, 1), 1);
rSquaresPol = zeros(size(infoEuler3D, 1),1);
coefAPol = zeros(size(infoEuler3D, 1),1);
coefBPol = zeros(size(infoEuler3D, 1),1);

for numPoint = 1:size(infoEuler3D, 1)
    infoEulerActual = infoEuler3D{numPoint,2};
    figure;
    errorbar(infoEulerActual.Surface_Ratio,infoEulerActual.mean_neigh3D,infoEulerActual.std_neigh3D,'-o','MarkerSize',5,...
        'MarkerEdgeColor','black','MarkerFaceColor','blue');
    
    [myfitLog10, goodnesslog{numPoint}, outputlog{numPoint}] = fit(infoEulerActual.Surface_Ratio,infoEulerActual.mean_neigh3D,myfittypeLog10,'StartPoint',[6,1]);
    
    rSquareslog(numPoint) = goodnesslog{numPoint}.rsquare;
    coefAlog(numPoint) = myfitLog10.a;
    coefBlog(numPoint) = myfitLog10.b;
    
    hold on; plot(myfitLog10);
    title('euler neighbours 3D')
    xlabel('surface ratio')
    ylabel('neighbours total')
    xlim([1, 8]);
    ylim([0,15]);
    hold off;
    [myfitPol, goodnessPol{numPoint}, outputPol{numPoint}] = fit(infoEulerActual.Surface_Ratio,infoEulerActual.mean_neigh3D,myfittypePoly,'StartPoint',[6,1]);
    
    rSquaresPol(numPoint) = goodnessPol{numPoint}.rsquare;
    coefAPol(numPoint) = myfitPol.a;
    coefBPol(numPoint) = myfitPol.b;
    
    figure(100)
    hold on
    plot(infoEulerActual.mean_PercScutoids,infoEulerActual.mean_neigh3D,'o','MarkerSize',5,...
        'MarkerEdgeColor','black','MarkerFaceColor','blue');
    hold off
end

meanRsquareLog = mean(rSquareslog);
stdRsquareLog = std(rSquareslog);
meanCoefALog = mean(coefAlog);
stdCoefALog = std(coefAlog);
meanCoefBLog = mean(coefBlog);
stdCoefBLog = std(coefBlog);

meanRsquarePol = mean(rSquaresPol);
stdRsquarePol = std(rSquaresPol);
meanCoefAPol = mean(coefAPol);
stdCoefAPol = std(coefAPol);
meanCoefBPol = mean(coefBPol);
stdCoefBPol = std(coefBPol);

figure;


for numPoint = 1:size(infoEuler3DCat, 1)
    hold on;
    plot(infoEuler3DCat(numPoint, 3), infoEuler3DCat(numPoint, 1), '*k')
end
title('euler neighbours 3D')
xlabel('surface ratio')
ylabel('neighbours total')
xlim([1, 15]);
ylim([0,15]);

myfittypeLog10=fittype('6 +b*log10(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'b'});

myfitLog10=fit(infoEuler3DCat(:, 3),infoEuler3DCat(:, 1),myfittypeLog10,'StartPoint',1);
hold on; plot(myfitLog10);
%getStatsAndRepresentationsEulerLewis3D(numNeighOfNeighPerSurface,numNeighOfNeighAccumPerSurface,numNeighPerSurface,numNeighAccumPerSurfaces,areaCellsPerSurface,volumePerSurface,'Results/SalivaryGlands/',[1 2]);