initialPath='D:\Pedro\Epithelia3D\InSilicoModels\paperCode\TubularModel\data\tubularVoronoiModel\expansion\512x4096_60seeds\energy\';
pathTableAngleFilter=[initialPath 'voronoiModelEnergy_60seeds_surfaceRatio6.6667_Transitions_AngleThreshold_04-Apr-2018.xls'];
pathTotalTable=[initialPath 'voronoiModelEnergy_60seeds_surfaceRatio6.6667_Transitions_04-Apr-2018.xls'];
tableFilter=readtable(pathTableAngleFilter);
tableTotal=readtable(pathTotalTable);

outlayerLength=350;

motifsFilter=table2array(tableFilter(:,[1:4,19]));
motifsTotal=table2array(tableTotal(:,[1:4,19]));

indexesMatching=ismember(motifsTotal,motifsFilter,'rows');

complementaryTable=tableTotal(~indexesMatching,:);

indexesOutlayer=(table2array(complementaryTable(:,[5:6,8:13,15:18]))>outlayerLength);
[xi,yi]=find(indexesOutlayer);
complementaryTable2=complementaryTable;
complementaryTable2(xi,:)=[];
desktopDir='C:\Users\Luisma\Desktop\expansion\512x4096_60seeds\energy\';
name2save=strrep(pathTableAngleFilter,initialPath,desktopDir);
writetable(complementaryTable2,strrep(name2save,'AngleThreshold','ComplementaryAngleThreshold'))