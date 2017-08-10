% A=[11 11 2 3; 5 2 6 9];
% B=[11 3; 2 9];
% idx = ismember(A', B', 'rows');
% c = 1:size(A, 2);
% d = c(idx); % is your answer

% B=[1 18; 1 19; 3 1; 4 18; 4 20; 5 18; 6 12] %In the first column of B elements are always in ascending order but can be repeated more than once
% A=[1 18 19 19 20; 2 7 8 9 10; 3 1 2 2 3; 4 18 19 19 20; 5 18 19 19 20; 6 11 12 13 14] %In the first column of A elements are always in ascending order, they start from 1 and end at a=6 and they are at a distance of 1
% 
%  x = accumarray(B(:,1),B(:,2),[max(B(:,1)),1],@(x){x});
%  C = [A(:,1),cell2mat(arrayfun(@(z)ismember(A(z,2:end),x{z}),A(:,1),'un',0))];


H=cell(size(centroids{numFrame,1}));
%e=round(xQuery{numFrame,1}(i));
% f=round(xQuery{numFrame-1,1});
%[C{numFrame,1},ia{numFrame,1},ib{numFrame,1}] = intersect(round(centroids{numFrame,1}(:, 1)),round(centroids{numFrame-1,1}(:, 1))); %H
a=1;

oldCentroids = ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows'); %Los centroides del nuevo frame que están en los pixeles del anterior
allCentroids = centroids{numFrame}; %Todos los centroides del nuevo frame
newCentroids = allCentroids(oldCentroids == 0, :); %De todos los centroides del nuevo frame, cógeme las filas que tenga como valor 0 según coincida con el anterior frame y todas las columnas
%         if ismember(round(centroids{numFrame,1}),pixel{numFrame-1,1},'rows')==0%&& (round(xQuery{numFrame,1}(i))==round(xQuery{numFrame-1,1}(c)))
%             z=centroids{numFrame,1};
%             H{a,1} = vertcat(H{a,1},z);          
%             a=a+1;
% 
%         end

% H{a,1} = unique(H{a,1});



