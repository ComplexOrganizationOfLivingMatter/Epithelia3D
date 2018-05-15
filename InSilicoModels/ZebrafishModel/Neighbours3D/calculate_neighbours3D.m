function [neighs_real,sides_cells]=calculate_neighbours3D(L_img)
%CALCULATE_NEIGHBOURS3D   Generate neighbours

    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(cells~=0);                  %% Deleting cell 0 from range
    
    ratio=4;
    %     se = strel('ball',ratio,ratio,0);
    [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
    ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio); 
    
    

    for cel = 1:length(cells)
        cel
        BW= bwperim(L_img==cells(cel));
        %[pi,pj]=find(BW==1);

        BW_dilate=imdilate(BW,ball);
        pixels_neighs=find(BW_dilate==1);
        neighs=unique(L_img(pixels_neighs));
        neighs_real{cells(cel)}=neighs(find(neighs ~= 0 & neighs ~= cells(cel)));
        sides_cells(cells(cel))=length(neighs_real{1,cells(cel)});

    end


end

