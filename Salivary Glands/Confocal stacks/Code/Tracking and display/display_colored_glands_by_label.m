%%  Display and save colored image sequence
function display_colored_glands_by_label(folder,name)

load(['..\..\Segmented images data\' folder '\' name '\Label_sequence.mat'],'Seq_Img_L')

    for i=1:size(Seq_Img_L,1)

        %% Display images with visible label
            s=regionprops(Seq_Img_L{i,1},'Centroid');
           
            fig=figure('visible', 'off');
            
            mask=Seq_Img_L{i,1};
            mask(mask==0)=150;

            imshow(mask,colorcube (150))

            for k=1:numel(s)
                c=s(k).Centroid;
                text(c(1),c(2),sprintf('%d',k),'Color','blue','HorizontalAlignment','center','VerticalAlignment','middle');
            end
            

            print('-f1', '-r300','-dpdf',['..\..\Segmented images data\' folder '\' name '\Skel_Labelled_' num2str(i) '.pdf'])
            
            close all
    end

end