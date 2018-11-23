%% Calculate SR in transition, for different rotation in regular hexagonal lattices
pixelsHexSide = 30;%use 10 factors...10*n
nSeedsW = 20;
nSeedsH = 20;
setOfDegRotation = 0:1:30;

path2save = 'data\tubularVoronoiModel\expansion\regularHexagons\';


SR = 1:0.5:25;

[hexLattice,seedsImg] = generateRegularHexagonalLattice(pixelsHexSide,nSeedsW,nSeedsH);

label2Follow = hexLattice(round(size(hexLattice,1)/2),round(size(hexLattice,2)/2));

neighs=calculateNeighbours(hexLattice);
neighLabel = neighs{label2Follow};
ring1Neigh = unique(vertcat(neighs{neighLabel}));
ring2Neigh = unique(vertcat(neighs{ring1Neigh}));
ring3Neigh = unique([ring2Neigh;vertcat(neighs{ring2Neigh})]);
ring4Neigh = unique([ring3Neigh;vertcat(neighs{ring3Neigh})]);
ring5Neigh = unique([ring4Neigh;vertcat(neighs{ring4Neigh})]);
ring6Neigh = unique([ring5Neigh;vertcat(neighs{ring5Neigh})]);
ring7Neigh = unique([ring6Neigh;vertcat(neighs{ring6Neigh})]);
ring8Neigh = unique([ring7Neigh;vertcat(neighs{ring7Neigh})]);
ring9Neigh = unique([ring8Neigh;vertcat(neighs{ring8Neigh})]);
ring10Neigh = unique([ring9Neigh;vertcat(neighs{ring9Neigh})]);
% ring11Neigh = unique([ring10Neigh;vertcat(neighs{ring10Neigh})]);
% ring12Neigh = unique([ring11Neigh;vertcat(neighs{ring11Neigh})]);
% ring13Neigh = unique([ring12Neigh;vertcat(neighs{ring12Neigh})]);
% ring14Neigh = unique([ring13Neigh;vertcat(neighs{ring13Neigh})]);
% ring15Neigh = unique([ring14Neigh;vertcat(neighs{ring14Neigh})]);



imgReduced = double(ismember(hexLattice,ring10Neigh)).*double(hexLattice);
[x,y] = find(imgReduced>0);
bBox = [min(y)-1 min(x)-1 (max(y)-min(y)+2) (max(x)-min(x)+2)];

hexCrop = imcrop(imgReduced,bBox);
imgSeedCrop = double(imcrop(seedsImg,bBox));
imgSeedCrop(hexCrop==0)=0;
imgSeedCrop(imgSeedCrop>0) = imgSeedCrop(imgSeedCrop>0).*double(hexCrop(imgSeedCrop>0));

% figure;imshow(double(hexCrop))
% figure;imshow(double(imgSeedCrop))


setImgHexLatticeByAngle=cell(length(setOfDegRotation),1);
setSeedsHexLatticeByAngle=cell(length(setOfDegRotation),1);

parfor degRotation = 1 : length(setOfDegRotation)

        
    imgSeedsRotate = imrotate(imgSeedCrop,setOfDegRotation(degRotation),'bilinear')>0;
    imgHexRotate = imrotate(hexCrop,setOfDegRotation(degRotation),'nearest');
    maskOpen = bwareaopen(imgHexRotate,20);
    imgHexRotate(maskOpen==0)=0;
    imgSeedsRotate = imgSeedsRotate.*imgHexRotate;
    
    bwMaskRot =  bwdist(imgSeedsRotate>0);
    hexLatticeRot = watershed(bwMaskRot);
%     figure;imshow(imgHexRotate,colorcube(200))
    centCellsRot = regionprops(imgHexRotate,'Centroid','Area');
    centCellsRot = cat(1,centCellsRot.Centroid);
    labels = find(~isnan(centCellsRot(:,1)));
    centCellsRot = round(centCellsRot(~isnan(centCellsRot(:,1)),:));
    %relabeling
    maskHexRotLat = zeros(size(hexLatticeRot));
    maskSeedHexRotLat = zeros(size(imgSeedsRotate));
    for nCent = 1 : size(centCellsRot,1)
        maskHexRotLat(hexLatticeRot == hexLatticeRot(centCellsRot(nCent,2),centCellsRot(nCent,1))) = labels(nCent);
        maskSeedHexRotLat(imgSeedsRotate == hexLatticeRot(centCellsRot(nCent,2),centCellsRot(nCent,1))) = labels(nCent);
    end
    
    centSeedsRotated = regionprops(imgSeedsRotate,'Centroid');
    centSeedsRotated = cat(1,centSeedsRotated.Centroid);
    centSeedsRotated = round(centSeedsRotated(~isnan(centSeedsRotated(:,1)),:));
    centSeedsRotated = [centSeedsRotated(:,2),centSeedsRotated(:,1)];
%     figure;imshow(maskHexRotLat,colorcube(200))

    setImgHexLatticeByAngle{degRotation} = maskHexRotLat;
    setSeedsHexLatticeByAngle{degRotation} = centSeedsRotated;
    path2save2 = [path2save 'rotation' strrep(num2str(setOfDegRotation(degRotation)),'.','_') '\'];
    mkdir(path2save2)
    filePath = [path2save2 'rotation' strrep(num2str(setOfDegRotation(degRotation)),'.','_') 'degrees.mat'];
    [neighsTarget,neighsAccum,hexLatticesExpanded] = calculateTransitionsInHexLattices(label2Follow,maskHexRotLat,centSeedsRotated,SR,filePath);
%     figure;imshow(double(maskHexRotLat),colorcube(200))
    disp(['hexagon rotation ' num2str(setOfDegRotation(degRotation))])
    
end
