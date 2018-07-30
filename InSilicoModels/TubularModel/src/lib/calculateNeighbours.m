function [neighs_real,sides_cells]=calculateNeighbours(L_img)

%% Generate neighbours
    ratio=5;
    se = strel('disk',ratio);
    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(2:end);                  %% Deleting cell 0 from range


    for cel=1 : length(cells)
        BW = bwperim(L_img==cells(cel));
        BW_dilate=imdilate(BW,se);
        neighs=unique(L_img(BW_dilate==1));
        neighs_real{cells(cel)}=neighs((neighs ~= 0 & neighs ~= cells(cel)));
        sides_cells(cells(cel))=length(neighs_real{1,cells(cel)});

    end


end