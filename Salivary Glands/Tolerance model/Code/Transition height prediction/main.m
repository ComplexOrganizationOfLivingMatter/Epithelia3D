function main(name2save,pathStructure,frame,cellsGroup,heightRealTransition,hCell,curvature)
 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %[5,10,15,20,30,50,75,100,150,200,250,300,400,500];
    listNoiseRatios=[20,30,50,100];
    nRandom=1000; %number of randomizations
    
    
    %Load label image
    load(pathStructure,'Seq_Img_L')
    
    if strcmp(frame,'end')
        Img=Seq_Img_L{end};
    else
        Img=Seq_Img_L{frame};
    end
    
    %Get only 4 cells neighborhood image
    mask=Img;
    mask1=mask;mask2=mask;mask3=mask;mask4=mask;
    mask1(mask~=cellsGroup(1))=0;mask2(mask~=cellsGroup(2))=0;mask3(mask~=cellsGroup(3))=0;mask4(mask~=cellsGroup(4))=0;
    mask=mask1+mask2+mask3+mask4;
    Img=mask;

    %1000 random model per noise ratio
    parfor indexNoise=1:length(listNoiseRatios)
        name2save
        indexNoise
        randomizedTransitionExtractionData(Img,nRandom,listNoiseRatios,indexNoise,heightRealTransition,hCell,curvature,name2save);
        
    end
    imwrite(Img,[name2save '\motif.jpg']);
    
end