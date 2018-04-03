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

    for i=1:size(pathV5data,1)

        %load cylindrical Voronoi 5 data
        nameFile=pathV5data(i).name;
        load([directory2save nameFile(1:end-4) '\' nameFile],'listLOriginalProjection')

        numberOfCellsWinning=zeros(1,size(listLOriginalProjection,1));
        numberOfCellsLossing=zeros(1,size(listLOriginalProjection,1));
        numberOfCellsLossingOrWinning=zeros(1,size(listLOriginalProjection,1));
        numberOfCellsInNoTransitions=zeros(1,size(listLOriginalProjection,1));
        winningNeigh=zeros(size(listLOriginalProjection,1),numberOfRows);
        lossingNeigh=zeros(size(listLOriginalProjection,1),numberOfRows);
        transitionPerCell=zeros(size(listLOriginalProjection,1),numberOfRows);

        for j=1:size(listLOriginalProjection,1)
            L_basal=listLOriginalProjection.L_originalProjection{1,1};
            L_apical=listLOriginalProjection.L_originalProjection{j,1};
            %calculate no valid cells
            noValidCells=unique(L_basal([1 end],:),L_apical([1 end],:));
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
            numberOfCellsWinning(1,j)=sum(winningPerCell>0);
            numberOfCellsLossing(1,j)=sum(lossingPerCell>0);
            numberOfCellsLossingOrWinning(1,j)=sum(motifsTransitionPerCell>0);
            numberOfCellsInNoTransitions(1,j)=max(max(L_basal))-numberOfCellsLossingOrWinning(1,j);

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
            listNumberOfCellsWinning(:,i)=numberOfCellsWinning'/length(validCells);
            listNumberOfCellsLossing(:,i)=numberOfCellsLossing'/length(validCells);
            listNumberOfCellsLossingOrWinning(:,i)=numberOfCellsLossingOrWinning'/length(validCells);
            listNumberOfCellsInNoTransitions(:,i)=numberOfCellsInNoTransitions'/length(validCells);
    end


    %averages and std of total data
    finalListTransitionPerCell.average=mean(listTransitionPerCell,3);
    finalListTransitionPerCell.standardDeviation=std(listTransitionPerCell,[],3);
    finalListWinningNeigh.average=mean(listWinningNeigh,3);
    finalListWinningNeigh.standardDeviation=std(listWinningNeigh,[],3);
    finalListLossingNeigh.average=mean(listLossingNeigh,3);
    finalListLossingNeigh.standardDeviation=std(listLossingNeigh,[],3);
    finalListNumberOfCellsWinning.average=mean(listNumberOfCellsWinning,2);
    finalListNumberOfCellsWinning.standardDeviation=std(listNumberOfCellsWinning,[],2);
    finalListNumberOfCellsLossing.average=mean(listNumberOfCellsLossing,2);
    finalListNumberOfCellsLossing.standardDeviation=std(listNumberOfCellsLossing,[],2);
    finalListNumberOfCellsLossingOrWinning.average=mean(listNumberOfCellsLossingOrWinning,2);
    finalListNumberOfCellsLossingOrWinning.standardDeviation=std(listNumberOfCellsLossingOrWinning,[],2);
    finalListNumberOfCellsInNoTransitions.average=mean(listNumberOfCellsInNoTransitions,2);
    finalListNumberOfCellsInNoTransitions.standardDeviation=std(listNumberOfCellsInNoTransitions,[],2);

    save([directory2save 'dataCellsInTransitionMotifs.mat'],'finalListTransitionPerCell','finalListWinningNeigh','finalListLossingNeigh','finalListNumberOfCellsWinning','finalListNumberOfCellsLossing','finalListNumberOfCellsLossingOrWinning','finalListNumberOfCellsInNoTransitions')
end