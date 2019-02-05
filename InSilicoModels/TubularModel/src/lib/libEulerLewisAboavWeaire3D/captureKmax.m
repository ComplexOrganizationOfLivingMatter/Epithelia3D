function [nQuartetsAccum,nQuintetsAccum,nSixtetsAccum,nSeventetsAccum,nEightetsAccum] = captureKmax(neighsAccum)

    nQuartetsAccum = 0;
    nQuintetsAccum = 0;
    nSixtetsAccum = 0;
    nSeventetsAccum = 0;
    nEightetsAccum = 0;
    for nRealization = 1 : length(neighsAccum)

        neighsAccumRea = neighsAccum{nRealization};
        
        tripletsOfNeighs = buildTripletsOfNeighs(neighsAccumRea);
        uniqTriplets = unique(sort(tripletsOfNeighs,2),'rows');

        %get k4
        quartetsOfNeighs = [];
        for nTriplets = 1 : size(uniqTriplets,1)
            neighsCellTriplet = arrayfun(@(x)  neighsAccumRea{x},uniqTriplets(nTriplets,:),'UniformOutput',false);
            intersectionTriplet= intersect(neighsCellTriplet{1},intersect(neighsCellTriplet{2},neighsCellTriplet{3}));
            if ~isempty(intersectionTriplet)
                for nQuartets = 1:length(intersectionTriplet)
                    quartetsOfNeighs(end+1,:) = [uniqTriplets(nTriplets,:),intersectionTriplet(nQuartets)];
                end
            end
        end
        uniqQuartets = unique(sort(quartetsOfNeighs,2),'rows');
        if ~isempty(uniqQuartets)
            nQuartetsAccum = nQuartetsAccum + size(uniqQuartets,1);
        end
        [row,~] = find(uniqQuartets > length(neighsAccumRea));
        uniqQuartetsValid = uniqQuartets;
        uniqQuartetsValid(row,:)=[];
        
        %get k5
        quintetsOfNeighs = [];
        for nQuartets = 1 : size(uniqQuartetsValid,1)
            neighsCellQuartet = arrayfun(@(x)  neighsAccumRea{x},uniqQuartetsValid(nQuartets,:),'UniformOutput',false);
            intersectionQuartet= intersect(neighsCellQuartet{1},intersect(neighsCellQuartet{2},intersect(neighsCellQuartet{3},neighsCellQuartet{4})));
            if ~isempty(intersectionQuartet)
                for nQuintets = 1:length(intersectionQuartet)
                    quintetsOfNeighs(end+1,:) = [uniqQuartetsValid(nQuartets,:),intersectionQuartet(nQuintets)];
                end
            end
        end
        uniqQuintets = unique(sort(quintetsOfNeighs,2),'rows');
        if ~isempty(uniqQuintets)
            nQuintetsAccum = nQuintetsAccum + size(uniqQuintets,1);
        end
        [row,~] = find(uniqQuintets > length(neighsAccumRea));
        uniqQuintetsValid = uniqQuintets;
        uniqQuintetsValid(row,:)=[];
        
        %get k6
        sixtetsOfNeighs = [];
        for nQuintets = 1 : size(uniqQuintetsValid,1)
            neighsCellQuintet = arrayfun(@(x)  neighsAccumRea{x},uniqQuintetsValid(nQuintets,:),'UniformOutput',false);
            intersectionQuintet= intersect(neighsCellQuintet{1},intersect(neighsCellQuintet{2},intersect(neighsCellQuintet{3},intersect(neighsCellQuintet{4},neighsCellQuintet{5}))));
            if ~isempty(intersectionQuintet)
                for nSixtets = 1:length(intersectionQuintet)
                    sixtetsOfNeighs(end+1,:) = [uniqQuintetsValid(nQuintets,:),intersectionQuintet(nSixtets)];
                end
            end
        end
        uniqSixtets = unique(sort(sixtetsOfNeighs,2),'rows');
        if ~isempty(uniqSixtets)
            nSixtetsAccum = nSixtetsAccum + size(uniqSixtets,1);
        end
        [row,~] = find(uniqSixtets > length(neighsAccumRea));
        uniqSixtetsValid = uniqSixtets;
        uniqSixtetsValid(row,:)=[];

        %get k7
        seventetsOfNeighs = [];
        for nSixtets = 1 : size(uniqSixtetsValid,1)
            neighsCellSixtets = arrayfun(@(x)  neighsAccumRea{x},uniqSixtetsValid(nSixtets,:),'UniformOutput',false);
            intersectionSixtet= intersect(neighsCellSixtets{1},intersect(neighsCellSixtets{2},intersect(neighsCellSixtets{3},intersect(neighsCellSixtets{4},intersect(neighsCellSixtets{5},neighsCellSixtets{6})))));
            if ~isempty(intersectionSixtet)
                for nSeventets = 1:length(intersectionSixtet)
                    seventetsOfNeighs(end+1,:) = [uniqSixtetsValid(nSixtets,:),intersectionSixtet(nSeventets)];
                end
            end
        end
        uniqSeventets = unique(sort(seventetsOfNeighs,2),'rows');
        if ~isempty(uniqSeventets)
            nSeventetsAccum = nSeventetsAccum + size(uniqSeventets,1);
        end
        [row,~] = find(uniqSeventets > length(neighsAccumRea));
        uniqSeventetsValid = uniqSeventets;
        uniqSeventetsValid(row,:)=[];

        %get k8
        eightetsOfNeighs = [];

        for nSeventets = 1 : size(uniqSeventetsValid,1)
            neighsCellSeventets = arrayfun(@(x)  neighsAccumRea{x},uniqSeventetsValid(nSeventets,:),'UniformOutput',false);
            intersectionSeventet = cell2mat(cellfun(@(x,y,z,zz,z3,z4,z5) intersect(x,intersect(y,intersect(z,intersect(zz,intersect(z3,intersect(z4,z5)))))),neighsCellSeventets(1),neighsCellSeventets(2),neighsCellSeventets(3),neighsCellSeventets(4),neighsCellSeventets(5),neighsCellSeventets(6),neighsCellSeventets(7),'UniformOutput',false));
            if ~isempty(intersectionSeventet)
                for nEightets = 1:length(intersectionSeventet)
                    eightetsOfNeighs(end+1,:) = [uniqSeventetsValid(nSeventets,:),intersectionSeventet(nEightets)];
                end
            end
        end
        uniqEightets = unique(sort(eightetsOfNeighs,2),'rows');
        if ~isempty(uniqEightets)
            nEightetsAccum = nEightetsAccum + size(uniqEightets,1);
        end

    end
end