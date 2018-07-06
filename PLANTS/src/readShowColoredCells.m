names={'Hypocotyl A','Hypocotyl B','root A','root B',...
    'katanin meristem A','katanin meristem B','WT meristem A',...
    'WT meristem B'};
subfolds={'col_hypocotyl_','col_hypocotyl_','root_','root_','katanin_meristem_',...
    'katanin_meristem_','WT_meristem_','WT_meristem_'};

for nNam=3:length(names)
    listImg=dir(['..\' names{nNam} '\splittedImage\' subfolds{nNam} names{nNam}(end) '*.tif']);
    imgCell=cell(size(listImg,1) ,1);
    
    for nImg=1:size(listImg,1) 
        imgCell{nImg}=imread(['..\' names{nNam} '\splittedImage\' subfolds{nNam} names{nNam}(end) num2str(nImg,'%03.0f') '.tif']); 
    end
    img3d=double(cat(3,imgCell{:}));
    
    save(['..\' names{nNam} '\image3d_' strrep(names{nNam},' ','_') '.mat'],'img3d','-v7.3');
    
%     mkdir([names{nNam} '\segmentedImage'])

%     totalCells=unique(img3d);
%     totalCells=totalCells(totalCells~=0)';
%     colours = jet(max(totalCells));
%     colours = colours(randperm(length(totalCells)), :);
%     colours= [0 0 0;colours];
%     
%     mkdir([names{nNam} '\segmentedImage\' ])
% 
%     for nImg=1:size(listImg,1) 
%         imshow(img3d(:,:,nImg),colours);
%         saveas(gca,[names{nNam} '\segmentedImage\' strrep(names{nNam},' ','_') '_' num2str(nImg) '.tif'])
% %         imwrite(img3d(:,:,nImg),colours,[names{nNam} '\segmentedImage\' strrep(names{nNam},' ','_') '_' num2str(nImg) '.tif']);
%     end
%     
%     h=figure;    
%     for nCell=totalCells
%         [x,y,z] = ind2sub(size(img3d),find(img3d==nCell));
%         shp=alphaShape(x,y,z,500);
%         plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
%         hold on
%     end
%     
%     savefig(h,[names{nNam} '\segmentedImage\image3d_' strrep(names{nNam},' ','_')]);
%     
end