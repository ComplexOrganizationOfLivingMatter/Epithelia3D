addpath lib

filesList=getAllFiles('..\data\');
cellMaskFiles=logical(cell2mat(cellfun(@(x) ~isempty(strfind(x,'cellMask')),filesList,'UniformOutput',false)));
cellMaskFiles=filesList(cellMaskFiles);
convexityTable=table();

T=readtable('..\data\WT\40X\centroidsDistances_15-Jan-2018.xlsx');
    

for i=1:length(cellMaskFiles)
    
    %read cellMask and cylinderAxis files
    cellMaskImg=imread(cellMaskFiles{i});
    cellMaskName=strsplit(cellMaskFiles{i},'\');
    
    cellMaskImg=bwlabel(bwareaopen(1-im2bw(cellMaskImg),50,4),4);
    cellMaskImg(cellMaskImg==1)=0;
    cellMaskImg=bwlabel(cellMaskImg,4);
    cylinderAxisImgPath=strrep(cellMaskFiles{i},cellMaskName{end},'cylinderAxis.jpg');
    cylinderAxisImg=bwlabel(im2bw(imread(cylinderAxisImgPath)),8);
 
    
    
    
    filePath=strsplit(cellMaskFiles{i,1},{'..','\','data','cellMask','.jpg'});   
    filePath=strjoin(filePath(2:end-1),'\');
    
    if isempty(strfind(filePath,'Up')) && isempty(strfind(filePath,'Down'))
        filePath=[filePath '\'];
    end
    
    %calculate distance to cylinder axis
    [newConvexityTable]=getDistanceToCylinderAxis(cylinderAxisImg,cellMaskImg,filePath,T);
    
    convexityTable=[convexityTable;newConvexityTable];

    
end

save(['..\data\WT\40X\convexityTable_' date '.mat'],'convexityTable')
    