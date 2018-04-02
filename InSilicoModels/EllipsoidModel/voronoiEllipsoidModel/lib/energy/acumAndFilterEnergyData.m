function [ tableTransitionEnergy,tableTransitionEnergyNonPreservedMotifs,tableNoTransitionEnergyTotal,tableNoTransitionEnergyTotalNonPreservedMotifs,totalEdges ] = acumAndFilterEnergyData( tableTransitionEnergy,tableTransitionEnergyNonPreservedMotifs,tableNoTransitionEnergyTotal,tableNoTransitionEnergyTotalNonPreservedMotifs,dataEnergy,dataEnergyOuterNonPreservedMotifs,totalEdges,labelEdges,nRand)


    if ~isempty(dataEnergy)

        dataEnergy.nRand=nRand*ones(size(dataEnergy.outerH1,1),1);
        dataEnergyOuterNonPreservedMotifs.nRand=nRand*ones(size(dataEnergyOuterNonPreservedMotifs.outerH1,1),1);
        %filtering no transition data for each transition 

        %preserved motifs
        sumTableEnergy=struct2table(dataEnergy);
        nanIndex=(isnan(sumTableEnergy.innerH1) |  isnan(sumTableEnergy.outerH1));
        sumTableEnergy=sumTableEnergy(~nanIndex,:);
        %nonpreserved motifs
        sumTableEnergyNonPreservedMotifs=struct2table(dataEnergyOuterNonPreservedMotifs);
        nanIndexNonPreservedMotifs=(isnan(sumTableEnergyNonPreservedMotifs.outerH1));
        sumTableEnergyNonPreservedMotifs=sumTableEnergyNonPreservedMotifs(~nanIndexNonPreservedMotifs,:);

        if strcmp(labelEdges,'transition')
            tableTransitionEnergy=[tableTransitionEnergy;sumTableEnergy];
            tableTransitionEnergyNonPreservedMotifs=[tableTransitionEnergyNonPreservedMotifs;sumTableEnergyNonPreservedMotifs];
        else
            tableNoTransitionEnergyTotal=[tableNoTransitionEnergyTotal;sumTableEnergy];
            tableNoTransitionEnergyTotalNonPreservedMotifs=[tableNoTransitionEnergyTotalNonPreservedMotifs;sumTableEnergyNonPreservedMotifs];
        end 

    else
        if strcmp(labelEdges,'transition')
            totalEdges{1}=[];
        end
    end


end

