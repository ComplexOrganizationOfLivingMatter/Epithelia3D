    %delaunay - Euler 3D - Hexagons

    apothemHex = 10;
    %cell matrix nCellLongAxis x nCellsTrasAxis
    nCellsLongAxis = 500;
    nCellsTrasAxis = 500;

    srInit = 10 * 1./(1:10);
    surfaceRatios = unique([srInit,3:2000]);

    totalAngles = 0:30;
    neighsAccum = cell(length(totalAngles),length(surfaceRatios));

    for angRot = 1:length(totalAngles)

        [rotSeeds,idCentralCell] = generateSeedsOfRegularVoronoiHexagonalLattice(apothemHex,nCellsLongAxis,nCellsTrasAxis,totalAngles(angRot));

        for SR = 1:length(surfaceRatios)
            %generate the complete delaunay triangulation for each surface ratio
            TRI = delaunay(rotSeeds(:,1).*surfaceRatios(SR),rotSeeds(:,2));

            TRIsort = sort(TRI,2);
            TRIunique = unique(TRIsort,'rows');
            [xRow,~] = find(TRIunique==idCentralCell);
            neighsIdCell = unique(TRIunique(xRow,:));
            neighsIdCell = neighsIdCell(neighsIdCell~=idCentralCell);

            if SR==1
                neighsAccum{angRot,SR} = neighsIdCell;
            else
                neighsAccum{angRot,SR} = unique([neighsIdCell;neighsAccum{angRot,SR-1}]);
            end
        end

    end

    nNeighPerSR = cellfun(@(x) length(x),neighsAccum);
    srName = arrayfun(@(x) ['sr' strrep(num2str(x),'.','_')],surfaceRatios,'UniformOutput',false);
    angleName = arrayfun(@(x) ['angle' num2str(x)],totalAngles,'UniformOutput',false);

    tableNeighsAccum = array2table(nNeighPerSR,'VariableNames',srName,'RowNames',angleName);



    save(['..\..\3D_laws\hexagonsDelaunayEuler3D_' num2str(nCellsLongAxis) 'x' num2str(nCellsTrasAxis) 'seeds_sr' num2str(max(surfaceRatios)) '_' date '.mat'],'tableNeighsAccum','neighsAccum','-v7.3')


%%Represent 

h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   

previousLegend =  get(findobj(gcf,'type','Legend'),'String');

colors = colorcube(11);
hold on
for nAng = 1:10%length(totalAngles)
    nNaccum = table2array(tableNeighsAccum(nAng,:));
    plot(surfaceRatios,nNaccum,'Color',colors(nAng,:),'LineWidth',2)
end
title('euler neighbours 3D')
xlabel('surface ratio')
ylabel('neighbours total')

hold off
ylim([0,140]);
yticks([0:5:140])
set(gca,'FontSize', 16,'FontName','Helvetica');
legend([previousLegend,angleName(1:10)])

h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
hold on
for nAng = 11:20%length(totalAngles)
    nNaccum = table2array(tableNeighsAccum(nAng,:));
    plot(surfaceRatios,nNaccum,'Color',colors(nAng-10,:),'LineWidth',2)
end
title('euler neighbours 3D')
xlabel('surface ratio')
ylabel('neighbours total')

hold off
ylim([0,140]);
yticks([0:5:140])
set(gca,'FontSize', 16,'FontName','Helvetica');
legend([previousLegend,angleName(11:20)])

h = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');   
hold on
for nAng = 21:length(totalAngles)
    nNaccum = table2array(tableNeighsAccum(nAng,:));
    plot(surfaceRatios,nNaccum,'Color',colors(nAng-20,:),'LineWidth',2)
end
title('euler neighbours 3D')
xlabel('surface ratio')
ylabel('neighbours total')

hold off
ylim([0,140]);
yticks([0:5:140])
set(gca,'FontSize', 16,'FontName','Helvetica');
legend([previousLegend,angleName(21:length(totalAngles))])