%This file has the function of calculate the neighbors for each cell in
%every image

function Calculate_neighbors_polygon_distribution(folder,name)

    %load sequence of labelled images
    
    load(['..\Segmented images data\' folder '\' name '\Label_sequence.mat'],'Seq_Img_L');

    ratio=4;
    se = strel('disk',ratio);
    
    for j=1:size(Seq_Img_L,1)
        
        if j==1
            cell_max=max(max(Seq_Img_L{j,1}));
        else
            cell_max=max([cell_max,max(max(Seq_Img_L{j,1}))]);
        end
    end
    
    
   neighs_real_final={};
    for i=1:size(Seq_Img_L,1)
    
        Img_L=Seq_Img_L{i,1};
        
        %% Generate neighbours
        neighs_real={};
        cells=sort(unique(Img_L));
        cells=cells(2:end);                  %% Deleting cell 0 from range
            
        for cel=1 : cell_max
            BW = bwperim(Img_L==cel);
            [pi,pj]=find(BW==1);

            BW_dilate=imdilate(BW,se);
            pixels_neighs=find(BW_dilate==1);
            neighs=unique(Img_L(pixels_neighs));
            neighs_real{cel}=neighs(find(neighs ~= 0 & neighs ~= cel));
            
            %%%%%%%%%%%%%%%%%%%%%- Unify neighbors -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if i>1
                neighs_real_final{cel}=union(neighs_real{cel},neighs_real_final{cel});
            else
                neighs_real_final{cel}=neighs_real{cel};
            end
            sides_cells(cel)=length(neighs_real_final{1,cel});
            
        end
   
        
    end
    
    %This loop has the proposal of add neighbours to cells who are
    %neighbours of disappeared or emerged cells, no detected in case before 
    
    neighs_real_final_2=neighs_real_final;
    for i=1:size(Seq_Img_L,1)
    
        Img_L=Seq_Img_L{i,1};
        if i>1
            Img_L_before=Seq_Img_L{i-1,1};
            cells_before=unique(Img_L_before);
            cells=unique(Img_L);
            dudose_cells=setxor(cells_before,cells);
    
            emerged_cells=dudose_cells(find(ismember(dudose_cells,Img_L)));
            dissapered_cells=dudose_cells(find(ismember(dudose_cells,Img_L_before)));
            
            if isempty(emerged_cells)==0 && isempty(dissapered_cells)==0
               for j=1:length(emerged_cells)
                    
                    %finding new neigh
                    overlapped_cells=unique(Img_L_before(Img_L==emerged_cells(j)));
                    new_neighs=dissapered_cells(find(ismember(dissapered_cells,overlapped_cells)));
                    
                    %adding neigh
                    if isempty(new_neighs)==0
                        
                            for k=1:length(new_neighs)
                                %%Overlapped cell should share 500 pixels
                                %%or to be at least the
                                %%third part of the disappeared cell
                                %%to be considered neighbours
                                pixels_presence=sum(new_neighs(k)==Img_L_before(Img_L==emerged_cells(j)));
                                if pixels_presence>500 || pixels_presence > sum(sum((Img_L_before==new_neighs(k))))/3
                                    neighs_real_final_2{1,emerged_cells(j)}=[neighs_real_final_2{1,emerged_cells(j)};new_neighs(k)];
                                    neighs_real_final_2{1,new_neighs(k)}=[neighs_real_final_2{1,new_neighs(k)};emerged_cells(j)];
                                end
                            end
                    end
               end
            end
            
        end
        
    end
    
    
    for cel=1 : cell_max
        sides_cells_2(cel)=length(neighs_real_final_2{1,cel});
    end
        
        
    
   
    %% Calculate polygon distribution
    
    
    %Load no valid cells
    
    load (['..\Segmented images data\' folder '\' name '\No_valid_cells.mat'])
    
    %I have changed sides_cells with sides_cells_2 (overlapping review)
    sides_valid_cells=sides_cells_2;
    sides_valid_cells(no_valid_cells)=[];
    sides_valid_cells=sides_valid_cells(sides_valid_cells~=0);

    
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
    
    string=['..\Segmented images data\' folder '\' name '\Polygon_distribution.mat'];
    
    save(string,'neighs_real_final','neighs_real_final_2','sides_cells','sides_cells_2','sides_valid_cells','no_valid_cells','polygon_distribution')
end
 