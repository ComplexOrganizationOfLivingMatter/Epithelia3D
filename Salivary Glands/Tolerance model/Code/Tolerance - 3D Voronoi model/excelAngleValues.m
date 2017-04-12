%%Create excel with tolerance angles values.

addpath lib

pathData='D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\';

nImages=20;
nFrames=20;

pathFullData=getAllFiles(pathData);
listTypeStr={};
listAllTypesStr={};
for i = 1:size(pathFullData,1)
    fullPathFile = pathFullData{i};
   
    if isempty(strfind(lower(fullPathFile), '.xls'))==0 || isempty(strfind(lower(fullPathFile), 'out.mat'))==0
    else
        pathSplitted=strsplit(fullPathFile,'_');
        listTypeStr{end+1,1}=pathSplitted{6};
        nameType=[pathSplitted{6} '_' pathSplitted{7}];
        nameType=nameType(1:end-4);
        listAllTypesStr{end+1,1}=nameType;
    end
end
listTypeStr=unique(listTypeStr,'rows');
listAllTypesStr=unique(listAllTypesStr,'rows');

excelClass={};
for i=1:size(listTypeStr,1)
   
    matchedStr=cellfun(@(x)  strfind(x,listTypeStr{i}),listAllTypesStr,'UniformOutput', false);
    matchedStr=find((1-cell2mat(cellfun(@(x)  isempty(x),matchedStr,'UniformOutput', false)))==1);
      
    excelClass{3+(i*10-10),2}=listTypeStr{i};
    
    for j=1:length(matchedStr)
       
        nameSplit=strsplit(listAllTypesStr{matchedStr(j)},'_');
        
        for k=1:nFrames
            
           excelClass{5+(i*10-10),(4+j+(k-1)*(length(matchedStr)+4))}=nameSplit{2};
           listA1=[];
           listAP1=[];
           listA50=[];
           listAP50=[];
           listA99=[];
           listAP99=[];

           excelClass{6+(i*10-10),4+(k-1)*(length(matchedStr)+4)}='ang 1';
           excelClass{7+(i*10-10),4+(k-1)*(length(matchedStr)+4)}='ang Prop to 1';
           excelClass{8+(i*10-10),4+(k-1)*(length(matchedStr)+4)}='ang 50';
           excelClass{9+(i*10-10),4+(k-1)*(length(matchedStr)+4)}='ang Prop to 50';
           excelClass{10+(i*10-10),4+(k-1)*(length(matchedStr)+4)}='ang 99';
           excelClass{11+(i*10-10),4+(k-1)*(length(matchedStr)+4)}='ang Prop to 99';

           for l=1:nImages 
                load([pathData listAllTypesStr{matchedStr(j)} '\Image_' num2str(l) '_Diagram_' num2str(k) '_' listAllTypesStr{matchedStr(j)} '.mat'])

                A1=cat(1,proportionalAngleTau.Angle1);
                AP1=cat(1,proportionalAngleTau.AngleProportional1);
                A50=cat(1,proportionalAngleTau.Angle50);
                AP50=cat(1,proportionalAngleTau.AngleProportional50);
                A99=cat(1,proportionalAngleTau.Angle99);
                AP99=cat(1,proportionalAngleTau.AngleProportional99);

                listA1=[listA1,A1];
                listAP1=[listAP1,AP1];
                listA50=[listA50,A50];
                listAP50=[listAP50,AP50];
                listA99=[listA99,A99];
                listAP99=[listAP99,AP99];

           end
           A1mean= mean(listA1);
           AP1mean= mean(listAP1);
           A50mean= mean(listA50);
           AP50mean= mean(listAP50);
           A99mean= mean(listA99);
           AP99mean= mean(listAP99);

           excelClass{6+(i*10-10),5+(j-1)+(k-1)*(length(matchedStr)+4)}=A1mean;
           excelClass{7+(i*10-10),5+(j-1)+(k-1)*(length(matchedStr)+4)}=AP1mean;
           excelClass{8+(i*10-10),5+(j-1)+(k-1)*(length(matchedStr)+4)}=A50mean;
           excelClass{9+(i*10-10),5+(j-1)+(k-1)*(length(matchedStr)+4)}=AP50mean;
           excelClass{10+(i*10-10),5+(j-1)+(k-1)*(length(matchedStr)+4)}=A99mean;
           excelClass{11+(i*10-10),5+(j-1)+(k-1)*(length(matchedStr)+4)}=AP99mean;
           
        end
       
    end
    
end

xlswrite(['D:\Pedro\Ephitelia 3D\Salivary Glands\Tolerance model\BrokenTolerance_Angles_' date '.xlsx'],excelClass)