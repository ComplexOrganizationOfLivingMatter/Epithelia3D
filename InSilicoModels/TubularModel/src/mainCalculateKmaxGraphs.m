%%main calculate K-graph connectivity
addpath(genpath('lib'))

%testing k6 graph family or more
folderData = '..\..\..\3D_laws\';
fileMat = 'delaunayEuler3D_1000seeds_sr2000_04-Feb-2019.mat';
    
%load Neigh accum
load([folderData fileMat],'neighsAccumFinalSR')
 matfile([folderData fileMat])
neighsAccumFinalSR = neighsAccum(:,end);
%accumulate neighbours

%valid cells
%here we consider all valid cells in neighsAccumFinalSR
[nQuartets,nQuintets,nSixtets,nSeventets,nEightets] = captureKmax(neighsAccumFinalSR);

save([folderData 'kgraphMax_delaunayEuler3D_1000seeds_sr2000.mat'],'nQuartets','nQuintets','nSixtets','nSeventets','nEightets')