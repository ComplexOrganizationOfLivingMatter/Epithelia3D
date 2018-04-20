function [ neighs_real ] = calculateNeighboursByThreshold( L_img,ratio )

    %% Generate neighbours
    se = strel('disk',ratio+1);
    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(2:end);                  %% Deleting cell 0 from range


    for cel=1 : length(cells)
        BW = bwperim(L_img==cells(cel));
        [pi,pj]=find(BW==1);

        BW_dilate=imdilate(BW,se);
        pixels_neighs=find(BW_dilate==1);
        neighs=unique(L_img(pixels_neighs));
        neighs_real{cells(cel)}=neighs(find(neighs ~= 0 & neighs ~= cells(cel)));
        sides_cells(cells(cel))=length(neighs_real{1,cells(cel)});

    end




end

