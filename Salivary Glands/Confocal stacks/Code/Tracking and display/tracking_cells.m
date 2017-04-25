function tracking_cells(folder,name,n_frame)
%This is the main code to follow cells in salivary gland. This gland has a
%shape as a cylinder or elongated donnut. So we need track these cells
%along Z axe.

%Getting skeleton photo names and the minimun index number to begin tracking from that.

Img_list=dir(['..\..\Segmented images\' folder '\' name '\Skeleton_images\Skel*.tif']);


    %This loop is only to match the nomenclature
    L_num=[];
    for i=1:numel(Img_list)
        names_list{i}={Img_list(i).name};
        skel_name=cell2mat(names_list{i});
        L_num=[L_num,str2num(skel_name(6:end-4))];
    end
    n_min=min(L_num);n_min_2=n_min; %to avoid overlapping in compare areas
    n_max=max(L_num);
    
    %Chose between data cursor mode and insert number of labels
    selection_mode=input('d (data cursor mode) / w(write label mode):  ','s')
    

    %initialize the list of images labelled perfectly
    Seq_Img_L={};
    
    if isnumeric(n_frame)==1 && n_frame>n_min && n_frame<=n_max
        n_min_2=n_frame;
    end
    %loop to label whole gland
    for n=n_min_2:n_max %n_min

        %% load n skeleton
               
        I=imread(['..\..\Segmented images\' folder '\' name '\Skeleton_images\Skel_' num2str(n,'%02d') '.tif']);
        
        %load next skeleton to be display for comparison labels
        if n<n_max
               I_next=imread(['..\..\Segmented images\' folder '\' name '\Skeleton_images\Skel_' num2str(n+1,'%02d') '.tif']);
        end
        
        %% Labelling current and next skeletons, giving 0 value to background
        [H,W,c1]=size(I);
        [H,W,c2]=size(I_next);

        %if there are 3 channels is because tube of glad is present.
        if c1==3
           %%method to capture tube color pixels. 
           b=I(:,:,3);
           elem=unique(b);
           tube_value=min(elem(2:end));
           Img=b;
           Img(b==tube_value)=255;
        else
           Img=I;
        end
        
        if c2==3
           %%method to capture tube color pixels. 
           b2=I_next(:,:,3);
           elem2=unique(b2);
           tube_value2=min(elem2(2:end));
           Img_next=b2;
           Img_next(b2==tube_value2)=255;
        else
           Img_next=I_next;
        end

        %binary conversion
        Img=im2bw(Img);
        Img_next=im2bw(Img_next);
        %labelling
        L_img=bwlabel(1-Img,8);
        L_img(L_img==1)=0;    %background is 0
        L_img=bwlabel(L_img,8);
        L_img_next=bwlabel(1-Img_next,8);
        L_img_next(L_img_next==1)=0;    %background is 0
        L_img_next=bwlabel(L_img_next);
        
        
        %If it is not the first iteration, re-label cells in comparison with
        %labelled frame before.
        if n~=n_min
            
            %%%%%%%%%%%%%%%% COMPARE AREAS %%%%%%%%%%%%%%%%%%
            load(['..\..\Segmented images data\' folder '\' name '\Label_sequence.mat'])
            %load previous labelled image
            
            L_img_previous=Seq_Img_L{n-n_min,1};
            
            %update new_cell
            values_seq=([Seq_Img_L{:}]);values_seq=values_seq(values_seq<1000);
            new_cell=max(max(values_seq))+1;
            
            %Calling function to get compared areas in current and before frames.
            [possible_cells,unsure_cells,sure_cells,new_cell]=compare_areas(L_img,Seq_Img_L,n,n_min,new_cell);


            %Finding repeated label for a cell
            A=sort(vertcat(possible_cells{sure_cells,2}))'; 
            B1=vertcat(possible_cells{sure_cells,1})';
            B2=vertcat(possible_cells{sure_cells,2})';

            pos_rep=find(diff(A)==0);
            rep_label=A(pos_rep);
            rep_cells=[];
            for rep=1:length(rep_label)
                rep_cells=[rep_cells,B1(B2==rep_label(rep))];
            end


            %% Relabel sure and unsure cells to be displayed

            mask=zeros(H,W);
            for r=1:numel(sure_cells)
                mask(L_img==sure_cells(r))=possible_cells{sure_cells(r),2};
            end
            for r=1:numel(unsure_cells)
                mask(L_img==unsure_cells(r))=unsure_cells(r)+1000;
            end
            for r=1:numel(rep_cells)
                mask(L_img==rep_cells(r))=rep_cells(r)+2000;
            end


           %% Display images with visible labels to be modified

            exit_loop=0;

            while exit_loop~=1
                
                %% Display labels in screen

                [fig]=display_labelled_glands(L_img_previous,mask,n,n_max,H,W);
                
                
                want_modify=input('666 (change labelling mode) \n 0 (Break) \n Otherwise (Continue labelling) : ');
                switch want_modify
                    case 0
                        close all
                        break
                    case 666
                        if strcmp(selection_mode,'w')==1 || strcmp(selection_mode,'W')==1 
                            selection_mode='d';
                        else
                            selection_mode='w';
                        end
                end
                
                
                
                switch selection_mode
                                
                    case {'w','W'}
                    %% Write mode
                    [new_cell,L_img_previous,mask] = write_mode(fig,new_cell,L_img_previous,mask,H,W);
                        
                        
                    otherwise
                    %% Data cursor mode to chose cells in screen to be modified of label
                    [new_cell,L_img_previous,mask]=data_cursor_mode(fig,new_cell,L_img_previous,mask,H,W);

                end    

                close all

            end  

            L_img=mask;



    else
        %Controller new labellings
        new_cell=max(max(L_img))+1;

    end



    %save labelled image in a cell list
    Seq_Img_L{n-n_min+1,1}=L_img;

    if isdir(['..\..\Segmented images data\' folder '\' name])==0
        mkdir(['..\..\Segmented images data\' folder '\' name]);
    end


     save(['..\..\Segmented images data\' folder '\' name '\Label_sequence.mat'],'Seq_Img_L')



    end

end

