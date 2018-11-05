function calculate_CellularFeatures(apical3dInfo,basal3dInfo,apicalLayer,basalLayer,labelledImage,selpath)
%CALCULATE_CELLULARFEATURES Summary of this function goes here
%   Detailed explanation goes here
%%  Calculate number of neighbours of each cell
    number_neighbours=table(cellfun(@length,(apical3dInfo.neighbourhood)),cellfun(@length,(basal3dInfo.neighbourhood)));
    
%%  Calculate area cells
    apical_area_cells=cell2mat(struct2cell(regionprops(apicalLayer,'Area'))).';
    basal_area_cells=cell2mat(struct2cell(regionprops(basalLayer,'Area'))).';
 
%%  Calculate volume cells
    volume_cells=table2array(regionprops3(labelledImage,'Volume'));
    
%%  Determine if a cell is a scutoid or not
    scutoids_cells={};
    for NumCells=1:length(basal3dInfo.neighbourhood)
        if number_neighbours.Var1(NumCells,1) == number_neighbours.Var2(NumCells,1)
        scutoids_cells{NumCells,1}=1;
        else 
        scutoids_cells{NumCells,1}=0;
        end
    end
    
%%  Export to a excel file
ID_cells=[1:length(basal3dInfo.neighbourhood)].';
CellularFeatures=table(ID_cells,number_neighbours.Var1,number_neighbours.Var2,scutoids_cells,apical_area_cells,basal_area_cells,volume_cells);
CellularFeatures.Properties.VariableNames = {'ID_Cell','Apical_sides','Basal_sides','Scutoids','Apical_area','Basal_area','Volume'};
writetable(CellularFeatures,fullfile(selpath,'Results', 'cellular_features_LimeSeg3DSegmentation.xls'), 'Range','B2');
