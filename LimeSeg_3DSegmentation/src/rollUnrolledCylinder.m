%roll unrolled cylinder
cylPath = 'D:\Pedro\Epithelia3D\LimeSeg_3DSegmentation\basal_img.mat';
addpath(genpath('D:\Pedro\Epithelia3D\InSilicoModels\TubularModel\src\lib'));

load(cylPath,'cylindre2DImage')
unrollImage = cylindre2DImage;
[arrayX,arrayY] = find(unrollImage>0);
cropImage = unrollImage(min(arrayX):max(arrayX),min(arrayY):max(arrayY));
diameterMax = round(size(cropImage,2)/(2*pi))*2;
radiusMax = diameterMax/2;

mask3D = zeros(diameterMax+1,diameterMax+1,size(cropImage,1));
for nZ = 1:size(cropImage,1)
    
    rowImg = cropImage(nZ,:);
    arrayX = find(rowImg>0);
    rowIndexes = min(arrayX) : max(arrayX); 
    distPerim = length(rowIndexes);
    radius = distPerim/(2*pi);

    %pixels relocation from cylinder angle
    angleOfSeedsLocation=(360/distPerim)*rowIndexes;
    %initial location of seeds. 
    cylinderPos.x=round(radius*cosd(angleOfSeedsLocation)+radiusMax+1);
    cylinderPos.y=round(radius*sind(angleOfSeedsLocation)+radiusMax+1);
    cylinderPos.z=ones(1,length(cylinderPos.y)).*nZ;
    indexRow = sub2ind(size(mask3D),cylinderPos.x,cylinderPos.y,cylinderPos.z);
    
    mask3D(indexRow) = rowImg(rowIndexes);
    
end

paint3D(mask3D);