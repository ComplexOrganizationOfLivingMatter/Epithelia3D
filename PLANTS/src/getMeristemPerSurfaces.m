function [finalImages,setOfCellsLayer1,setOfCellsLayer2]=getMeristemPerSurfaces(folder,sampleName,zScaleFactorHyp,orderVault)
    
    disp(sampleName)
    if ~exist([folder sampleName '\image3d_' sampleName '.mat'],'file')
        img3d = readImg3d(folder, sampleName,zScaleFactorHyp);
        [x,y,z]=ind2sub(size(img3d),find(img3d>0));
        cropImg = img3d(min(x):max(x),min(y):max(y),min(z):max(z));
        img3d = addTipsImg3D(2,cropImg);
        paint3D((imresize3(img3d,0.1,'nearest')>0))
        save([folder sampleName '\image3d_' sampleName '.mat'],'-v7.3','img3d');
    else 
        load([folder sampleName '\image3d_' sampleName '.mat'],'img3d');
    end
    
    img3d=uint16(img3d);
    [H,W,c] = size(img3d);
    
    img3d_dil = imdilate(img3d,strel('sphere',2));
    img3d = imerode(img3d_dil,strel('sphere',2));
    propReg=regionprops3(img3d,'Volume');
    volumeCells=cat(1,propReg.Volume);
    minVolumeCell = max(volumeCells)/4;
    cells2del=find(volumeCells>0 & volumeCells<minVolumeCell);
    img3d(ismember(img3d,cells2del))=0;
    
    cellsLayer1 = unique(img3d(bwperim(imfill(img3d>0,26,'holes'))));
    layer1 = img3d.*uint16(ismember(img3d,cellsLayer1));
    centLayer1 = regionprops3(layer1>0,'Volume','Centroid');
    [~,idReg] = max(centLayer1.Volume);
    centLay1 = centLayer1.Centroid(idReg,:);
    
    cells2delLayer2 = unique([cellsLayer1;cells2del]);
    img3dNoLayer1 = img3d.*uint16(~ismember(img3d,cells2delLayer2));
    cellsLayer2 = unique(img3dNoLayer1(bwperim(imfill(img3dNoLayer1>0,26,'holes'))));
    layer2 = img3dNoLayer1.*uint16(ismember(img3dNoLayer1,cellsLayer2));
    centLayer2 = regionprops3(layer2>0,'Volume','Centroid');
    [~,idReg] = max(centLayer2.Volume);
    centLay2 = centLayer2.Centroid(idReg,:);
    
    
    %specify Z order
    if contains(orderVault,'zInvert')
        layer1 = layer1(:,:,round(centLay1(3)):end);
        layer2 = layer2(:,:,round(centLay2(3)):end);
        orderLayer1=size(layer1,3):-1:1;
        orderLayer2=size(layer2,3):-1:1;

    else
        layer1 = layer1(:,:,1:round(centLay1(3)));
        layer2 = layer2(:,:,1:round(centLay2(3)));
        orderLayer1=1:size(layer1,3);
        orderLayer2=1:size(layer2,3);

    end
    

    
    %% Get outer and inner surface in Layer 1
    
    layer1OuterSurface=uint16(zeros(H,W));
    for i=orderLayer1
        maskZ=layer1(:,:,i);
        layer1OuterSurface(layer1OuterSurface==0)=maskZ(layer1OuterSurface==0);
    end
    binaryFilterByArea = bwareafilt(layer1OuterSurface>0,1);
    layer1OuterSurface(binaryFilterByArea==0)=0;
    
    setOfCellsLayer1 = unique(layer1OuterSurface);  
    outerLayer3d = uint16(ismember(img3d,setOfCellsLayer1)).*img3d;
    
    %project inner part Of 1st layer of cells
    layer1InnerSurface=uint16(zeros(H,W));
    for i=wrev(orderLayer1)
        maskZ=outerLayer3d(:,:,i);
        layer1InnerSurface(layer1InnerSurface==0)=maskZ(layer1InnerSurface==0);
    end
    
    %% Get outer and inner surface in Layer 2
    layer2OuterSurface=uint16(zeros(H,W));
    for i=orderLayer2
        maskZ=layer2(:,:,i);
        layer2OuterSurface(layer2OuterSurface==0)=maskZ(layer2OuterSurface==0);
    end
    binaryFilterByArea = bwareafilt(layer2OuterSurface>0,1);
    layer2OuterSurface(binaryFilterByArea==0)=0;
    
    setOfCellsLayer2 = unique(layer2OuterSurface);  
    outerLayer3d = uint16(ismember(img3d,setOfCellsLayer2)).*img3d;
    
    %project inner part Of 1st layer of cells
    layer2InnerSurface=uint16(zeros(H,W));
    for i=wrev(orderLayer2)
        maskZ=outerLayer3d(:,:,i);
        layer2InnerSurface(layer2InnerSurface==0)=maskZ(layer2InnerSurface==0);
    end
    
    finalImages = {layer1OuterSurface,layer1InnerSurface,layer2OuterSurface,layer2InnerSurface};
    
    mkdir([folder sampleName '\imagesOfLayers\'])
    
    colors = jet(double(max(img3d(:))));
    randId = randperm(double(max(img3d(:))),double(max(img3d(:))));
    colors = colors(randId,:);
    colors(1,:) = [0 0 0];
    
    figure('Visible','off');imshow(layer1OuterSurface,colors);
    print([folder sampleName '\imagesOfLayers\outer1Color.tif'],'-dtiff')
    figure('Visible','off');imshow(layer1InnerSurface,colors);
    print([folder sampleName '\imagesOfLayers\inner1Color.tif'],'-dtiff')
    figure('Visible','off');imshow(layer2OuterSurface,colors);
    print([folder sampleName '\imagesOfLayers\outer2Color.tif'],'-dtiff')
    figure('Visible','off');imshow(layer2InnerSurface,colors);
    print([folder sampleName '\imagesOfLayers\inner2Color.tif'],'-dtiff')


end