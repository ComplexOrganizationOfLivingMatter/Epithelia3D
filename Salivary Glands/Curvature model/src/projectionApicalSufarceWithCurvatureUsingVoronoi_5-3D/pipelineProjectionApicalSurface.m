%pipeline
function pipelineProjectionApicalSurface (numSeeds,kindProjection)

    nameOfFolder=['512x1024_' num2str(numSeeds) 'seeds\'];

    path3dVoronoi=['D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\Cylindrical voronoi\' nameOfFolder];
    directory2save='..\..\data\';
    addpath('lib')

    pathV5data=dir([path3dVoronoi '*m_5*']);

    switch kindProjection
        case {'expansion'}
            listOfCurvature=1:10;
        case {'reduction'}
            listOfCurvature=0.1:0.1:1;
    end
    

    acumListTransitionByCurv=zeros(length(listOfCurvature),size(pathV5data,1)*3);
    acumListDataAngles=cell(size(pathV5data,1),1);
    totalAngles=cell(length(listOfCurvature),size(pathV5data,1));
    totalEdgesTransition=cell(length(listOfCurvature),size(pathV5data,1));
    for i=1:size(pathV5data,1)

        listTransitionsByCurvature=[];
        listDataAngles=[];
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

            %define apical reduction
            switch kindProjection
                case {'expansion'}
                    apicalReduction=1-curvature/10;
                case {'reduction'}
                    apicalReduction=1-curvature;
            end
            
            %% Representations
            seeds_values_before=sortrows(seeds_values_before,1);
            numCells=size(seeds_values_before,1);

            name2save=pathV5data(i).name;
            name2save=name2save(1:end-16);

%             if j==1
%                 representAndSaveFigureWithColourfulCells(L_original,numCells,seeds_values_before(:,2:3),[directory2save kindProjection '\' nameOfFolder], name2save,'_basal')
%             end
            representAndSaveFigureWithColourfulCells(L_originalApical,numCells,seedsApical(:,2:3),[directory2save kindProjection '\' nameOfFolder],name2save, ['_apicalReduction' num2str(apicalReduction)])

            %% Testing neighs exchanges
            [numberOfTransitionsBasApi,nWinBasApi,nLossBasApi] = testingNeighsExchange(L_original,L_originalApical);

            
            %% Measure angles of edges
            if nWinBasApi>0
                [dataAngles]=measureAnglesAndLengthOfEdgesTransition(L_original,L_originalApical);
                listDataAngles(end+1,:)=[dataAngles.numOfEdgesOfTransition,dataAngles.proportionAnglesLess15deg,dataAngles.proportionAnglesBetween15_30deg,dataAngles.proportionAnglesBetween30_45deg,dataAngles.proportionAnglesBetween45_60deg,dataAngles.proportionAnglesBetween60_75deg,dataAngles.proportionAnglesBetween75_90deg];
                totalAngles{j,i}=dataAngles.angles;
                totalEdgesTransition{j,i}=dataAngles.edgeLength;
            else
                dataAngles=[];
                listDataAngles(end+1,:)=[0 0 0 0 0 0 0];
            end
            
            
            
            
            listTransitionsByCurvature(end+1,:)=[apicalReduction,nWinBasApi,nLossBasApi,numberOfTransitionsBasApi];
            listSeedsApical{end+1,1}=apicalReduction;listSeedsApical{end,2}=seedsApical;
            listLOriginalApical{end+1,1}=apicalReduction;listLOriginalApical{end,2}=L_originalApical;
            
            close all


        end

        acumListTransitionByCurv(:,i)=listTransitionsByCurvature(:,2);
        acumListTransitionByCurv(:,i+20)=listTransitionsByCurvature(:,3);
        acumListTransitionByCurv(:,i+40)=listTransitionsByCurvature(:,4);
        
        acumListDataAngles{i,1}=listDataAngles;
        
        listDataAngles=array2table(listDataAngles);
        listDataAngles.Properties.VariableNames={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
        listTransitionsByCurvature=array2table(listTransitionsByCurvature);
        listTransitionsByCurvature.Properties.VariableNames = {'apicalReduction','nWins', 'nLoss','nTransitions'};
        listSeedsApical=cell2table(listSeedsApical);
        listSeedsApical.Properties.VariableNames = {'apicalReduction','seedsApical'};
        listLOriginalApical=cell2table(listLOriginalApical);
        listLOriginalApical.Properties.VariableNames= {'apicalReduction','L_originalApical'};
        
        save([directory2save kindProjection '\' nameOfFolder name2save '\'  name2save '.mat'],'listLOriginalApical','listSeedsApical','listTransitionsByCurvature','listDataAngles')



    end

    
    listAcumTransitions=sortrows([(1-listOfCurvature'),mean(acumListTransitionByCurv(:,1:20),2)/numSeeds,std(acumListTransitionByCurv(:,1:20),0,2)/numSeeds,mean(acumListTransitionByCurv(:,21:40),2)/numSeeds,...
            std(acumListTransitionByCurv(:,21:40),0,2)/numSeeds,mean(acumListTransitionByCurv(:,41:end),2)/numSeeds,std(acumListTransitionByCurv(:,41:end),0,2)/numSeeds]);

    listAcumTransitions=array2table(listAcumTransitions);
    listAcumTransitions.Properties.VariableNames = {'apicalReduction','meanWins','stdWins','meanLoss','stdLoss','meanTransitions' ,'stdTransitions'};    

    acumListDataAngles=cat(3,acumListDataAngles{:});
    meanListDataAngles=array2table(mean(acumListDataAngles,3));
    stdListDataAngles=array2table(std(acumListDataAngles,[],3));
    meanListDataAngles.Properties.VariableNames ={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};
    stdListDataAngles.Properties.VariableNames ={'numOfEdgesOfTransition','proportionAnglesLess15deg','proportionAnglesBetween15_30deg','proportionAnglesBetween30_45deg','proportionAnglesBetween45_60deg','proportionAnglesBetween60_75deg','proportionAnglesBetween75_90deg'};

    boxTreshLength=round(max(vertcat(totalEdgesTransition{:,:}))/5)-1;
    proportionEdges=cellfun(@(x) [sum(x<=boxTreshLength),sum(x<=2*boxTreshLength & x>boxTreshLength),sum(x<=3*boxTreshLength & x>2*boxTreshLength),sum(x<=4*boxTreshLength & x>3*boxTreshLength),sum(x>4*boxTreshLength)]/length(x),totalEdgesTransition,'UniformOutput',false);
    
    meanListLengthEdges=zeros(length(listOfCurvature),5);
    stdListLengthEdges=zeros(length(listOfCurvature),5);
    acumAngles=cell(length(listOfCurvature),1);
    acumEdgesTransition=cell(length(listOfCurvature),1);
    for i=1:length(listOfCurvature)
        acumAngles{i}=cat(1,totalAngles{i,:});
        acumEdgesTransition{i}=cat(1,totalEdgesTransition{i,:});
        meanListLengthEdges(i,:)=mean(cat(1,proportionEdges{i,:}));
        stdListLengthEdges(i,:)=std(cat(1,proportionEdges{i,:}));
    end
    meanListLengthEdges=array2table(meanListLengthEdges);
    stdListLengthEdges=array2table(stdListLengthEdges);
    meanListLengthEdges.Properties.VariableNames ={['XlowerOrEqual' num2str(boxTreshLength)],['between' num2str(boxTreshLength) 'and' num2str(2*boxTreshLength) ],['between' num2str(2*boxTreshLength) 'and' num2str(3*boxTreshLength) ],['between' num2str(3*boxTreshLength) 'and' num2str(4*boxTreshLength) ],['Xupper' num2str(4*boxTreshLength) ]};
    stdListLengthEdges.Properties.VariableNames ={['XlowerOrEqual' num2str(boxTreshLength)],['between' num2str(boxTreshLength) 'and' num2str(2*boxTreshLength) ],['between' num2str(2*boxTreshLength) 'and' num2str(3*boxTreshLength) ],['between' num2str(3*boxTreshLength) 'and' num2str(4*boxTreshLength) ],['Xupper' num2str(4*boxTreshLength) ]};
    
    save([directory2save kindProjection '\' nameOfFolder 'summaryAverageTransitions.mat'],'listAcumTransitions','meanListDataAngles','stdListDataAngles','acumAngles','acumEdgesTransition','totalAngles','totalEdgesTransition','boxTreshLength','meanListLengthEdges','stdListLengthEdges')

end