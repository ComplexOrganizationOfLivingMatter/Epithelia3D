%This file has the function of calculate the neighbors for each cell in
%every image

function Calculate_neighbors_polygon_distribution(inner_layer,image,frame)

    %load File inner and outside layer of Voronoi model
    FOLDER_1='..\Images\Data\External cylindrical voronoi'; 
    File_1=['Image_',num2str(image),'_Diagram_',num2str(frame),'_Vonoroi_out.mat'];
    load([FOLDER_1,'\',File_1],'L_original');
    Img_1=L_original;

    FOLDER_2=['..\Images\Data\Inner cylindrical voronoi noise\' inner_layer];
    File_2=['Image_',num2str(image),'_Diagram_',num2str(frame),'_Vonoroi_noise.mat'];
    load([FOLDER_2,'\',File_2],'L_original_noise');
    Img_2=L_original_noise;
    


    %% Generate neighbours
    ratio=4;
    se = strel('disk',ratio);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%- Out Layer -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cells_1=sort(unique(Img_1));
    cells_1=cells_1(2:end);                  %% Deleting cell 0 from range
            
    for cell=1 : length(cells_1)
        BW_1 = bwperim(Img_1==cell);
        [pi,pj]=find(BW_1==1);
        
        BW_dilate_1=imdilate(BW_1,se);
        pixels_neighs_1=find(BW_dilate_1==1);
        neighs_1=unique(Img_1(pixels_neighs_1));
        neighs_real_1{cell}=neighs_1(find(neighs_1 ~= 0 & neighs_1 ~= cell));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%- Inner Layer -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        BW_2 = bwperim(Img_2==cell);
        [pi,pj]=find(BW_2==1);
        
        BW_dilate_2=imdilate(BW_2,se);
        pixels_neighs_2=find(BW_dilate_2==1);
        neighs_2=unique(Img_2(pixels_neighs_2));
        neighs_real_2{cell}=neighs_2(find(neighs_2 ~= 0 & neighs_2 ~= cell));
        
%%%%%%%%%%%%%%%%%%%%%%%%%- Unify neighbors -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        neighs_real{cell}=union(neighs_real_1{cell},neighs_real_2{cell});
        sides_cells(cell)=length(neighs_real{1,cell});
    end
    
    %% Calculate polygon distribution
    
    
    %Load valid cells
    
    load (['..\Images\Data\Valid cells\' inner_layer '\Valid_cells_image_' num2str(image)],'general_valid_cells')
    
    sides_valid_cells=sides_cells(general_valid_cells);
    
    %Calculate percentages
    triangles=sum(sides_valid_cells==3)/length(sides_valid_cells);
    squares=sum(sides_valid_cells==4)/length(sides_valid_cells);
    pentagons=sum(sides_valid_cells==5)/length(sides_valid_cells);
    hexagons=sum(sides_valid_cells==6)/length(sides_valid_cells);
    heptagons=sum(sides_valid_cells==7)/length(sides_valid_cells);
    octogons=sum(sides_valid_cells==8)/length(sides_valid_cells);
    nonagons=sum(sides_valid_cells==9)/length(sides_valid_cells);
    decagons=sum(sides_valid_cells==10)/length(sides_valid_cells);

    
    
    % Clasify in a variable type cell
    polygon_distribution={};
    
    polygon_distribution{1,1}='triangles';polygon_distribution{1,2}='squares';polygon_distribution{1,3}='pentagons';
    polygon_distribution{1,4}='hexagons';polygon_distribution{1,5}='heptagons';polygon_distribution{1,6}='octogons';
    polygon_distribution{1,7}='nonagons';polygon_distribution{1,8}='decagons';

    polygon_distribution{2,1}=triangles;polygon_distribution{2,2}=squares;polygon_distribution{2,3}=pentagons;
    polygon_distribution{2,4}=hexagons;polygon_distribution{2,5}=heptagons;polygon_distribution{2,6}=octogons;
    polygon_distribution{2,7}=nonagons;polygon_distribution{2,8}=decagons;

    
       
    %% Save data
    
    string=['..\Images\Data\Polygon_distribution\' inner_layer '\Pol_distribution_Image_' num2str(image) '_Diagram_' num2str(frame),'.mat'];
    
    save(string,'neighs_real','sides_cells','polygon_distribution')
end