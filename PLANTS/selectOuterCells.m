clear
close all
names={'Hypocotyl A','Hypocotyl B'};

for nNam=1:length(names)
    load([names{nNam} '\image3d_' strrep(names{nNam},' ','_') '.mat'],'img3d');

    se=strel('sphere',20);

    mask=zeros(size(img3d));
    mask(img3d>0)=1;

    tic
    maskDilated=imdilate(logical(mask),se);
    toc
    maskEroded=imerode(maskDilated,se);
    
    maskPerim=bwperim(maskEroded,26);
    
    imgCellPerim=maskPerim.*img3d;
    outerCells=unique(imgCellPerim);
    outerCells=outerCells(outerCells~=0)';

    colours = jet(max(outerCells));
    colours = colours(randperm(max(outerCells)), :);
    
    
    centroids=regionprops3(img3d,'Centroid');
    centroids=cat(1,centroids.Centroid);
    h=figure;    
    for nCell=outerCells
        
%         plot3(centroids(nCell,1),centroids(nCell,2),centroids(nCell,3),'*')
        [x,y,z] = ind2sub(size(img3d),find(img3d==nCell));
        shp=alphaShape(x,y,z,500);
        plot(shp, 'FaceColor', colours(nCell, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
         hold on
    end
    
   savefig(h,[names{nNam} '\outerCells.fig']);
   save([names{nNam} '\outerCells.mat'],'outerCells')
end