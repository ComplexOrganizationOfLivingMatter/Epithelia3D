%%cylindricalVoronoiGenerationPipeline

N_images=20;
N_frames=20;
H=1024;
W=512;
n_seeds=400;
distanceBetwSeeds=5;
setOfAngles=0:1.25:30;%set of angles to calculated tolerance
namesStructures={'WT_Gland1','WT_Gland2','WT_Gland3','WT_Gland4','WT_Gland5','WT_Gland6','WT_Gland7','WT_Gland8','E-cadhi_Gland1','E-cadhi_Gland2','E-cadhi_Gland3','E-cadhi_Gland4','CultureEp_n0','CultureEp_n1','CultureEp_n2'};
listOfRatios=[2.17,2.07,2.48,2.08,2.15,1.93,2.38,2.56,2.18,2.1,2.09,2.3,2.03,1.85,1.13];
listOfTransitionsProportion=[1.8889,2,1.25,2.0769,1.9091,2,1.3333,1.9167,1.1875,1,0.0769,0.5,1,0.4286,0.25];
listOfCurvatures=[0.1867,0.2229,0.1343,0.2579,0.2105,0.175,0.0999,0.0984,0.1652,0.1300,0.2819,0.1651,0.1873,0.2202,0.3261];


addpath lib_VoronoiGeneration
addpath lib_delaunayTolerance
addpath lib_delaunayTolerance\lib

FOLDER='D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model\External cylindrical voronoi';
FOLDER1='D:\Pedro\Epithelia3D\Salivary Glands\Tolerance model\Data\3D Voronoi model';

for k=1:length(namesStructures)
    
    for i=1:N_images
        %Generate random seeds
        %[seeds] = Chose_seeds_positions(1,H,W,n_seeds,distanceBetwSeeds,i);
        load(['..\Seeds\Salivary_Gland_outside_' num2str(H) 'x' num2str(W) '_' num2str(n_seeds) '_seeds_' num2str(i) '.mat'],'seeds')
        seeds_values_before=0;

        for j=1:N_frames

            %%Paths
            Name2Load=['Image_',num2str(i),'_Diagram_',num2str(j),'_Vonoroi_out'];
            Name2Sav=['Image_',num2str(i),'_Diagram_',num2str(j),'_' namesStructures{k}];
            if exist([FOLDER1 '\' namesStructures{k}],'dir')==0
                mkdir([FOLDER1 '\' namesStructures{k}]);
            end
            pathToLoadData=[FOLDER '\' Name2Load '.mat'];
            pathToSaveData=[FOLDER1 '\' namesStructures{k} '\' Name2Sav '.mat'];
            
            %%Ratios radiusCirc - height , transitionsProportion &
            %%curvature
            ratioRadiusAreaCir_Heigh=listOfRatios(k);
            transitionsProportion=listOfTransitionsProportion(k);
            curvature= listOfCurvatures(k);
            
            %External voronoi pattern
            %[seeds,seeds_values_before,L_original,border_cells,valid_cells,pathToSaveData] = Voronoi_salivary_gland_generator(i,j,H,W,seeds,seeds_values_before);
            load(pathToLoadData)
            %calculate tolerance, from voronoi cylindrical model
            %[cellTolerances, trianTolerancesVoronoi] = triangulationDelaunyGettingTolerance( seeds_values_before, border_cells, L_original,pathToSaveData);

            %save(pathToSaveData, 'border_cells', 'cellTolerances', 'imaginaryCircRatio', 'L_original', 'new_seeds', 'new_seeds_values', 'no_valid_cells', 'seeds', 'seeds_values_before', 'trianTolerances', 'tripletsData', 'valid_cells')

            %calculate  TAU using listOfHeighForModel and a set of angles
            CalculateProportionBrokenTolerance(L_original,valid_cells,pathToSaveData,setOfAngles,cellTolerances,ratioRadiusAreaCir_Heigh,transitionsProportion,curvature);
        end

        ['Completed: ' namesStructures{k} '- Image_' num2str(i)] 
     end

end
