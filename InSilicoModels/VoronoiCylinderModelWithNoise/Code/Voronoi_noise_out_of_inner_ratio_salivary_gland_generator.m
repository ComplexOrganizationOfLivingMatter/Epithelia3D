%Voronoi Noise - Inner salivary gland model. OUTSIDE RATIO
%This method get a noise region around centroid point of cells. This region is the half of minimal distace
%between centroid and nearest edge of cell.

function Voronoi_noise_out_of_inner_ratio_salivary_gland_generator(i,j)

    H=512; % Size Y axis 
    W=512; % Size X axis

   


            %% Noise ratio calculation

            load(['..\Images\Data\External cylindrical voronoi\Image_' num2str(i) '_Diagram_' num2str(j) '_Vonoroi_out.mat'],'L_original','new_seeds_values','border_cells')

            n_cells=max(max(L_original));

            sorted_seeds_values=sortrows(new_seeds_values,1);

            noise_ratio_list=[];

            %Case 1. Cell to calculate noise region is a border cell

            for k=1:length(border_cells)

                mask=zeros(H,W);
                mask(L_original==border_cells(k))=1;

                %Extend image due to cylinder shape

                mask_x2_half=[mask(:,W/2:end),mask,mask(:,1:W/2)];

                mask_dilate=imdilate(mask_x2_half,[1,1,1;1,1,1;1,1,1]);
                mask_border=mask_dilate-mask_x2_half;

                %Getting centroid position
                centroid_pos=sorted_seeds_values(border_cells(k),2:3);
                centroid_pos(2)=centroid_pos(2)+W/2;

                %Getting edges positions
                Pos_px=regionprops(mask_border==1,'PixelList');            
                Pos_px=[Pos_px(1).PixelList;Pos_px(2).PixelList];
                Pos_px=fliplr(Pos_px);

                %Get all distances since centroid to edges
                distances=sqrt((centroid_pos(1)-Pos_px(:,1)).^2 + (centroid_pos(2)-Pos_px(:,2)).^2); 

                distance_closest_edge=min(distances);

                %Ratio is half of nearest distance
                noise_ratio_list=[noise_ratio_list;[border_cells(k),round(distance_closest_edge/2)]];
            end

            no_lateral_border_cells=setxor(1:n_cells,border_cells);

            %Case 2. Cell is not a lateral border cell

            for k=1:length(no_lateral_border_cells)

                mask=zeros(H,W);
                mask(L_original==no_lateral_border_cells(k))=1;

                mask_dilate=imdilate(mask,[1,1,1;1,1,1;1,1,1]);
                mask_border=mask_dilate-mask;

                %Getting centroid position
                centroid_pos=sorted_seeds_values(no_lateral_border_cells(k),2:3);

                %Getting edges positions
                Pos_px=regionprops(mask_border==1,'PixelList');            
                Pos_px=Pos_px.PixelList;
                Pos_px=fliplr(Pos_px);

                %Get all distances since centroid to edges
                distances=sqrt((centroid_pos(1)-Pos_px(:,1)).^2 + (centroid_pos(2)-Pos_px(:,2)).^2); 

                distance_closest_edge=min(distances);

                %Ratio is half of nearest distance
                noise_ratio_list=[noise_ratio_list;[no_lateral_border_cells(k),round(distance_closest_edge/2)]];

            end

            noise_ratio_list=sortrows(noise_ratio_list,1);

            %% Chose ramdon seed point OUT of noisy region
            seeds_noise=[];

            for m=1:n_cells

               mask_3x=zeros(H,3*W); 
               mask_3x(sorted_seeds_values(m,2),sorted_seeds_values(m,3)+W)=1;

               %Discard dilated centroid disk mask. Relabel 3x L_original and
               %get only concatenated disk cell.

               se=strel('disk',noise_ratio_list(m,2));
               disk_mask= imdilate(mask_3x,se);

               mask_L_original=[L_original,L_original,L_original];
               mask_cells_label=bwlabel(mask_L_original,8);

               cell_disk=unique(mask_cells_label(disk_mask==1));

               mask_cells_label(mask_cells_label~=cell_disk)=0;
               mask_cells_label(mask_cells_label==cell_disk)=1;

               Cell_without_disk=mask_cells_label-disk_mask;

               Cell_without_disk=imerode(Cell_without_disk,[1,1;1,1]);

               %Chose pixel

               PixelList = regionprops(Cell_without_disk, 'PixelList');
               PixelList = cat(1, PixelList.PixelList);
               PixelList=fliplr(PixelList);
               Ind_max=size(PixelList,1);
               Pos_rand=randi([1,Ind_max],1);

               Pixel_rand=PixelList(Pos_rand,:);

               if Pixel_rand(2)>2*W
                    Pixel_rand(2)=Pixel_rand(2)-2*W;
               else
                   if Pixel_rand(2)>W
                        Pixel_rand(2)=Pixel_rand(2)-W;
                   end
               end


               seeds_noise=[seeds_noise;Pixel_rand];         



            end

            seeds_noise=[[1:100]',seeds_noise];

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            %% 	CYLINDER VORONOI NOISE GENERATION %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            mask=zeros(H,W);

            for k=1:size(seeds_noise,1)
                mask(seeds_noise(k,2),seeds_noise(k,3))=1;
            end

            % Triplicate mask to adapt to a cylindrical Voronoi

            mask_x3=[mask,mask,mask];

            D_x3 = bwdist(mask_x3);        % Apply transform of distance
            DL_x3 = watershed(D_x3);        % Split in regions closer to seed
            bgm_x3 = DL_x3 == 0;            % Cells = 0 , outline = 1.

            Voronoi_x3=bgm_x3;


            %%  LABELLING CORRECTLY -> CELLS OF LATERAL EDGES Label

            Voronoi_x2=Voronoi_x3(:,W+1:end);

            L_original_x2=bwlabel(1-Voronoi_x2,8);

            % Get sorted labels right border
            right_border_cells=L_original_x2(:,W+1);

            [cel_1,idx_1]=unique(right_border_cells);
            Rig=[cel_1(2:end),idx_1(2:end)];
            Cells_right_sorted=sortrows(Rig,2);
            Cells_right=Cells_right_sorted(:,1);

            %Get sorted labels left border
            left_border_cells=L_original_x2(:,1);

            [cel_2,idx_2]=unique(left_border_cells);
            Lef=[cel_2(2:end),idx_2(2:end)];
            Cells_left_sorted=sortrows(Lef,2);
            Cells_left=Cells_left_sorted(:,1);

            %Asigg 0 to right cells in L_original because could generate
            %errors, due to the reassignation. So, we need relabel L_original
            %to get a really sorted labelled image.

            aux=L_original_x2(1:H,1:W);

            for k=1:length(Cells_right)
                aux(aux==Cells_right(k))=0;
            end

            L_noise=bwlabel(aux);


            %Label cells of right border with left border label

            for f=1:length(Cells_left)
                L_noise(L_original_x2(1:H,1:W)==Cells_right(f))=Cells_left(f);
            end


            %Relabel with L_original labels

            L_original_noise=L_noise;

            for cell=1:size(seeds_noise,1)

                L_original_noise(L_noise==L_noise(seeds_noise(cell,2),seeds_noise(cell,3)))=seeds_noise(cell,1);

            end

            %Border cells noise

            border_cells_noise=unique(L_original_noise(:,1));


            %% Valid and no valid cells

            mask=zeros(H,W);
            mask(1,:)=1;
            mask(H,:)=1;
            mask=L_original_noise.*mask;
            no_valid_cells_noise=unique(mask);
            no_valid_cells_noise=no_valid_cells_noise(2:end);
            valid_cells_noise=setxor(1:100,no_valid_cells_noise);



            %% Saving

            FOLDER_1='..\Images\Photos\Inner cylindrical voronoi noise\Outside ratio';
            FOLDER_2='..\Images\Data\Inner cylindrical voronoi noise\Outside ratio';

            NAME=['Image_',num2str(i),'_Diagram_',num2str(j),'_Vonoroi_noise'];

            save([FOLDER_2 '\' NAME '.mat'],'L_original_noise','seeds_noise','border_cells_noise','no_valid_cells_noise','noise_ratio_list')

            imwrite(L_original_noise, (strcat(FOLDER_1,'\',NAME,'.png')))

        

end