function [new_cell,L_img_previous,mask] = data_cursor_mode(fig,new_cell,L_img_previous,mask,H,W)
%% Data cursor mode to chose cells in screen to be modified of label

           

           fprintf('Click on bad labelled cell (right gland) and pulse enter \n')

           [x1,y1]=getpts(fig);   
           x1=round(x1);y1=round(y1);
           
           if x1(end) > W && y1(end) < H
           
               fprintf('You have chosen cell number: %d \n',mask(y1(end),x1(end)-H))

               fprintf('Click on good labelled cell (left gland) and pulse enter \n Black part or right gland are considered a new cell \n')

               [x2,y2]=getpts(fig);   
               x2=round(x2);y2=round(y2);

               if y2(end)< H && x2(end) < W 

                   if   L_img_previous(y2(end),x2(end))~=0  
                        fprintf('Change %d to %d \n',mask(y1(end),x1(end)-H),L_img_previous(y2(end),x2(end)))
                        are_sure=input('if are you sure insert 1: ');
                        pause;
                        if are_sure==1
                            mask_L=bwlabel(mask);
                            mask(mask_L==mask_L(y1(end),x1(end)-H))=L_img_previous(y2(end),x2(end));
                        end

                   else
                        cells_unique=unique(mask);
                        cells_unique(cells_unique>999)=[];
                        cell_mx=max(max(cells_unique));

                        if new_cell<=cell_mx
                            new_cell=cell_mx+1;
                        end

                        fprintf('%d is the new cell %d\n',mask(y1(end),x1(end)-H),new_cell)
                        is_new=input('if is a new cell insert 1: ');
                        pause;
                        if is_new==1
                            mask_L=bwlabel(mask);
                            mask(mask_L==mask_L(y1(end),x1(end)-H))=new_cell;
                            new_cell=new_cell+1;

                        end

                   end

               else

                    cells_unique=unique(mask);
                    cells_unique(cells_unique>999)=[];
                    cell_mx=max(max(cells_unique));

                    if new_cell<=cell_mx
                        new_cell=cell_mx+1;
                    end

                    fprintf('%d is the new cell %d\n',mask(y1(end),x1(end)-H),new_cell)
                    is_new=input('if is a new cell insert 1: ');
                    pause;
                    if is_new==1
                        mask_L=bwlabel(mask);
                        mask(mask_L==mask_L(y1(end),x1(end)-H))=new_cell;
                        new_cell=new_cell+1;

                    end


               end
           end

    
end

