function [ newImg ] = getNoisyVoronoiDiagram(Img,noiseRatio)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    [H,W]=size(Img);

    centroids=regionprops(Img,'Centroid');
    centroids=cat(1,centroids.Centroid);
    
    seedList=[];
    for i=1:size(centroids,1)
        if ~isnan(centroids(i))
            %%Insert noise
            seed=centroids(i,:);
            imgAux=zeros(H,W);
            imgAux(round(seed(1,1)),round(seed(1,2)))=1;
            se = strel('disk',noiseRatio);
            circumference= imdilate(imgAux,se);
            PixelList = regionprops(circumference, 'PixelList');
            PixelList = fliplr(cat(1, PixelList.PixelList));
            imax=size(PixelList,1);
            [m] = RandWithoutRepetition(1,imax,1);
            seedList(end+1,:)=[i, PixelList(m,:)];
        end
    end
    
    %% Generate Voronoi from seeds%%
    newImg=zeros(H,W);

    % Add seeds
    for i=1:size(seedList,1)
        newImg(seedList(i,3),seedList(i,2))=1;
    end

    % Relabel cells
    D = bwdist(newImg);
    DL = watershed(D);
    bgm = DL == 0;
    Voronoi=bgm;
    L_img=bwlabel(1-Voronoi,8);
    auxImg=L_img;
    for i=1:size(seedList,1)
        auxImg(L_img==L_img(seedList(i,3),seedList(i,2))) = seedList(i,1);
    end
    
    newImg=auxImg;


end

