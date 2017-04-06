function calculate_max_area_per_cell( folder,name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    load(['..\Segmented images data\' folder '\' name '\Label_sequence.mat'],'Seq_Img_L');

    cell_max=max(cell2mat(cellfun(@(x) max(max(x)),Seq_Img_L,'UniformOutput', false)));
    %Inicialize area of cell table
    areas_cells=zeros(cell_max,size(Seq_Img_L,1));    

    for i=1:size(Seq_Img_L,1)
        
        area=regionprops(Seq_Img_L{i},'Area');
        area=cat(1,area.Area);
        for j=1:length(area)
            areas_cells(j,i)=area(j);
        end
               
    end
    
    [area,frame]=max(areas_cells');
    
    area_max_frame=[area',frame'];

    string=['..\Segmented images data\' folder '\' name '\Area_max_cells.mat'];
    
    save(string,'area_max_frame','areas_cells')

end

