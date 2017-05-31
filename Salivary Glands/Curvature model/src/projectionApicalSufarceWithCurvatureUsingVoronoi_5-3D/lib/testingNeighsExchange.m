function [ numberOfTransitions,nWin,nLoss ] = testingNeighsExchange(L_original,L_originalApical)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[neighs_basal,~]=calculate_neighbours(L_original);
[neighs_apical,~]=calculate_neighbours(L_originalApical);



 nTransitions=zeros(1,length(neighs_basal));
 nWin=0;
 nLoss=0;
 for i=1:length(neighs_basal)
     Lossing = setdiff(neighs_basal{i},neighs_apical{i});
     Winning = setdiff(neighs_apical{i},neighs_basal{i});
     nTransitions(1,i)=length([Lossing;Winning]);
     nWin=nWin+length(Winning);
     nLoss=nLoss+length(Lossing);
%      ['Cell ' num2str(i) ': loss ' num2str(length(Lossing)) ' neighs & win ' num2str(length(Winning)) ' neighs']

 end
 
 %when a cell win another cell has to loss
 numberOfTransitions=sum(nTransitions);


end

