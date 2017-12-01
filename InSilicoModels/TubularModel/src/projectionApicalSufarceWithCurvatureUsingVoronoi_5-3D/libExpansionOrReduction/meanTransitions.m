
nImages=20;

listNloss=[];
listNwin=[];
listNtransitions=[];

for i=1:nImages
    name2load=['D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\data\Image_' num2str(i) '_Diagram_5\Image_' num2str(i) '_Diagram_5.mat'];
    load(name2load,'listTransitionsByCurvature')
    
    listNloss(:,end+1)=listTransitionsByCurvature.nLoss;
    listNwin(:,end+1)=listTransitionsByCurvature.nWins;
    listNtransitions(:,end+1)=listTransitionsByCurvature.nTransitions;

end

meanNLoss=mean(listNloss,2);
meanNWin=mean(listNwin,2);
meanNTransitions=mean(listNtransitions,2);
stdNLoss=std(listNloss,0,2);
stdNWin=std(listNwin,0,2);
stdNTransitions=std(listNtransitions,0,2);

curvatures=listTransitionsByCurvature.reductionProportion;

    listTransitionsByCurvature=[curvatures,meanNWin,stdNWin,meanNLoss,stdNLoss,meanNTransitions,stdNTransitions];

    listTransitionsByCurvature=array2table(listTransitionsByCurvature);
    listTransitionsByCurvature.Properties.VariableNames{1} = 'reductionProportion';
    listTransitionsByCurvature.Properties.VariableNames{2} = 'meanWins';
    listTransitionsByCurvature.Properties.VariableNames{3} = 'stdWins';
    listTransitionsByCurvature.Properties.VariableNames{4} = 'meanLoss';
    listTransitionsByCurvature.Properties.VariableNames{5} = 'stdLoss';
    listTransitionsByCurvature.Properties.VariableNames{6} = 'meanTransitions';
    listTransitionsByCurvature.Properties.VariableNames{7} = 'stdTransitions';

clearvars -except listTransitionsByCurvature