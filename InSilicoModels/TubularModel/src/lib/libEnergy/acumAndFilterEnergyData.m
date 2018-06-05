function [tableTransitionEnergy,tableTransitionEnergyFiltering100data,tableNoTransitionEnergy,tableNoTransitionEnergyFiltering100data ] = acumAndFilterEnergyData( dataEnergy, labelEdges,tableTransitionEnergy,tableTransitionEnergyFiltering100data,tableNoTransitionEnergy,tableNoTransitionEnergyFiltering100data,nRand,nSeeds,surfaceRatio)
%ACUMANDFILTERENERGYDATA get 100 samples from the total data as maximum    
    if ~isempty(dataEnergy.basalH1)
        dataEnergy.nRand=nRand*ones(size(dataEnergy.basalH1,1),1);
        dataEnergy.numSeeds=nSeeds*ones(size(dataEnergy.basalH1,1),1);
        dataEnergy.surfaceRatio=surfaceRatio*ones(size(dataEnergy.basalH1,1),1);

        %filtering 5 data for each realization  
        sumTableEnergy=struct2table(dataEnergy);
        nanIndex=(isnan(sumTableEnergy.apicalH1) |  isnan(sumTableEnergy.basalH1));
        sumTableEnergy=sumTableEnergy(~nanIndex,:);
        pos = randperm(size(sumTableEnergy,1));
        if length(pos)>=5
            pos = pos(1:5);
        end

        %storing all data and filtered 5 data per realization (IF there are more than 5)
        if strcmp(labelEdges,'transition')
            tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
            tableTransitionEnergyFiltering100data=[tableTransitionEnergyFiltering100data;sumTableEnergy(pos,:)];
        else
            tableNoTransitionEnergy=[tableNoTransitionEnergy;sumTableEnergy];
            tableNoTransitionEnergyFiltering100data=[tableNoTransitionEnergyFiltering100data;sumTableEnergy(pos,:)];
        end

    end

end

