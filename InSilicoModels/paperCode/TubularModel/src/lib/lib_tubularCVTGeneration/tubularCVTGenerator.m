function [seeds,seeds_values_before,L_original,border_cells,valid_cells,pathToSaveData]=tubularCVTGenerator(i,j,H,W,seeds,seeds_values_before,folder2save,folderPath)
%TUBULARCVTGENERATOR develop the voronoi centroidal path over a
%tubular surface
    image=zeros(H,W); % Define image to assign seeds

    %placing the seeds
    for k=1:size(seeds,1)
        image(seeds(k,1),seeds(k,2))=1;
    end

    % Triplicate image to adapt to a cylindrical Voronoi
    x3_image=[image,image,image];
    D_x3 = bwdist(x3_image);        % Apply transform of distance
    DL_x3 = watershed(D_x3);        % Split in regions closer to seed
    bgm_x3 = DL_x3 == 0;            % Cells = 0 , outline = 1.
    Voronoi_x3=bgm_x3;
    L_original_x3=bwlabel(1-Voronoi_x3,8);  % Label cells

    % Label correctly cells in lateral borders
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

    %Asign 0 to right cells in L_original because could generate
    %errors, due to the reassignation. So, we need relabel L_original
    %to get a really sorted labelled image.
    aux=L_original_x2(1:H,1:W);
    for k=1:length(Cells_right)
        aux(aux==Cells_right(k))=0;
    end
    L_original=bwlabel(aux);

    %Label cells of right border with left border label. 
    %It could appear a problem if the number of left and right cells is different. It is not usual, but may occur
    %Here we delete false positives
    [L_original_x2,L_original,Cells_left,Cells_right] = testingRealBorderCells( Cells_right,Cells_left,L_original,L_original_x2,H,W);      

    %relabel joined border cells with the same label
    for f=1:length(Cells_left)
        L_original(L_original_x2(1:H,1:W)==Cells_right(f))=Cells_left(f);
    end

    % Update label in comparison with the diagram labelled before, if is a diagram higher than 1.
    if j~=1
       aux_2=L_original;
       for h=1:size(seeds_values_before,1)
           aux_2(L_original==L_original(seeds_values_before(h,2),seeds_values_before(h,3)))=seeds_values_before(h,1);
       end
       L_original=aux_2; 
    else
        seeds_values_before=0;           
    end
    border_cells=unique(L_original(:,1));
    border_cells=border_cells(2:end);

    % Get centroids
    center = regionprops(L_original_x3,'Centroid');
    new_centroids = cat(1, center.Centroid);
    new_centroids=round(new_centroids);
    new_centroids=fliplr(new_centroids); %[rows,columns]

    %filter only centroids of central image (L_original_x3[:,W+1:end-W])
    a=find(new_centroids(:,2)>= W+1);
    b=find(new_centroids(:,2)<= 2*W);
    seeds_pos=intersect(a,b);
    central_seeds=new_centroids(seeds_pos,:);
    new_seeds=[central_seeds(:,1),central_seeds(:,2)-W];

    %Get centroid label to update later
    centroid_label=L_original(new_seeds(:,1),new_seeds(:,2)); %avoid a loop for
    labels=diag(centroid_label);
    new_seeds_values=[labels,new_seeds];

    % Valid and non valid cells
    mask=zeros(H,W);
    mask(1,:)=1;
    mask(H,:)=1;
    mask=L_original.*mask;
    no_valid_cells=unique(mask);
    no_valid_cells=no_valid_cells(2:end);
    valid_cells=setxor(1:size(seeds,1),no_valid_cells);

    % Saving
    FOLDER_1=[folderPath '\Images\' folder2save];
    if ~isdir(FOLDER_1)
        mkdir(FOLDER_1)
    end

    FOLDER_2=[folderPath '\Data\' folder2save];    
    if ~isdir(FOLDER_2)
        mkdir(FOLDER_2)
    end

    Name=['Image_',num2str(i),'_Diagram_',num2str(j)];
    pathToSaveData=[FOLDER_2 '\' Name '.mat'];

    save(pathToSaveData,'L_original','seeds','new_seeds','seeds_values_before','new_seeds_values','border_cells','valid_cells','no_valid_cells')
    imwrite(L_original, [FOLDER_1  '\' Name '.png'])

    % Updating seeds
    seeds=new_seeds;
    seeds_values_before=new_seeds_values;
        
     
 end

