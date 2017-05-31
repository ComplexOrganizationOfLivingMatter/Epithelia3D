
nImages=20;

listNlossBasApi1=[];
listNlossBasApi2=[];
listNwinBasApi1=[];
listNwinBasApi2=[];
listNtransitionsBasApi1=[];
listNtransitionsBasApi2=[];

for i=1:nImages
    name2load=['D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\Image_' num2str(i) '_Diagram_5\Image_' num2str(i) '_Diagram_5.mat'];
    load(name2load,'nLossBasApi1','nLossBasApi2','numberOfTransitionsBasApi1','numberOfTransitionsBasApi2','nWinBasApi1','nWinBasApi2')
    
    listNlossBasApi1(end+1)=nLossBasApi1;
    listNlossBasApi2(end+1)=nLossBasApi2;
    listNwinBasApi1(end+1)=nWinBasApi1;
    listNwinBasApi2(end+1)=nWinBasApi2;
    listNtransitionsBasApi1(end+1)=numberOfTransitionsBasApi1;
    listNtransitionsBasApi2(end+1)=numberOfTransitionsBasApi2;

end

meanLossBasApi1=mean(listNlossBasApi1);
meanLossBasApi2=mean(listNlossBasApi2);
meanWinBasApi1=mean(listNwinBasApi1);
meanWinBasApi2=mean(listNwinBasApi2);
meanTransitionsBasApi1=mean(listNtransitionsBasApi1);
meanTransitionsBasApi2=mean(listNtransitionsBasApi2);

stdLossBasApi1=std(listNlossBasApi1);
stdLossBasApi2=std(listNlossBasApi2);
stdWinBasApi1=std(listNwinBasApi1);
stdWinBasApi2=std(listNwinBasApi2);
stdTransitionsBasApi1=std(listNtransitionsBasApi1);
stdTransitionsBasApi2=std(listNtransitionsBasApi2);


clearvars -except meanLossBasApi1 meanLossBasApi2 meanWinBasApi1 meanWinBasApi2 meanTransitionsBasApi1 meanTransitionsBasApi2 stdLossBasApi1 stdLossBasApi2 stdWinBasApi1 stdWinBasApi2 stdTransitionsBasApi1 stdTransitionsBasApi2