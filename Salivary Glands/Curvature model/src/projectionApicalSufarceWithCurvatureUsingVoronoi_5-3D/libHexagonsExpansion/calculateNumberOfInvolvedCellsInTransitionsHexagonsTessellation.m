function calculateNumberOfInvolvedCellsInTransitionsHexagonsTessellation(numSeeds)

    numOfSurfaceRatios=10;
    numberOfHistogramsCells=11;
    nameOfFolder=['512x1024_' num2str(numSeeds) 'seeds\'];
    path3dVoronoi=['D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\expansion\cylinderOfHexagons\512x1024_' num2str(numSeeds) 'seeds\'];
    directory2save=['..\..\data\expansion\cylinderOfHexagons\512x1024_' num2str(numSeeds) 'seeds\'];
    addpath('lib')   
    pathV5data=dir([path3dVoronoi '*m_5.mat*']);

    listTransitionPerCell=zeros(numberOfHistogramsCells,numOfSurfaceRatios,size(pathV5data,1));
    listWinningNeigh=zeros(numberOfHistogramsCells,numOfSurfaceRatios,size(pathV5data,1));
    listLossingNeigh=zeros(numberOfHistogramsCells,numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsWinning=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsLossing=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsLossingOrWinning=zeros(numOfSurfaceRatios,size(pathV5data,1));
    listNumberOfCellsInNoTransitions=zeros(numOfSurfaceRatios,size(pathV5data,1));

   
    %load cylindrical Voronoi 5 data
    load([path3dVoronoi pathV5data(1).name],'listLOriginalProjection')

    numberOfCellsWinning=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsLossing=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsLossingOrWinning=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsInNoTransitions=zeros(1,size(listLOriginalProjection,1));
    winningNeigh=zeros(size(listLOriginalProjection,1),numberOfHistogramsCells);
    lossingNeigh=zeros(size(listLOriginalProjection,1),numberOfHistogramsCells);
    transitionPerCell=zeros(size(listLOriginalProjection,1),numberOfHistogramsCells);

    for j=1:size(listLOriginalProjection,1)
        L_basal=listLOriginalProjection.L_originalProjection{1,1};
        L_apical=listLOriginalProjection.L_originalProjection{j,1};
        %calculate neighbourings in apical and basal layers
        [neighs_basal,~]=calculate_neighbours(L_basal);
        [neighs_apical,~]=calculate_neighbours(L_apical);

        %get happening per cell
        Lossing=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
        Winning=cellfun(@(x,y) setdiff(x,y),neighs_apical,neighs_basal,'UniformOutput',false);

        winningPerCell=cell2mat(cellfun(@(x) length(x),Winning,'UniformOutput',false));
        lossingPerCell=cell2mat(cellfun(@(x) length(x),Lossing,'UniformOutput',false));
        motifsTransitionPerCell=cell2mat(cellfun(@(x,y) length(unique([x; y])),Lossing,Winning,'UniformOutput',false));

        %number of presences
        numberOfCellsWinning(1,j)=sum(winningPerCell>0);
        numberOfCellsLossing(1,j)=sum(lossingPerCell>0);
        numberOfCellsLossingOrWinning(1,j)=sum(motifsTransitionPerCell>0);
        numberOfCellsInNoTransitions(1,j)=max(max(L_basal))-numberOfCellsLossingOrWinning(1,j);

        %Data for histograms
        winningNeigh(j,:)=[sum(winningPerCell==0),sum(winningPerCell==1),sum(winningPerCell==2),sum(winningPerCell==3),sum(winningPerCell==4)...
            sum(winningPerCell==5),sum(winningPerCell==6),sum(winningPerCell==7),sum(winningPerCell==8),sum(winningPerCell==9),sum(winningPerCell==10)];
        lossingNeigh(j,:)=[sum(lossingPerCell==0),sum(lossingPerCell==1),sum(lossingPerCell==2),sum(lossingPerCell==3),sum(lossingPerCell==4)...
            sum(lossingPerCell==5),sum(lossingPerCell==6),sum(lossingPerCell==7),sum(lossingPerCell==8),sum(lossingPerCell==9),sum(lossingPerCell==10)];
        transitionPerCell(j,:)=[sum(motifsTransitionPerCell==0),sum(motifsTransitionPerCell==1),sum(motifsTransitionPerCell==2),sum(motifsTransitionPerCell==3),sum(motifsTransitionPerCell==4)...
            sum(motifsTransitionPerCell==5),sum(motifsTransitionPerCell==6),sum(motifsTransitionPerCell==7),sum(motifsTransitionPerCell==8),sum(motifsTransitionPerCell==9),sum(motifsTransitionPerCell==10)];



    end
    %Acum data
    listTransitionPerCell(:,:,1)=transitionPerCell';
    listWinningNeigh(:,:,1)=winningNeigh';
    listLossingNeigh(:,:,1)=lossingNeigh';
    listNumberOfCellsWinning(:,1)=numberOfCellsWinning';
    listNumberOfCellsLossing(:,1)=numberOfCellsLossing';
    listNumberOfCellsLossingOrWinning(:,1)=numberOfCellsLossingOrWinning';
    listNumberOfCellsInNoTransitions(:,1)=numberOfCellsInNoTransitions';


    %averages and std of total data

    finalListTransitionPerCell.average=(listTransitionPerCell)/numSeeds;
    finalListWinningNeigh.average=(listWinningNeigh)/numSeeds;
    finalListLossingNeigh.average=(listLossingNeigh)/numSeeds;
    finalListNumberOfCellsWinning.average=(listNumberOfCellsWinning)/numSeeds;
    finalListNumberOfCellsLossing.average=(listNumberOfCellsLossing)/numSeeds;
    finalListNumberOfCellsLossingOrWinning.average=(listNumberOfCellsLossingOrWinning)/numSeeds;
    finalListNumberOfCellsInNoTransitions.average=(listNumberOfCellsInNoTransitions)/numSeeds;

    save([directory2save 'dataCellsInTransitionMotifs.mat'],'finalListTransitionPerCell','finalListWinningNeigh','finalListLossingNeigh','finalListNumberOfCellsWinning','finalListNumberOfCellsLossing','finalListNumberOfCellsLossingOrWinning','finalListNumberOfCellsInNoTransitions')
end