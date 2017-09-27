function [neighs_real, sides_cells] = calculate_neighbours3D(L_img)

%% Generate neighbours
    ratio=2;
    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(cells~=0);                  %% Deleting cell 0 from range

    [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
    ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio); 
    
    for cell = 1 : length(cells)
        cell
        BW_dilate = imdilate(L_img==cells(cell), ball);
        pixels_neighs=find(BW_dilate==1);
        neighs=unique(L_img(pixels_neighs));
        neighs_real{cells(cell)}=neighs(neighs ~= 0 & neighs ~= cells(cell));
        sides_cells(cells(cell))=length(neighs_real{1,cells(cell)});
    end
end

