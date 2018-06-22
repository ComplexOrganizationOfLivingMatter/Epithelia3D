names={'Hypocotyl A\splittedImage\col_hypocotyl_A','Hypocotyl B\col_hypocotyl_B'};

for nNam=1:length(names)
    listImg=dir([names{nNam} '*.tif']);
    imgCell=cell(size(listImg,1) ,1);
    for nImg=1:size(listImg,1) 
        imgCell{nImg}=imread([names{nNam} num2str(nImg,'%03.0f') '.tif']); 
    end
    
    img3d=double(cat(3,imgCell{:}));
    
    totalCells=unique(img3d);
    totalCells=totalCells(totalCells~=0)';
    c=jet(4000);
    figure;
    for nCell=totalCells
        [x,y,z] = ind2sub(size(img3d),find(img3d==nCell));
        shp=alphaShape(x,y,z,50);
        plot(shp)
        hold on
    end
end