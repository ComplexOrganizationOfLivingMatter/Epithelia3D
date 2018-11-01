function readImg3d(sampleName)

    dirImg = dir(['data\' sampleName '\splittedImage\*.tif');
    totalImg = cell(size(dirImg,1),1);
    for nImg = 1 :size(dirImg,1)
       totalImg{nImg} = imread(dirImg(nImg).name); 
    end

    img3d = cat(3,totalImg{:});
    img3d=uint16(img3d);
    img3d=imresize3(img3d,[size(img3d,1),size(img3d,2),size(img3d,3)/zScaleFactorHyp],'nearest');

    save(['data\image3d_' sampleName '.mat'],'img3d','-v7.3');

end