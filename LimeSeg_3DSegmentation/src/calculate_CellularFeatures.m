function [CellularFeatures] = calculate_CellularFeatures(neighbours_data,apical3dInfo,basal3dInfo,apicalLayer,basalLayer,labelledImage,noValidCells,selpath)
%CALCULATE_CELLULARFEATURES Summary of this function goes here
%   Detailed explanation goes here
%%  Calculate number of neighbours of each cell
number_neighbours=table(cellfun(@length,(apical3dInfo.neighbourhood)),cellfun(@length,(basal3dInfo.neighbourhood)));
total_neighbours3D=calculateNeighbours3D(labelledImage);
total_neighbours3D=cellfun(@(x) length(x), total_neighbours3D.neighbourhood, 'UniformOutput',false);
apicobasal_neighbours=cellfun(@(x,y) length(unique(vertcat(x,y))), apical3dInfo.neighbourhood, basal3dInfo.neighbourhood, 'UniformOutput',false);

%%  Calculate area cells
apical_area_cells=cell2mat(struct2cell(regionprops(apicalLayer,'Area'))).';
basal_area_cells=cell2mat(struct2cell(regionprops(basalLayer,'Area'))).';

%%  Calculate volume cells
volume_cells=table2array(regionprops3(labelledImage,'Volume'));

%%  Determine if a cell is a scutoid or not
scutoids_cells={};
for NumCells=1:length(basal3dInfo.neighbourhood)
    if isequal(cell2mat(neighbours_data.Apical(NumCells,1)),cell2mat(neighbours_data.Basal(NumCells,1)))
        scutoids_cells{NumCells,1}=0;
    else
        scutoids_cells{NumCells,1}=1;
    end
end

   



%%  Export to a excel file
ID_cells=(1:length(basal3dInfo.neighbourhood)).';

 if isequal(total_neighbours3D,apicobasal_neighbours)==0
        
        total_neighbours3D2=calculateNeighbours3D(labelledImage);
        apicobasal_neighbours2=cellfun(@(x,y)(unique(vertcat(x,y))), apical3dInfo.neighbourhood, basal3dInfo.neighbourhood, 'UniformOutput',false);
        pos=cellfun(@isequal, total_neighbours3D2.neighbourhood,apicobasal_neighbours2);
        
        pos(noValidCells)=[];
        
        ids=ID_cells(pos==0);
        
        
        
        IDsStrings=string(num2str(ids));
        IDsStrings=strjoin(IDsStrings,', ');
        
        msg1="Cells with IDs ";
        msg2=strcat(msg1,IDsStrings);
     
        msg3="  could be wrong due to Total_neighbours is different from Apicobasal_neighours";
        msg=strcat(msg2,msg3);
    
        warning(msg);
       
    
  end

CellularFeatures=table(ID_cells,number_neighbours.Var1,number_neighbours.Var2,total_neighbours3D,apicobasal_neighbours,scutoids_cells,apical_area_cells,basal_area_cells,volume_cells);
CellularFeatures.Properties.VariableNames = {'ID_Cell','Apical_sides','Basal_sides','Total_neighbours','Apicobasal_neighbours','Scutoids','Apical_area','Basal_area','Volume'};
CellularFeatures(noValidCells,:)=[];
writetable(CellularFeatures,fullfile(selpath,'Results', 'cellular_features_LimeSeg3DSegmentation.xls'), 'Range','B2');
