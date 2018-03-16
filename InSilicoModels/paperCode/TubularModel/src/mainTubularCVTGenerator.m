function mainTubularCVTGenerator(N_images,N_frames,H,W,nSeeds,distanceBetwSeeds);

        Folder2save=[num2str(W) 'x' num2str(H) '_' num2str(nSeeds) 'seeds'];
        FolderPath='data\tubularCVT\';

        parfor indexImage=1:N_images
                %Generate random seeds
                [seeds] = chooseSeedsPositions(1,H,W,nSeeds,distanceBetwSeeds,indexImage,FolderPath);
                seeds_values_before=0;

                for j=1:N_frames
                    %External voronoi pattern
                    [seeds,seeds_values_before,L_original,border_cells,valid_cells,pathToSaveData] = tubularCVTGenerator(indexImage,j,H,W,seeds,seeds_values_before,Folder2save,FolderPath);
                end

                ['Image ' num2str(indexImage) ' _ ' num2str(nSeeds) 'seeds _ completed ']

        end

end