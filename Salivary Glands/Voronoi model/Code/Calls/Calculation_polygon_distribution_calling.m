
%Calculate polygon distribution call
clear all
close all

layers={'Inside ratio','Outside ratio','Whole cell'};

N_images=5;
N_frames=20;

cd ..

for i=1:N_images
    parfor j=1:N_frames
        for k=1:length(layers)
            Calculate_neighbors_polygon_distribution(layers{1,k},i,j);
        end
    end
end
