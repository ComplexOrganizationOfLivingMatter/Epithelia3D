function [ L_original ] = generateCylindricalVoronoi(seeds_values,H,W)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Generate Voronoi image
        
        seeds=seeds_values(:,2:3);
        seeds(seeds==0)=1;
        image=zeros(H,W); % Define image to assign seeds
        for i=1:size(seeds,1)
            image(seeds(i,1),seeds(i,2))=1;
        end

        % Triplicate image to adapt to a cylindrical Voronoi
        x3_image=[image,image,image];
        D_x3 = bwdist(x3_image);        % Apply transform of distance
        DL_x3 = watershed(D_x3);        % Split in regions closer to seed
        bgm_x3 = DL_x3 == 0;            % Cells = 0 , outline = 1.
        Voronoi_x3=bgm_x3;

        L_original_x3=bwlabel(1-Voronoi_x3,8);  % Label cells
        
        %% Label correctly cells of the lateral edges
        Voronoi_x2=Voronoi_x3(:,W+1:end);
        L_original_x2=bwlabel(1-Voronoi_x2,8);
        
        % Get sort labels right border
        right_border_cells=L_original_x2(:,W+1);
        [cel_1,idx_1]=unique(right_border_cells);
        Rig=[cel_1(2:end),idx_1(2:end)];
        Cells_right_sorted=sortrows(Rig,2);
        Cells_right=Cells_right_sorted(:,1);
        
        %Get sort labels left border
        left_border_cells=L_original_x2(:,1);
        [cel_2,idx_2]=unique(left_border_cells);
        Lef=[cel_2(2:end),idx_2(2:end)];
        Cells_left_sorted=sortrows(Lef,2);
        Cells_left=Cells_left_sorted(:,1);
        
        %Asigg 0 to right cells in L_original because could generate
        %errors, due to the reassignation. So, we need relabel L_original
        %to get a really sorted labelled image.
        aux=L_original_x2(1:H,1:W);
        for i=1:length(Cells_left)
            aux(aux==Cells_right(i))=0;
        end
        L_original=bwlabel(aux);
        
        %Label cells of right border with left border label
        for i=1:length(Cells_left)
            L_original(L_original_x2(1:H,1:W)==Cells_right(i))=Cells_left(i);
        end
        
        %Relabel with labels in BASAL
        L_original=L_original(1:H,1:W);
        mask=L_original;
        for i=1:size(seeds,1)
            mask(L_original==L_original(seeds(i,1),seeds(i,2)))=seeds_values(i,1);
        end
        
        L_original=mask;

end

