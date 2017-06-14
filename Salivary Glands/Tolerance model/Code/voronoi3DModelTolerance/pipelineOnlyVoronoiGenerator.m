%%cylindricalVoronoiGenerationPipeline

N_images=20;
N_frames=20;
H=1024;
W=512;
n_seeds=50;
distanceBetwSeeds=5;



addpath lib_VoronoiGeneration


Folder2save=['512x1024_' num2str(n_seeds) 'seeds'];
FOLDER1='D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\';
    
parfor i=1:N_images
        %Generate random seeds
        [seeds] = Chose_seeds_positions(1,H,W,n_seeds,distanceBetwSeeds,i);
        seeds_values_before=0;

        for j=1:N_frames
            %External voronoi pattern
            [seeds,seeds_values_before,L_original,border_cells,valid_cells,pathToSaveData] = Voronoi_salivary_gland_generator(i,j,H,W,seeds,seeds_values_before,Folder2save);
        end
        
        ['Image ' num2str(i) ' completed']

end
