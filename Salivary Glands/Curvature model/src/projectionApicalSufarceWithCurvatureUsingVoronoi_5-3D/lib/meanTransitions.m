
nImages=20;

listNloss=[];
listNwin=[];
listNtransitions=[];

for i=1:nImages
    name2load=['D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\Image_' num2str(i) '_Diagram_5\Image_' num2str(i) '_Diagram_5.mat'];
    load(name2load,'listTransitionsByCurvature')
    
    listNloss(:,end+1)=listTransitionsByCurvature.nLoss;
    listNwin(:,end+1)=listTransitionsByCurvature.nWins;
    listNtransitions(:,end+1)=listTransitionsByCurvature.nTransitions;

end

meanNLoss=mean(listNloss);
meanNWin=mean(listNloss);
meanNTransitions=mean(listNloss);
stdNLoss=std(listNloss);
stdNWin=std(listNloss);
stdNTransitions=std(listNloss);

curvatures=listTransitionsByCurvature.reductionProportion;

    listTransitionsByCurvature=[curvatures,meanNWin,meanNLoss,meanNTransitions,stdWin,stdNLoss,stdNTransitions];

    listTransitionsByCurvature=array2table(listTransitionsByCurvature);
    listTransitionsByCurvature.Properties.VariableNames{1} = 'reductionProportion';
    listTransitionsByCurvature.Properties.VariableNames{2} = 'meanWins';
    listTransitionsByCurvature.Properties.VariableNames{3} = 'meanLoss';
    listTransitionsByCurvature.Properties.VariableNames{4} = 'meanTransitions';
    listTransitionsByCurvature.Properties.VariableNames{5} = 'stdWins';
    listTransitionsByCurvature.Properties.VariableNames{6} = 'stdLoss';
    listTransitionsByCurvature.Properties.VariableNames{7} = 'stdTransitions';

clearvars -except listTransitionsByCurvature