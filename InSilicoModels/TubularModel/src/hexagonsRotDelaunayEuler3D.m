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



save(['..\..\3D_laws\hexagonsDelaunayEuler3D_' num2str(nCellsLongAxis) 'x' num2str(nCellsTrasAxis) 'seeds_sr' num2str(max(surfaceRatios)) '_' date '.mat'],'tableNeighsAccum','-v7.3')


