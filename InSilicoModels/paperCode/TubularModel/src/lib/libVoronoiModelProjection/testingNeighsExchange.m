function [ numberOfTransitions,nWin,nLoss ] = testingNeighsExchange(L_original,L_originalApical)
    
    %neighbours in basal layer
    [neighs_basal,~]=calculateNeighbours(L_original);
    %neighbours in apical layer
    [neighs_apical,~]=calculateNeighbours(L_originalApical);



     nTransitions=zeros(1,length(neighs_basal));
     nWin=0;
     nLoss=0;

     %testing winning and lossing neighbours between layers
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

