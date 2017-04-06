function [possible_cells,unsure_cells,sure_cells,new_cell] = compare_areas(L_img,Seq_Img_L,n,n_min,new_cell)

        L_img_previous=Seq_Img_L{n-n_min,1};

        %defining parameters
        max_cell=max(max(L_img));
        possible_cells={};
        unsure_cells=[];
        sure_cells=[];
        n_sures=1;
        n_dudes=1;


        for n_cell=1:max_cell
            
            %Calculate overlapping percentaje
            overlaped_cells=unique(L_img_previous(L_img==n_cell));
            overlaped_cells(overlaped_cells==0)=[];
             
            %if cell don't overlap any cell (only background), we assign
            %the same value
            if isempty(overlaped_cells)==1
                overlaped_cells=new_cell;
                new_cell=new_cell+1;
                L_percentajes=100;
                
            %else we calculate the most probably cell comparing areas
            else
                
            
                L_percentajes=[];
                for j=1:length(overlaped_cells)
                    perc=sum(L_img_previous(L_img==n_cell)==overlaped_cells(j))/(length(L_img_previous(L_img==n_cell)==overlaped_cells(j))-sum(L_img_previous(L_img==n_cell)==0));
                    L_percentajes(j)=perc;
                end

                percentaje_overlap{n_cell,1}=n_cell;
                percentaje_overlap{n_cell,2}=overlaped_cells';
                percentaje_overlap{n_cell,3}=L_percentajes;
            end
            
                           

            [P,I]=sort(L_percentajes','descend');

            %If overlapping is higher than 70%, we add this label as a
            %possible cell.

            if P(1)>= 0.7
                possible_cells{n_cell,1}=n_cell;
                possible_cells{n_cell,2}=overlaped_cells(I(1));

                sure_cells(n_sures)=n_cell;
                n_sures=n_sures+1;

            else
                possible_cells{n_cell,1}=n_cell;
                possible_cells{n_cell,2}=overlaped_cells';

                unsure_cells(n_dudes)=n_cell;
                n_dudes=n_dudes+1;
            end



        end


end


