function calculateNumberOfInvolvedCellsInTransitions(numSeeds,kindProjection,pathV5data,directory2save1,numOfSurfaceRatios,Hinitial,Winitial)

    numberOfRows=11;
    directory2save=[directory2save1 kindProjection '\' num2str(Winitial) 'x' num2str(Hinitial) '_' num2str(numSeeds) 'seeds\'];

    %defining variables to storage the total data involved in transitions
    listTransitionPerCell=zeros(numberOfRows,numOfSurfaceRatios,size(pathV5data,1));
    listWinningNeigh=zeros(numberOfRows,numOfSurfaceRatios,size(pathV5data,1));
    listLossingNeigh=zeros(numberOfRows,numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsWinning=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsLossing=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsLossingOrWinning=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsInNoTransitions=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listFrequencyOfChangesPerCell=zeros(numOfSurfaceRatios,size(pathV5data,1));

    for i=1:size(pathV5data,1)

        %load cylindrical Voronoi 5 data
        nameFile=pathV5data(i).name;
        load([directory2save nameFile(1:end-4) '\' nameFile],'listLOriginalProjection')

        numberOfCellsWinning=zeros(1,size(listLOriginalProjection,1));
        numberOfCellsLossing=zeros(1,size(listLOriginalProjection,1));
        numberOfCellsLossingOrWinning=zeros(1,size(listLOriginalProjection,1));
        numberOfCellsInNoTransitions=zeros(1,size(listLOriginalProjection,1));
        frequencyOfChangesPerCell=zeros(1,size(listLOriginalProjection,1));
        winningNeigh=zeros(size(listLOriginalProjection,1),numberOfRows);
        lossingNeigh=zeros(size(listLOriginalProjection,1),numberOfRows);
        transitionPerCell=zeros(size(listLOriginalProjection,1),numberOfRows);

        for j=1:size(listLOriginalProjection,1)
            
            if strcmp(kindProjection,'expansion')
                L_apical=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==1,1};
                L_basal=listLOriginalProjection.L_originalProjection{j,1};
            else
                L_basal=listLOriginalProjection.L_originalProjection{listLOriginalProjection.surfaceRatio==1,1};
                L_apical=listLOriginalProjection.L_originalProjection{j,1};
            end
            %calculate no valid cells
            noValidCells=unique([L_basal([1 end],:),L_apical([1 end],:)]);
            noValidCells=noValidCells(noValidCells~=0);
            validCells=(setdiff(1:max(max(L_apical)),noValidCells));
            
            %calculate neighbourings in apical and basal layers
            [neighs_basal,~]=calculateNeighbours(L_basal);
            [neighs_apical,~]=calculateNeighbours(L_apical);

            %get happening per cell
            Lossing=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
            Winning=cellfun(@(x,y) setdiff(x,y),neighs_apical,neighs_basal,'UniformOutput',false);
            LossingValidCells=Lossing(validCells);
            WinningValidCells=Winning(validCells);
            
            winningPerCell=cell2mat(cellfun(@(x) length(x),WinningValidCells,'UniformOutput',false));
            lossingPerCell=cell2mat(cellfun(@(x) length(x),LossingValidCells,'UniformOutput',false));
            motifsTransitionPerCell=cell2mat(cellfun(@(x,y) length(unique([x; y])),LossingValidCells,WinningValidCells,'UniformOutput',false));

            %number of presences
            numberOfCellsWinning(1,j)=sum(winningPerCell>0)/length(validCells);
            numberOfCellsLossing(1,j)=sum(lossingPerCell>0)/length(validCells);
            numberOfCellsLossingOrWinning(1,j)=sum(motifsTransitionPerCell>0)/length(validCells);
            numberOfCellsInNoTransitions(1,j)=(1-numberOfCellsLossingOrWinning(1,j));
            frequencyOfChangesPerCell(1,j)=mean(motifsTransitionPerCell);

            %Data for histograms
            winningNeigh(j,:)=[sum(winningPerCell==0),sum(winningPerCell==1),sum(winningPerCell==2),sum(winningPerCell==3),sum(winningPerCell==4)...
                sum(winningPerCell==5),sum(winningPerCell==6),sum(winningPerCell==7),sum(winningPerCell==8),sum(winningPerCell==9),sum(winningPerCell==10)]/length(validCells);
            lossingNeigh(j,:)=[sum(lossingPerCell==0),sum(lossingPerCell==1),sum(lossingPerCell==2),sum(lossingPerCell==3),sum(lossingPerCell==4)...
                sum(lossingPerCell==5),sum(lossingPerCell==6),sum(lossingPerCell==7),sum(lossingPerCell==8),sum(lossingPerCell==9),sum(lossingPerCell==10)]/length(validCells);
            transitionPerCell(j,:)=[sum(motifsTransitionPerCell==0),sum(motifsTransitionPerCell==1),sum(motifsTransitionPerCell==2),sum(motifsTransitionPerCell==3),sum(motifsTransitionPerCell==4)...
                sum(motifsTransitionPerCell==5),sum(motifsTransitionPerCell==6),sum(motifsTransitionPerCell==7),sum(motifsTransitionPerCell==8),sum(motifsTransitionPerCell==9),sum(motifsTransitionPerCell==10)]/length(validCells);

        end
        
        %Acum data
        listTransitionPerCell(:,:,i)=transitionPerCell';
        listWinningNeigh(:,:,i)=winningNeigh';
        listLossingNeigh(:,:,i)=lossingNeigh';
        listNumberOfCellsWinning(:,i)=numberOfCellsWinning';
        listNumberOfCellsLossing(:,i)=numberOfCellsLossing';
        listNumberOfCellsLossingOrWinning(:,i)=numberOfCellsLossingOrWinning';
        listNumberOfCellsInNoTransitions(:,i)=numberOfCellsInNoTransitions';
        listFrequencyOfChangesPerCell(:,i)=frequencyOfChangesPerCell';
    end

    %averages and std of total data
  
    %table of scutoids presence
    colNames={'meanScutoids','stdScutoids','meanFrusta','stdFrusta','meanWinningNeighbouringBasal',...
        'stdWinningNeighbouringBasal','meanLossingNeighbouringBasal','stdLossingNeighbouringBasal','meanScutoidalEdgesPerCell','stdScutoidalEdgesPerCell'};
    rowNames=arrayfun(@(x) ['surfaceRatio' num2str(x)],listLOriginalProjection.surfaceRatio,'UniformOutput',false);
    tableProportionOfScutoids=array2table([mean(listNumberOfCellsLossingOrWinning,2),std(listNumberOfCellsLossingOrWinning,[],2),...
        mean(listNumberOfCellsInNoTransitions,2),std(listNumberOfCellsInNoTransitions,[],2),...
        mean(listNumberOfCellsWinning,2),std(listNumberOfCellsWinning,[],2),...
        mean(listNumberOfCellsLossing,2),std(listNumberOfCellsLossing,[],2),...
        mean(listFrequencyOfChangesPerCell,2),std(listFrequencyOfChangesPerCell,[],2)],'VariableNames',colNames,'RowNames',rowNames);
    
    colNames={'zero','one','two','three','four','five','six','seven','eight','nine','ten'};

    %distribution of scutoids repetitions, per surface ratio and per cell
    scutoidsDistribution.average=array2table(mean(listTransitionPerCell,3)','VariableNames',colNames,'RowNames',rowNames);
    scutoidsDistribution.std=array2table(std(listTransitionPerCell,[],3)','VariableNames',colNames,'RowNames',rowNames);
    winningNeighDistribution.average=array2table(mean(listWinningNeigh,3)','VariableNames',colNames,'RowNames',rowNames);
    winningNeighDistribution.std=array2table(std(listWinningNeigh,[],3)','VariableNames',colNames,'RowNames',rowNames);
    lossingNeighDistribution.average=array2table(mean(listLossingNeigh,3)','VariableNames',colNames,'RowNames',rowNames);
    lossingNeighDistribution.std=array2table(std(listLossingNeigh,[],3)','VariableNames',colNames,'RowNames',rowNames);


    writetable(tableProportionOfScutoids, [directory2save 'scutoidsProportion_' date '.xls'],'WriteRowNames',true);
    save([directory2save 'distributionScutoidsPerCell_' date '.mat'],'scutoidsDistribution','winningNeighDistribution','lossingNeighDistribution');

    disp(['Presence of scutoids calculated: ' kindProjection '-' num2str(Winitial) 'x' num2str(Hinitial) '_' num2str(numSeeds) 'seeds'])

end