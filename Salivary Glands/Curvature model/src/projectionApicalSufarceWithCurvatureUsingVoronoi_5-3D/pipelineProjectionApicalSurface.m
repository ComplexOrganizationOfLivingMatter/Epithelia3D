%pipeline
function pipelineProjectionApicalSurface (numSeeds)

    nameOfFolder=['512x1024_' num2str(numSeeds) 'seeds\'];

    path3dVoronoi=['D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\Cylindrical voronoi\' nameOfFolder];
    directory2save='..\..\data\';
    addpath('lib')

    pathV5data=dir([path3dVoronoi '*m_5*']);

    listOfCurvature=0.1:0.1:1;

    acumListTransitionByCurv=zeros(length(listOfCurvature),size(pathV5data,1)*3);
    for i=1:size(pathV5data,1)

        listTransitionsByCurvature=[];
        listSeedsApical={};
        listLOriginalApical={};

        load([path3dVoronoi pathV5data(i).name])

        [H,W]=size(L_original);
        %% Diameter of cell calculation and estimate heigth of cell and 'lumen'
        mask=L_original;
        for j=1:length(border_cells)
            mask(L_original==border_cells(j))=0;
        end



        for j=1:length(listOfCurvature)



            %% Curvature implication - recalculate seeds and labelled images
            curvature=listOfCurvature(j);

            seedsBasal=sortrows(seeds_values_before,1);
            seedsApical=[seedsBasal(:,1:2),round(seedsBasal(:,3)*curvature)];

            L_originalApical=generateCylindricalVoronoi(seedsApical,H,round(W*curvature));

            %% Representations
            seeds_values_before=sortrows(seeds_values_before,1);
            numCells=size(seeds_values_before,1);

            name2save=pathV5data(i).name;
            name2save=name2save(1:end-4);

            if j==1
                representAndSaveFigureWithColourfulCells(L_original,numCells,seeds_values_before(:,2:3),[directory2save nameOfFolder], name2save,'_basal')
            end
            representAndSaveFigureWithColourfulCells(L_originalApical,numCells,seedsApical(:,2:3),[directory2save nameOfFolder],name2save, ['_apicalReduction' num2str(1-curvature)])

            %% Testing neighs exchanges
            [numberOfTransitionsBasApi,nWinBasApi,nLossBasApi] = testingNeighsExchange(L_original,L_originalApical);

            apicalReduction=1-curvature;
            listTransitionsByCurvature(end+1,:)=[apicalReduction,nWinBasApi,nLossBasApi,numberOfTransitionsBasApi];
            listSeedsApical{end+1,1}=apicalReduction;listSeedsApical{end,2}=seedsApical;
            listLOriginalApical{end+1,1}=apicalReduction;listLOriginalApical{end,2}=L_originalApical;
            close all


        end

        acumListTransitionByCurv(:,i)=listTransitionsByCurvature(:,2);
        acumListTransitionByCurv(:,i+20)=listTransitionsByCurvature(:,3);
        acumListTransitionByCurv(:,i+40)=listTransitionsByCurvature(:,4);

        listTransitionsByCurvature=array2table(listTransitionsByCurvature);
        listTransitionsByCurvature.Properties.VariableNames{1} = 'apicalReduction';
        listTransitionsByCurvature.Properties.VariableNames{2} = 'nWins';
        listTransitionsByCurvature.Properties.VariableNames{3} = 'nLoss';
        listTransitionsByCurvature.Properties.VariableNames{4} = 'nTransitions';

        listSeedsApical=cell2table(listSeedsApical);
        listSeedsApical.Properties.VariableNames{1} = 'apicalReduction';
        listSeedsApical.Properties.VariableNames{2} = 'seedsApical';

        listLOriginalApical=cell2table(listLOriginalApical);
        listLOriginalApical.Properties.VariableNames{1} = 'apicalReduction';
        listLOriginalApical.Properties.VariableNames{2} = 'L_originalApical';

        save([directory2save nameOfFolder name2save '\'  name2save '.mat'],'listLOriginalApical','listSeedsApical','listTransitionsByCurvature')



    end

    listAcumTransitions=sortrows([(1-listOfCurvature'),mean(acumListTransitionByCurv(:,1:20),2)/numSeeds,std(acumListTransitionByCurv(:,1:20),0,2)/numSeeds,mean(acumListTransitionByCurv(:,21:40),2)/numSeeds,...
            std(acumListTransitionByCurv(:,21:40),0,2)/numSeeds,mean(acumListTransitionByCurv(:,41:end),2)/numSeeds,std(acumListTransitionByCurv(:,41:end),0,2)/numSeeds]);

    listAcumTransitions=array2table(listAcumTransitions);
    listAcumTransitions.Properties.VariableNames{1} = 'apicalReduction';
    listAcumTransitions.Properties.VariableNames{2} = 'meanWins';
    listAcumTransitions.Properties.VariableNames{3} = 'stdWins';
    listAcumTransitions.Properties.VariableNames{4} = 'meanLoss';
    listAcumTransitions.Properties.VariableNames{5} = 'stdLoss';
    listAcumTransitions.Properties.VariableNames{6} = 'meanTransitions';    
    listAcumTransitions.Properties.VariableNames{7} = 'stdTransitions';    

    save([directory2save nameOfFolder 'summaryAverageTransitions.mat'],'listAcumTransitions')


end