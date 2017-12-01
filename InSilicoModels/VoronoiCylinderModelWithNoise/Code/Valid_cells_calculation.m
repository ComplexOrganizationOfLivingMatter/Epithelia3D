%%valid cells calculation

%A valid cell is valid in all frames and in each layer (out and in)

Images=5;
N_iterations=20;

for i=1:Images
   
    general_external_no_valid_cells=[];
    general_no_valid_noise_inner_ratio_cells=[];
    general_no_valid_noise_outside_ratio_cells=[];
    general_no_valid_noise_whole_cells=[];

    for j=2:N_iterations
        
        no_valid_external_layer_cells=load(['..\Images\Data\External cylindrical voronoi\Image_' num2str(i) '_Diagram_' num2str(j) '_Vonoroi_out.mat'],'no_valid_cells');
        no_valid_noise_inner_ratio_cells=load(['..\Images\Data\Inner cylindrical voronoi noise\Inside ratio\Image_' num2str(i) '_Diagram_' num2str(j) '_Vonoroi_noise.mat'],'no_valid_cells_noise');
        no_valid_noise_outside_ratio_cells=load(['..\Images\Data\Inner cylindrical voronoi noise\Outside ratio\Image_' num2str(i) '_Diagram_' num2str(j) '_Vonoroi_noise.mat'],'no_valid_cells_noise');
        no_valid_noise_whole_cells=load(['..\Images\Data\Inner cylindrical voronoi noise\Whole cell\Image_' num2str(i) '_Diagram_' num2str(j) '_Vonoroi_noise.mat'],'no_valid_cells_noise');
             
        no_valid_external_layer_cells=struct2array(no_valid_external_layer_cells);
        no_valid_noise_inner_ratio_cells=struct2array(no_valid_noise_inner_ratio_cells);
        no_valid_noise_outside_ratio_cells=struct2array(no_valid_noise_outside_ratio_cells);
        no_valid_noise_whole_cells=struct2array(no_valid_noise_whole_cells);
        
        
        general_external_no_valid_cells=unique([general_external_no_valid_cells,no_valid_external_layer_cells']);
        general_no_valid_noise_inner_ratio_cells=unique([general_no_valid_noise_inner_ratio_cells,no_valid_noise_inner_ratio_cells']);
        general_no_valid_noise_outside_ratio_cells=unique([general_no_valid_noise_outside_ratio_cells,no_valid_noise_outside_ratio_cells']);
        general_no_valid_noise_whole_cells=unique([general_no_valid_noise_whole_cells,no_valid_noise_whole_cells']);
        
    end
    
    general_no_valid_noise_inner_ratio_cells=unique(union(general_no_valid_noise_inner_ratio_cells,general_external_no_valid_cells));
    general_no_valid_noise_outside_ratio_cells=unique(union(general_no_valid_noise_outside_ratio_cells,general_external_no_valid_cells));
    general_no_valid_noise_whole_cells=unique(union(general_no_valid_noise_whole_cells,general_external_no_valid_cells));
    
    
    general_valid_noise_inner_ratio_cells=setxor(1:100,general_no_valid_noise_inner_ratio_cells);
    general_valid_noise_outside_ratio_cells=setxor(1:100,general_no_valid_noise_outside_ratio_cells);
    general_valid_noise_whole_cells=setxor(1:100,general_no_valid_noise_whole_cells);
    
    
    general_valid_cells=general_valid_noise_inner_ratio_cells;
    general_no_valid_cells=general_no_valid_noise_inner_ratio_cells;
    save(['..\Images\Data\Valid cells\Inside ratio\Valid_cells_image_' num2str(i) '.mat'],'general_valid_cells','general_no_valid_cells')
    
    general_valid_cells=general_valid_noise_outside_ratio_cells;
    general_no_valid_cells=general_no_valid_noise_outside_ratio_cells;
    save(['..\Images\Data\Valid cells\Outside ratio\Valid_cells_image_' num2str(i) '.mat'],'general_valid_cells','general_no_valid_cells')
    
    general_valid_cells=general_valid_noise_whole_cells;
    general_no_valid_cells=general_no_valid_noise_whole_cells;
    save(['..\Images\Data\Valid cells\Whole cell\Valid_cells_image_' num2str(i) '.mat'],'general_valid_cells','general_no_valid_cells')
    
    
end