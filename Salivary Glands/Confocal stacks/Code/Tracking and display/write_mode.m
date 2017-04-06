function [new_cell,L_img_previous,mask] = write_mode(fig,new_cell,L_img_previous,mask,H,W)
%% Data cursor mode to chose cells in screen to be modified of label

           

           fprintf('Click on bad labelled cell (right gland) and pulse enter \n')

           [x1,y1]=getpts(fig);   
           x1=round(x1);y1=round(y1);

           

                    
           while  x1(end) < H || y1(end) > W
               [x1,y1]=getpts(fig);   
               x1=round(x1);y1=round(y1);
                
           end
           
           fprintf('You have chosen cell number: %d \n',mask(y1(end),x1(end)-H))
           
            label=input('Write the correct numeric label (0 to New cell): ');
            if label==0
               label=new_cell;
               new_cell=new_cell+1;
            end
            
            fprintf('Change %d to %d \n',mask(y1(end),x1(end)-H),label)

            are_sure=input('if are you sure insert 1: ');
            pause;
            
            if are_sure==1
                mask_L=bwlabel(mask);
                mask(mask_L==mask_L(y1(end),x1(end)-H))=label;
            end


            cells_unique=unique(mask);
            cells_unique(cells_unique>999)=[];
            cell_mx=max(max(cells_unique));

            if new_cell<=cell_mx
                new_cell=cell_mx+1;
            end


    
end