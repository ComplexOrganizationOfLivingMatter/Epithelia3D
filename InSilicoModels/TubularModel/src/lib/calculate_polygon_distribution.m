function [polygon_distribution]=calculate_polygon_distribution( sides_cells, valid_cells )
 
    %We discriminate for valid cells
    sides_valid_cells=sides_cells(valid_cells);
    
  
    %Calculate percentages
    three=sum(sides_valid_cells==3)/length(sides_valid_cells);
    four=sum(sides_valid_cells==4)/length(sides_valid_cells);
    five=sum(sides_valid_cells==5)/length(sides_valid_cells);
    six=sum(sides_valid_cells==6)/length(sides_valid_cells);
    seven=sum(sides_valid_cells==7)/length(sides_valid_cells);
    eight=sum(sides_valid_cells==8)/length(sides_valid_cells);
    nine=sum(sides_valid_cells==9)/length(sides_valid_cells);
    ten=sum(sides_valid_cells==10)/length(sides_valid_cells);
    eleven=sum(sides_valid_cells==11)/length(sides_valid_cells);
    twelve=sum(sides_valid_cells==12)/length(sides_valid_cells);
    thirteen=sum(sides_valid_cells==13)/length(sides_valid_cells);
    fourteen=sum(sides_valid_cells==14)/length(sides_valid_cells);
    fifteen=sum(sides_valid_cells==15)/length(sides_valid_cells);
    sixteen=sum(sides_valid_cells==16)/length(sides_valid_cells);
    seventeen=sum(sides_valid_cells==17)/length(sides_valid_cells);
    eighteen=sum(sides_valid_cells==18)/length(sides_valid_cells);
    nineteen=sum(sides_valid_cells==19)/length(sides_valid_cells);
    twenty=sum(sides_valid_cells==20)/length(sides_valid_cells);
    twentyone=sum(sides_valid_cells==21)/length(sides_valid_cells);
    twentytwo=sum(sides_valid_cells==22)/length(sides_valid_cells);
    twentythree=sum(sides_valid_cells==23)/length(sides_valid_cells);
    
    % Clasify in a variable type cell
    polygon_distribution={};
    
    polygon_distribution{1,1}='three';polygon_distribution{1,2}='four';polygon_distribution{1,3}='five';
    polygon_distribution{1,4}='six';polygon_distribution{1,5}='seven';polygon_distribution{1,6}='eight';
    polygon_distribution{1,7}='nine';polygon_distribution{1,8}='ten';polygon_distribution{1,9}='eleven';
    polygon_distribution{1,10}='twelve';polygon_distribution{1,11}='thirteen';polygon_distribution{1,12}='fourteen';
    polygon_distribution{1,13}='fifteen';polygon_distribution{1,14}='sixteen';polygon_distribution{1,15}='seventeen';
    polygon_distribution{1,16}='eighteen';polygon_distribution{1,17}='nineteen';polygon_distribution{1,18}='twenty';
    polygon_distribution{1,19}='twenty-one';polygon_distribution{1,20}='twenty-two';polygon_distribution{1,21}='twenty-three';
    
    polygon_distribution{2,1}=three;polygon_distribution{2,2}=four;polygon_distribution{2,3}=five;
    polygon_distribution{2,4}=six;polygon_distribution{2,5}=seven;polygon_distribution{2,6}=eight;
    polygon_distribution{2,7}=nine;polygon_distribution{2,8}=ten;polygon_distribution{2,9}=eleven;
    polygon_distribution{2,10}=twelve;polygon_distribution{2,11}=thirteen;polygon_distribution{2,12}=fourteen;
    polygon_distribution{2,13}=fifteen;polygon_distribution{2,14}=sixteen;polygon_distribution{2,15}=seventeen;
    polygon_distribution{2,16}=eighteen;polygon_distribution{2,17}=nineteen;polygon_distribution{2,18}=twenty;
    polygon_distribution{2,19}=twentyone;polygon_distribution{2,20}=twentytwo;polygon_distribution{2,21}=twentythree;
       
end

