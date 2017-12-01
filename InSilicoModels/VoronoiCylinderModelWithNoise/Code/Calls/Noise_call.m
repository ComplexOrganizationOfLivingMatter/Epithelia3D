%% Voronoi noise calls
clear all
close all

Images=5;
Iteration=20;

cd .. 

for i=1:Images
    parfor j=1:Iteration
        
        Voronoi_noise_inner_ratio_salivary_gland_generator(i,j);
        Voronoi_noise_out_of_inner_ratio_salivary_gland_generator(i,j);
        Voronoi_noise_whole_cell_salivary_gland_generator(i,j);

    end
end

cd Calls