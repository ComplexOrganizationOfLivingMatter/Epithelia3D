function [neighs_real]=calculateNeighbours(L_img,ratioStrel)

%% Generate neighbours
    se = strel('disk',ratioStrel);
    
    cells=sort(unique(L_img));
    cells=cells(2:end);                  %% Deleting cell 0 from range
    neighs_real=cell(length(cells),1);

    for cel=1 : length(cells)
        BW = bwperim(L_img==cells(cel));
        BW_dilate=imdilate(BW,se);
        neighs=unique(L_img(BW_dilate==1));
        neighs_real{cells(cel)}=neighs((neighs ~= 0 & neighs ~= cells(cel)));
    end


end