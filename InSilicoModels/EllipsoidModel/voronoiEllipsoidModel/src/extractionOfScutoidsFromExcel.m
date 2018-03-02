function [meanPercentajeScutoids,stdPercentajeScutoids]=extractionOfScutoidsFromExcel( noTransitionPath, transitionPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    dataTransition=xlsread(transitionPath);
    dataNoTransition=xlsread(noTransitionPath);

    %number of total cells per randomization (Transition+noTransition)
    
    nRandomTran=unique(dataTransition(:,end));
    nRandomNoTran=unique(dataNoTransition(:,end));
    nRandomTotal=unique([dataTransition(:,end);dataNoTransition(:,end)]);
    nScutoids=zeros(length(nRandomTotal),1);
    nTotalCells=zeros(length(nRandomTotal),1);
    count=1;
    for nRandom=nRandomTotal'
        indexRandomTran= dataTransition(:,end)== nRandom;
        indexRandomNoTran= dataNoTransition(:,end)==nRandom;
        
        motifs = dataTransition(indexRandomTran,1:4);
        scutoidsLabel=unique(motifs(:));
        frustaLabel=unique(dataNoTransition(indexRandomNoTran,1:4));
        nScutoids(count)=length(scutoidsLabel);
        nTotalCells(count)=length(unique(vertcat(unique(frustaLabel),scutoidsLabel)));
        
        count=count+1;
    end
    
    %number of scutoids
    meanPercentajeScutoids= mean(nScutoids./nTotalCells);
    stdPercentajeScutoids=std(nScutoids./nTotalCells);

end

