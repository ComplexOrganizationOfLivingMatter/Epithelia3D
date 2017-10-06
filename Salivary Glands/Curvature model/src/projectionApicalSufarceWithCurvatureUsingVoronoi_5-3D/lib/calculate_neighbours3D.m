function [neighs_real,sides_cells]=calculate_neighbours3D(L_img)

%% Generate neighbours
    ratio=4;
    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(cells~=0);                  %% Deleting cell 0 from range

    [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
    ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio); 
    
    for cel=1 : length(cells)
        
        BW = L_img==cells(cel);
        BW_dilate=imdilate(BW,ball);
        pixels_neighs=find(BW_dilate==1);
        neighs=unique(L_img(pixels_neighs));
        neighs_real{cells(cel)}=neighs(find(neighs ~= 0 & neighs ~= cells(cel)));
        sides_cells(cells(cel))=length(neighs_real{1,cells(cel)});

    end


end

